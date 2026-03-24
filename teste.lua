
-- Deobfuscated Lua script
-- This script loads and executes an encrypted bytecode using a custom VM.

-- Helper: XOR decryption
local function xor_decrypt(str, key)
    local result = {}
    local key_len = #key
    for i = 1, #str do
        local byte = string.byte(str, i)
        local key_byte = string.byte(key, (i - 1) % key_len + 1)
        local xor_byte = bit32.bxor(byte, key_byte) % 256
        result[i] = string.char(xor_byte)
    end
    return table.concat(result)
end

-- Helper: bit extract (like bit32.extract)
local function bit_extract(n, from, to)
    if to then
        local width = to - from + 1
        local mask = bit32.lshift(1, width) - 1
        return bit32.band(bit32.rshift(n, from - 1), mask)
    else
        return bit32.band(bit32.rshift(n, from - 1), 1)
    end
end

-- Main decoder function
local function decode_and_execute(encoded_data, global_env, ...)
    local pos = 1
    local repeat_count = nil

    -- Decompress run‑length encoded data
    -- The pattern is a two‑byte sequence that marks compressed tokens
    local pattern = string.char(244, 65)  -- result of xor_decrypt("\134\233", "\114\168\199\122\141\216\208")
    encoded_data = string.gsub(string.sub(encoded_data, 5), pattern, function(match)
        if string.byte(match, 2) == 81 then  -- second byte is 'Q' (special marker)
            repeat_count = tonumber(string.sub(match, 1, 1))
            return ""
        else
            local char_code = tonumber(match, 16)  -- interpret the two bytes as hex number
            local char = string.char(char_code)
            if repeat_count then
                local repeated = string.rep(char, repeat_count)
                repeat_count = nil
                return repeated
            else
                return char
            end
        end
    end)

    -- Bytecode reader functions
    local function read_byte()
        local b = string.byte(encoded_data, pos)
        pos = pos + 1
        return b
    end

    local function read_ushort()
        local a = string.byte(encoded_data, pos)
        local b = string.byte(encoded_data, pos + 1)
        pos = pos + 2
        return a + b * 256
    end

    local function read_uint()
        local a = string.byte(encoded_data, pos)
        local b = string.byte(encoded_data, pos + 1)
        local c = string.byte(encoded_data, pos + 2)
        local d = string.byte(encoded_data, pos + 3)
        pos = pos + 4
        return a + b * 256 + c * 65536 + d * 16777216
    end

    local function read_double()
        local low = read_uint()
        local high = read_uint()
        local sign = 1
        local exponent = bit_extract(high, 21, 31)
        local mantissa = (bit_extract(high, 1, 20) * 2 ^ 32) + low
        if bit_extract(high, 32) == 1 then sign = -1 end
        if exponent == 0 then
            if mantissa == 0 then
                return sign * 0
            else
                exponent = 1
                -- denormalized number – handled by math.ldexp
            end
        elseif exponent == 2047 then
            if mantissa == 0 then
                return sign * (1 / 0)  -- infinity
            else
                return sign * (0 / 0)  -- NaN
            end
        end
        return math.ldexp(sign, exponent - 1023) * (1 + mantissa / 2 ^ 52)
    end

    local function read_string()
        local len = read_uint()
        if len == 0 then return "" end
        local s = string.sub(encoded_data, pos, pos + len - 1)
        pos = pos + len
        return s
    end

    local function pack_varargs(...)
        return { ... }, select("#", ...)
    end

    -- Build a function prototype from the bytecode
    local function build_prototype()
        local instructions = {}
        local upvalues = {}
        local localvars = {}  -- not used, kept for structure
        local proto = { instructions, upvalues, nil, localvars }

        local num_constants = read_uint()
        local constants = {}
        for i = 1, num_constants do
            local typ = read_byte()
            if typ == 1 then
                constants[i] = read_byte() ~= 0
            elseif typ == 2 then
                constants[i] = read_double()
            elseif typ == 3 then
                constants[i] = read_string()
            end
        end
        proto[3] = read_byte()  -- number of arguments

        local num_instructions = read_uint()
        for i = 1, num_instructions do
            local header = read_byte()
            if bit_extract(header, 1, 1) == 0 then
                local opcode = bit_extract(header, 2, 3)
                local flags = bit_extract(header, 4, 6)
                local inst = { read_ushort(), read_ushort(), nil, nil }
                if opcode == 0 then
                    inst[3] = read_ushort()
                    inst[4] = read_ushort()
                elseif opcode == 1 then
                    inst[3] = read_uint()
                elseif opcode == 2 then
                    inst[3] = read_uint() - 65536
                elseif opcode == 3 then
                    inst[3] = read_uint() - 65536
                    inst[4] = read_ushort()
                end
                if bit_extract(flags, 1, 1) == 1 then
                    inst[2] = constants[inst[2]]
                end
                if bit_extract(flags, 2, 2) == 1 then
                    inst[3] = constants[inst[3]]
                end
                if bit_extract(flags, 3, 3) == 1 then
                    inst[4] = constants[inst[4]]
                end
                instructions[i] = inst
            end
        end

        local num_upvalues = read_uint()
        for i = 1, num_upvalues do
            upvalues[i - 1] = build_prototype()
        end

        return proto
    end

    -- Create a closure (function) from a prototype
    local function create_closure(proto, upvalue_table, global_env)
        local instructions = proto[1]
        local upvalues = proto[2]
        local num_args = proto[3]

        return function(...)
            local pc = 1
            local stack_top = -1
            local stack = {}
            local args = { ... }
            local num_args_passed = select("#", ...)
            local varargs = {}
            local upvalue_tables = {}

            -- Initialize locals from arguments
            for i = 0, num_args_passed - 1 do
                if i < num_args then
                    stack[i] = args[i + 1]
                else
                    varargs[i - num_args] = args[i + 1]
                end
            end
            local num_varargs = num_args_passed - num_args

            -- Interpreter loop
            while true do
                local inst = instructions[pc]
                local op = inst[1]
                local a = inst[2]
                local b = inst[3]
                local c = inst[4]

                if op <= 10 then
                    if op <= 4 then
                        if op <= 1 then
                            if op == 0 then
                                -- Call function at stack[a] with arguments a+1 … stack_top
                                stack[a] = stack[a](unpack(stack, a + 1, stack_top))
                            else
                                -- Load global
                                stack[a] = global_env[b]
                            end
                        elseif op == 2 then
                            -- Conditional jump: if stack[a] is truthy, continue; else jump to b
                            if stack[a] then
                                pc = pc + 1
                            else
                                pc = b
                            end
                        elseif op == 3 then
                            -- Call that returns multiple values
                            local results, n = pack_varargs(stack[a](unpack(stack, a + 1, b)))
                            stack_top = a + n - 1
                            for i = a, stack_top do
                                stack[i] = results[i - a + 1]
                            end
                        else -- op == 4
                            -- Tail call
                            return stack[a](unpack(stack, a + 1, b))
                        end
                    elseif op <= 7 then
                        if op == 5 then
                            -- Conditional equality jump
                            if stack[a] == c then
                                pc = pc + 1
                            else
                                pc = b
                            end
                        elseif op == 6 then
                            -- Unconditional jump
                            pc = b
                        else -- op == 7
                            -- Set global
                            global_env[b] = stack[a]
                        end
                    elseif op == 8 then
                        -- Create closure with upvalues
                        local sub_proto = upvalues[b]
                        local upval_table = {}
                        local upval_mt = setmetatable({}, {
                            __index = function(t, k)
                                return upval_table[k][1][upval_table[k][2]]
                            end,
                            __newindex = function(t, k, v)
                                upval_table[k][1][upval_table[k][2]] = v
                            end
                        })
                        for i = 1, c do
                            pc = pc + 1
                            local up_inst = instructions[pc]
                            if up_inst[1] == 13 then
                                upval_table[i - 1] = { stack, up_inst[3] }
                            else
                                upval_table[i - 1] = { global_env, up_inst[3] }
                            end
                            upvalue_tables[#upvalue_tables + 1] = upval_table
                        end
                        stack[a] = create_closure(sub_proto, upval_table, global_env)
                    elseif op == 9 then
                        -- Return result of function call (no arguments)
                        return stack[a]()
                    else -- op == 10
                        -- Return multiple values from stack a … stack_top
                        return unpack(stack, a, stack_top)
                    end
                elseif op <= 15 then
                    if op <= 12 then
                        if op == 11 then
                            -- Clear stack slots
                            for i = a, b do
                                stack[i] = nil
                            end
                        elseif op == 12 then
                            -- Complex operation: creating a table and filling it
                            -- This is a linear sequence of instructions from the original state machine
                            stack[a] = global_env[b]
                            pc = pc + 1
                            inst = instructions[pc]
                            stack[inst[2]] = global_env[inst[3]]
                            pc = pc + 1
                            inst = instructions[pc]
                            stack[inst[2]] = {}
                            pc = pc + 1
                            inst = instructions[pc]
                            stack[inst[2]] = global_env[inst[3]]
                            pc = pc + 1
                            inst = instructions[pc]
                            stack[inst[2]] = stack[inst[3]]
                            pc = pc + 1
                            inst = instructions[pc]
                            local results, n = pack_varargs(stack[inst[2]](unpack(stack, inst[2] + 1, inst[3])))
                            stack_top = inst[2] + n - 1
                            for i = inst[2], stack_top do
                                stack[i] = results[i - inst[2] + 1]
                            end
                            pc = pc + 1
                            inst = instructions[pc]
                            for i = inst[2], inst[3] do
                                stack[i] = nil
                            end
                            pc = pc + 1
                            inst = instructions[pc]
                            local results2, n2 = pack_varargs(stack[inst[2]](unpack(stack, inst[2] + 1, inst[3])))
                            stack_top = inst[2] + n2 - 1
                            for i = inst[2], stack_top do
                                stack[i] = results2[i - inst[2] + 1]
                            end
                            pc = pc + 1
                            inst = instructions[pc]
                            local tbl = stack[inst[2]]
                            for i = inst[2] + 1, stack_top do
                                table.insert(tbl, stack[i])
                            end
                        else -- op == 13
                            -- Move value
                            stack[a] = stack[b]
                        end
                    elseif op == 14 then
                        -- Another complex sequence (similar to op 12)
                        stack[a] = b
                        pc = pc + 1
                        inst = instructions[pc]
                        local r = inst[2]
                        stack[r] = stack[r](unpack(stack, r + 1, inst[3]))
                        pc = pc + 1
                        inst = instructions[pc]
                        stack[inst[2]] = inst[3]
                        pc = pc + 1
                        inst = instructions[pc]
                        local results, n = pack_varargs(stack[inst[2]](unpack(stack, inst[2] + 1, inst[3])))
                        stack_top = inst[2] + n - 1
                        for i = inst[2], stack_top do
                            stack[i] = results[i - inst[2] + 1]
                        end
                        pc = pc + 1
                        inst = instructions[pc]
                        local r2 = inst[2]
                        stack[r2] = stack[r2](unpack(stack, r2 + 1, stack_top))
                        pc = pc + 1
                        inst = instructions[pc]
                        if stack[inst[2]] == inst[4] then
                            pc = pc + 1
                        else
                            pc = inst[3]
                        end
                    else -- op == 15
                        -- Create closure without upvalues
                        stack[a] = create_closure(upvalues[b], nil, global_env)
                    end
                elseif op <= 17 then
                    if op == 16 then
                        -- Return no values
                        return
                    else -- op == 17
                        -- Load constant number
                        stack[a] = b
                    end
                elseif op <= 19 then
                    if op == 18 then
                        -- Table index
                        stack[a] = stack[b][c]
                    else -- op == 19
                        -- Build list: append stack values to table at a
                        local tbl = stack[a]
                        for i = a + 1, stack_top do
                            table.insert(tbl, stack[i])
                        end
                    end
                else -- op == 20
                    -- Create new empty table
                    stack[a] = {}
                end

                pc = pc + 1
            end
        end
    end

    -- Build main prototype and execute
    local main_proto = build_prototype()
    local main_func = create_closure(main_proto, {}, global_env)
    return main_func(...)
end

-- The encrypted data (provided in the original script)
local encrypted_data = "\248\48\43\146\230\40\213\229\79\87\131\229\44\208\135\46\87\131\225\47\209\128\72\85\133\239\42\163\130\72\87\128\230\41\213\229\79\87\133\146\42\215\131\75\81\128\224\36\214\135\79\95\128\135\44\214\131\75\81\245\224\89\209\129\73\35\133\228\42\211\131\77\87\128\230\41\213\229\79\87\132\230\42\213\130\78\85\226\224\95\214\132\79\35\128\135\44\214\133\77\87\132\229\77\214\132\79\86\128\135\44\214\134\79\86\129\227\77\214\132\79\85\131\230\45\212\132\72\87\131\230\45\214\132\79\84\128\135\44\214\133\77\87\132\230\44\214\134\79\87\131\226\47\183\132\79\87\133\230\36\214\132\79\84\128\135\44\214\132\78\87\131\230\40\212\229\79\87\131\146\47\183\132\79\87\130\226\77\214\132\79\35\139\135\44\214\132\59\84\226\230\44\214\134\75\54\131\230\44\162\135\46\87\131\230\47\210\229\79\87\131\146\44\214\132\75\87\131\230\47\210\229\79\87\131\239\44\214\132\75\87\131\230\45\210\229\79\87\131\151\44\214\132\75\81\226\230\44\215\132\76\54\131\230\44\215\135\46\87\131\230\45\213\229\79\87\131\226\47\183\132\79\87\129\225\77\214\132\75\87\131\229\44\211\135\46\87\131\229\93\212\129\73\83\129\148\47\167\134\46\87\128\229\77\214\132\77\82\133\226\46\164\132\77\81\226\230\44\160\132\76\33\131\230\45\164\135\46\87\131\230\46\214\241\71\54\131\230\44\164\132\79\87\130\238\77\214\132\79\85\131\230\44\215\130\46\87\131\230\47\214\132\79\86\133\135\44\214\132\75\95\226\230\44\214\129\79\87\131\228\42\183\132\79\87\133\238\77\214\132\79\80\131\230\44\209\130\46\87\131\230\41\214\132\79\80\133\135\44\214\132\75\84\226\230\44\214\133\79\87\129\230\45\212\132\79\87\135\230\44\214\128\79\87\131\231\44\214\133\77\87\245\230\44\214\129\79\87\131\228\42\183\132\79\87\128\230\44\214\129\79\87\131\228\44\214\133\77\85\226\230\44\214\128\79\87\131\229\42\183\132\79\87\129\230\44\214\128\73\54\131\230\44\215\135\46\87\131\230\46\214\132\77\81\129\135\44\214\132\78\87\131\231\43\214\132\79\86\131\230\44\210\132\79\87\135\230\42\213\229\79\87\130\225\44\214\132\78\85\226\230\44\214\240\79\87\131\231\42\183\132\79\86\134\230\44\214\134\73\54\131\230\44\213\132\79\87\130\230\44\214\134\75\54\131\230\44\167\132\79\87\130\227\77\214\132\79\83\131\224\47\183\132\79\86\242\230\44\214\133\77\54\131\230\44\215\132\79\87\130\230\44\214\135\75\54\131\230\44\223\132\79\87\130\230\44\214\133\75\54\131\230\44\167\132\79\87\130\224\77\214\132\78\87\128\135\44\214\132\78\84\226\230\44\214\133\76\54\131\230\44\215\135\46\87\131\230\46\208\229\79\87\245\230\47\160\132\78\87\134\229\77\214\132\79\81\131\228\47\183\132\79\87\128\230\44\214\133\76\54\131\230\44\210\132\73\84\226\230\44\214\135\79\87\131\231\44\214\132\75\87\133\229\77\214\132\79\83\131\230\44\215\132\79\85\131\231\46\214\132\79\86\128\135\44\214\132\78\85\226\230\44\215\132\76\54\131\230\44\215\131\46\87\131"

local key = "\230\180\127\103\179\214\28"
local decrypted = xor_decrypt(encrypted_data, key)

-- Execute the decoded script with the current environment
return decode_and_execute(decrypted, getfenv(), ...)
