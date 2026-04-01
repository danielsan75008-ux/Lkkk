--[[
╔═══════════════════════════════════════════════════════╗
║            FFHX4ZZ hub   |  WindUI v2               ║
║   ESP Box2D + Chams + Tracers + Distance + Health     ║
║   Anti-AFK · Anti-Kick · Anti-Void · Performance     ║
║              PC & Mobile Ready                        ║
╚═══════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════
--  LOAD WindUI v2
-- ═══════════════════════════════════
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ═══════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")
local PhysicsService   = game:GetService("PhysicsService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ═══════════════════════════════════
--  ESTADO GLOBAL
-- ═══════════════════════════════════
local State = {
    TouchFling    = false,
    AntiFling     = false,
    GodMode       = false,
    _godConn      = nil,
    AntiVoid      = false,
    AntiStun      = false,
    DeleteRagdoll = false,
    AutoRejoin    = false,
    AntiAFK       = false,
    AntiKick      = false,
    WalkSpeed     = 16,
    JumpPower     = 50,
    SpeedEnabled  = false,
    JumpEnabled   = false,
    InfiniteJump  = false,
    AimbotEnabled = false,
    TeamCheck     = false,
    AimbotFOV     = 120,
    AimbotSmooth  = 5,
    ESPEnabled    = false,
    ESPColor      = Color3.fromRGB(255, 50, 50),
    ESPFill       = false,
    ESPFillAlpha  = 0.15,
    ChamEnabled   = false,
    ChamColor     = Color3.fromRGB(255, 100, 0),
    TracerEnabled = false,
    TracerColor   = Color3.fromRGB(0, 255, 128),
    DistESP       = false,
    HealthESP     = false,
    HitboxEnabled = false,
    HitboxSize    = 10,
    HitboxAlpha   = 0.7,
    HitboxColor   = "Really red",
    AntiLag          = false,
    FPSBoost         = false,
    DisableParticles = false,
    TextureLow       = false,
    RemoveDecals     = false,
    DynRender        = false,
    EntityLimiter    = false,
    LightingClean    = false,
    LowPoly          = false,
    VisibleCheck     = false,
    FreeCamera       = false,
    FreecamSpeed     = 1,
    FullBright       = false,
    NoFog            = false,
    NightMode        = false,
    CustomFOV        = 70,
    ObjTransparency  = 0,
    PanicActive      = false,
    _origBrightness  = nil,
    _origAmbient     = nil,
    _origFogEnd      = nil,
    _origFogStart    = nil,
    _origClockTime   = nil,
    _origFOV         = nil,
    
    -- v6.0 novas features
    AntiKnockback    = false,
    AntiSlow         = false,
    LunarGravity     = false,
    HideName         = false,
    SpectateTarget   = nil,
    DeathCount       = 0,

    -- v6.1 novas features
    AntiFreeze       = false,
    AntiSit          = false,
    GravitySlider    = 196.2,
    FastFall         = false,
    AirWalk          = false,
    Float            = false,
    Spin             = false,
    SpinPlayers      = false,
    NoFallDmg        = false,
    MoonWalk         = false,
    TeamCheckESP     = false,
    ScreenStretch    = false,
}

-- ═══════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════
local function getChar()
    return LocalPlayer.Character
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function isEnemy(p)
    if not State.TeamCheck and not State.TeamCheckESP then return true end
    return p.Team ~= LocalPlayer.Team
end

-- ═══════════════════════════════════
--  WINDOW
-- ═══════════════════════════════════
local Window = WindUI:CreateWindow({
    Title       = "FFHX4ZZ hub ",
    Icon        = "solar:rocket-bold",
    Author      = "by LUCCAS_W7VD",
    Folder      = "FFHX4ZZ hub ",
    Size        = UDim2.fromOffset(600, 500),
    Theme       = "Dark",
    Transparent = true,
})

-- ═══════════════════════════════════
--  TABS
-- ═══════════════════════════════════
local TabLogs    = Window:Tab({ Title = "Logs",       Icon = "solar:document-text-bold"  })
local TabUseful  = Window:Tab({ Title = "Useful",     Icon = "solar:bomb-bold"           })
local TabScripts = Window:Tab({ Title = "Scripts",    Icon = "solar:code-square-bold"    })
local TabPlayer  = Window:Tab({ Title = "Player",     Icon = "solar:running-round-bold"  })
local TabCombat  = Window:Tab({ Title = "Combat",     Icon = "solar:target-bold"         })
local TabPerf    = Window:Tab({ Title = "Desempenho", Icon = "solar:cpu-bolt-bold"       })
local TabSettings= Window:Tab({ Title = "Settings",   Icon = "solar:settings-bold"       })
local TabServerInfo = Window:Tab({ Title = "Server Info", Icon = "solar:server-bold"     })
local TabGUI        = Window:Tab({ Title = "GUI / UI",    Icon = "solar:palette-bold"    })

-- ══════════════════════════════════════════════════════
--  ABA: LOGS
-- ══════════════════════════════════════════════════════
do
    TabLogs:Section({ Title = "💬 Suporte" })

    TabLogs:Section({
        Title = "Aqui está o Discord caso ache um bug ou erro:",
    })

    TabLogs:Button({
        Title = "Copiar link do Discord",
        Desc  = "discord.gg/xzHe9QeqVv",
        Icon  = "link",
        Callback = function()
            setclipboard("https://discord.gg/xzHe9QeqVv")
            WindUI:Notify({
                Title    = "Discord",
                Content  = "Link copiado! discord.gg/xzHe9QeqVv",
                Duration = 3,
            })
        end,
    })

    TabLogs:Section({ Title = "📋 Histórico de Atualizações" })

    local changelog = {
        {
            ver   = "v6.1  —  New Features Update",
            items = {
                "[+] Player: Anti Freeze 🛡️ — impede congelamento de movimento",
                "[+] Player: Anti Sit 🧷 — impede forçar sentar",
                "[+] Player: Gravity Slider 🌍 — ajusta gravidade de 0 a 196",
                "[+] Player: FastFall ⬇️ — cai mais rápido",
                "[+] Player: AirWalk ☁️ — anda no ar",
                "[+] Player: Float 🎈 — flutua parado no ar",
                "[+] Player: Spin 🌀 — gira a 255 velocidade",
                "[+] Player: Spin Players (Visual) 🌀 — gira outros players localmente",
                "[+] Player: NoFall 🪂 — remove dano de queda",
                "[+] Player: MoonWalk 🌙 — movimento deslizante",
                "[+] Combat: Team Check ESP 🎯 — ESP ignora mesmo time",
                "[+] Useful: Find Empty Server 🔍 — teleporta para servidor vazio",
                "[+] Useful: Screen Stretch 🎭 — estica a tela verticalmente",
                "[\\] Ícone da janela atualizado para rocket",
            },
        },
        {
            ver   = "v6.0  —  Extra Features & Fixes",
            items = {
                "[+] Scripts: Desync, Invis Desync, CMD-X, Dark Dex adicionados",
                "[+] Player: Anti Knockback 🧱, Anti Stun, Anti Slow adicionados",
                "[+] Player: Simular Gravidade Lunar 🌙 adicionado",
                "[+] Player: Função Delete Ragdoll corrigida e aprimorada (sem erros)",
                "[+] Settings: Ocultar nome acima da cabeça",
                "[+] Settings: Sistema de Spectate (Visualizar e Teleportar para player)",
                "[+] Settings: Botão flutuante para trocar de câmera (1ª e 3ª pessoa)",
                "[+] Server Info: Contador automático de mortes ☠️ adicionado",
            },
        },
        {
            ver   = "v5.0  —  Major Expansion",
            items = {
                "[+] Settings: Rejoin button (same server)",
                "[+] Settings: FullBright toggle",
                "[+] Settings: No Fog toggle",
                "[+] Settings: Sky Changer (Night) toggle",
                "[+] Settings: Custom FOV slider (40-120)",
                "[+] Settings: Object Transparency slider",
                "[+] Settings: Config Load button",
                "[+] Settings: Reset Config button",
                "[+] Settings: Panic Key keybind",
                "[+] Combat: Visible Check toggle (raycast)",
                "[+] Player: Free Camera toggle",
                "[+] Player: Freecam Speed slider",
                "[+] NEW TAB: Server Info (Game, FPS, Ping)",
                "[+] NEW TAB: GUI/UI Theme System (24 pickers)",
            },
        },
        {
            ver   = "v4.0  —  Hitbox & Player Update",
            items = {
                "[\\] Hitbox funciona de dentro e de fora",
                "[\\] Hitbox nao trava players nem colide",
                "[\\] CanCollide=false + Massless=true nas parts",
                "[\\] CollisionGroup isolado anti-colisao",
                "[\\] Transparencia controla visibilidade real",
                "[\\] Logs reformatado com [\\ + -]",
                "[+] Noclip na aba Player",
                "[+] Fly na aba Player",
            },
        },
        {
            ver   = "v3.0  —  Mega Update",
            items = {
                "[+] Nome: FFHX4ZZ hub",
                "[+] Aba Logs com Discord + changelog",
                "[+] WindUI v2 (latest release)",
                "[+] Anti-AFK, Anti-Kick / Anti-Ban",
                "[+] God Mode (vida infinita)",
                "[+] Chams, Tracers, Distance ESP, Health ESP",
                "[+] Anti-Void, Anti-Stun, Delete Ragdoll",
                "[+] Auto Rejoin, Server Hopper inteligente",
                "[+] Aba Desempenho — 9 toggles",
                "[\\] ESP Box 2D mais preciso",
                "[\\] Compatibilidade mobile melhorada",
            },
        },
        {
            ver   = "v2.0",
            items = {
                "[+] ESP Box 2D com Drawing API",
                "[+] Aimbot com FOV Circle",
                "[+] Hitbox Expander com fill",
            },
        },
        {
            ver   = "v1.0  —  Lancamento",
            items = {
                "[+] Hub base com WindUI",
                "[+] WalkSpeed / JumpPower / InfiniteJump",
                "[+] Tools e GUIs via loadstring",
            },
        },
    }

    for _, entry in ipairs(changelog) do
        TabLogs:Section({ Title = "🔖 " .. entry.ver })
        local txt = ""
        for _, item in ipairs(entry.items) do
            txt = txt .. item .. "\n"
        end
        TabLogs:Section({ Title = txt })
    end
end

-- ══════════════════════════════════════════════════════
--  SISTEMAS
-- ══════════════════════════════════════════════════════

-- Noclip
local noclipConn = nil
local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = getChar()
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = true
        end
    end
end

-- Fly
local flyConn    = nil
local flyBody    = nil
local flyGyro    = nil
local FLY_SPEED  = 50

local function startFly()
    if flyConn then return end
    local root = getRoot()
    if not root then return end

    flyBody = Instance.new("BodyVelocity")
    flyBody.Velocity  = Vector3.zero
    flyBody.MaxForce  = Vector3.new(1e5, 1e5, 1e5)
    flyBody.Parent    = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyGyro.D         = 100
    flyGyro.CFrame    = root.CFrame
    flyGyro.Parent    = root

    flyConn = RunService.RenderStepped:Connect(function()
        local r = getRoot()
        if not r or not flyBody or not flyBody.Parent then
            stopFly(); return
        end
        local cam = Camera
        local dir = Vector3.zero
        local cf  = cam.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
           UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir = dir - Vector3.new(0, 1, 0)
        end

        flyBody.Velocity = dir.Magnitude > 0 and dir.Unit * FLY_SPEED or Vector3.zero
        flyGyro.CFrame = cf
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody and flyBody.Parent then flyBody:Destroy() end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy() end
    flyBody = nil; flyGyro = nil
end

-- Touch Fling
local touchConn = nil
local function startFling()
    if touchConn then return end
    touchConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p ~= root
               and (p.Position - root.Position).Magnitude < 5 then
                local bv    = Instance.new("BodyVelocity")
                bv.Velocity = (p.Position - root.Position).Unit * -500
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.P        = 1e9
                bv.Parent   = p
                game:GetService("Debris"):AddItem(bv, 0.1)
            end
        end
    end)
end
local function stopFling()
    if touchConn then touchConn:Disconnect(); touchConn = nil end
end

-- Anti-Fling
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart")
               and p.AssemblyLinearVelocity.Magnitude > 200 then
                p.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- God Mode
local function applyGodMode(hum)
    if State._godConn then State._godConn:Disconnect() end
    hum.MaxHealth = math.huge
    hum.Health    = math.huge
    State._godConn = hum.HealthChanged:Connect(function()
        if State.GodMode then hum.Health = math.huge end
    end)
end
local function removeGodMode(hum)
    if State._godConn then State._godConn:Disconnect(); State._godConn = nil end
    hum.MaxHealth = 100
    hum.Health    = 100
end

-- Anti-Void
local antiVoidConn = nil
local safePos      = Vector3.new(0, 50, 0)
local function startAntiVoid()
    if antiVoidConn then return end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        if root.Position.Y > -50 then
            safePos = root.Position
        else
            root.CFrame = CFrame.new(safePos)
        end
    end)
end
local function stopAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn = nil end
end

-- Anti-Stun
local antiStunConn = nil
local function startAntiStun()
    if antiStunConn then return end
    antiStunConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum then return end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Stunned
           or s == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
local function stopAntiStun()
    if antiStunConn then antiStunConn:Disconnect(); antiStunConn = nil end
end

-- Anti-Knockback (v6.0)
local akConn = nil
local function startAntiKnockback()
    if akConn then return end
    akConn = RunService.Heartbeat:Connect(function()
        if not State.AntiKnockback then return end
        local root = getRoot()
        local hum = getHum()
        if root and hum then
            -- Se não estiver tentando se mover ativamente, zera a força de empurrão
            if hum.MoveDirection.Magnitude == 0 and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                local vel = root.AssemblyLinearVelocity
                if Vector3.new(vel.X, 0, vel.Z).Magnitude > 5 then
                    root.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                end
            end
        end
    end)
end
local function stopAntiKnockback()
    if akConn then akConn:Disconnect(); akConn = nil end
end

-- Anti-Slow (v6.0)
local asConn = nil
local function startAntiSlow()
    if asConn then return end
    asConn = RunService.Heartbeat:Connect(function()
        if not State.AntiSlow then return end
        local hum = getHum()
        if hum then
            local desiredSpeed = State.SpeedEnabled and State.WalkSpeed or 16
            if hum.WalkSpeed < desiredSpeed then
                hum.WalkSpeed = desiredSpeed
            end
        end
    end)
end
local function stopAntiSlow()
    if asConn then asConn:Disconnect(); asConn = nil end
end

-- Delete Ragdoll (Corrigido v6.0)
local function deleteRagdoll()
    local char = getChar()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        pcall(function()
            if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint")
               or (v.Name and v.Name:lower():match("ragdoll")) then
                v:Destroy()
            end
        end)
    end
end

-- Anti-AFK
local antiAFKConn = nil
local function startAntiAFK()
    if antiAFKConn then return end
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Anti-AFK", Text = "Kick evitado!", Duration = 2,
                })
            end)
        end
    end)
    antiAFKConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true,  Enum.KeyCode.W, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    end)
end
local function stopAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn = nil end
end

-- Anti-Kick
local kickHooked = false
local function hookAntiKick()
    if kickHooked then return end
    kickHooked = true
    local mt = getrawmetatable and getrawmetatable(game)
    if not mt then return end
    local oldNC = mt.__namecall
    pcall(setreadonly, mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if method == "Kick" and self == LocalPlayer and State.AntiKick then
            WindUI:Notify({ Title="Anti-Kick", Content="Kick bloqueado!", Duration=3 })
            return
        end
        return oldNC(self, ...)
    end)
    pcall(setreadonly, mt, true)
end

-- Auto Rejoin
local function setupAutoRejoin()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed and State.AutoRejoin then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId, game.JobId, LocalPlayer
            )
        end
    end)
end

-- Server Hopper
local hopperActive = false
local function startServerHop()
    if hopperActive then return end
    hopperActive = true
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=25"
            ))
        end)
        if ok and data and data.data then
            local best, bestPing = nil, math.huge
            for _, s in ipairs(data.data) do
                local ping = s.ping or 9999
                if s.id ~= game.JobId and s.playing and s.maxPlayers
                   and s.playing < s.maxPlayers and ping < bestPing then
                    best = s; bestPing = ping
                end
            end
            if best then
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Conectando...", Duration = 3,
                })
                task.wait(2)
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId, best.id, LocalPlayer
                )
            else
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Nenhum server melhor.", Duration = 3,
                })
            end
        end
        hopperActive = false
    end)
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ══════════════════════════════════════════════════════
--  PERFORMANCE
-- ══════════════════════════════════════════════════════
local removedDecals   = {}
local origMaterials   = {}
local dynConn         = nil
local entityConn      = nil

local function disableParticles(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke")
           or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not on
        end
    end
end

local function setTextureLow(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if on then
                origMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif origMaterials[v] then
                pcall(function() v.Material = origMaterials[v] end)
            end
        end
    end
end

local function removeDecals(on)
    if on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                table.insert(removedDecals, { obj = v, par = v.Parent })
                v.Parent = nil
            end
        end
    else
        for _, e in ipairs(removedDecals) do
            pcall(function() e.obj.Parent = e.par end)
        end
        removedDecals = {}
    end
end

local function cleanLighting(on)
    if on then
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 1e6
        Lighting.FogStart      = 1e6
        Lighting.Brightness    = 2
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
               or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
               or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    else
        Lighting.GlobalShadows = true
        for _, v in ipairs(Lighting:GetChildren()) do
            pcall(function() v.Enabled = true end)
        end
    end
end

local function setLowPoly(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") then
            pcall(function() v.LODFactor = on and 0.25 or 1 end)
        end
    end
end

local function setDynRender(on)
    if dynConn then dynConn:Disconnect(); dynConn = nil end
    if on then
        dynConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                settings().Rendering.QualityLevel =
                    (LocalPlayer.NetworkPing or 0) > 0.15 and 1 or 5
            end)
        end)
    else
        pcall(function() settings().Rendering.QualityLevel = 5 end)
    end
end

local function setEntityLimiter(on)
    if entityConn then entityConn:Disconnect(); entityConn = nil end
    if on then
        entityConn = RunService.Heartbeat:Connect(function()
            local n = 0
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then
                    n = n + 1
                    if n > 80 then v:Destroy() end
                end
            end
        end)
    end
end

local function applyFPSBoost(on)
    pcall(function()
        settings().Rendering.QualityLevel = on and 1 or 5
    end)
    if on then cleanLighting(true); disableParticles(true) end
end

local function applyAntiLag(on)
    if on then
        pcall(function()
            settings().Physics.PhysicsEnvironmentalThrottle =
                Enum.EnviromentalPhysicsThrottle.Disabled
        end)
    end
end

-- ══════════════════════════════════════════════════════
--  ESP E OBJETOS (Hitbox, FOV, etc)
-- ══════════════════════════════════════════════════════
-- (Todo o código do ESP nativo, Box 2D e FOV Circle se mantém sem alterações estruturais)

local espObjects = {}
local espHighlights = {}

local function mkLine(col, thick)
    local l = Drawing.new("Line")
    l.Visible = false; l.Color = col or Color3.fromRGB(255,50,50); l.Thickness = thick or 1.5
    pcall(function() l.AlwaysOnTop = true end)
    return l
end
local function mkText(size, col)
    local t = Drawing.new("Text")
    t.Visible = false; t.Size = size or 14; t.Outline = true; t.Color = col or Color3.fromRGB(255,255,255); t.Text = ""
    pcall(function() t.AlwaysOnTop = true end)
    return t
end
local function mkQuad()
    local q = Drawing.new("Quad")
    q.Visible = false; q.Filled = true; q.Color = Color3.fromRGB(255,50,50); q.Transparency = 0.85
    pcall(function() q.AlwaysOnTop = true end)
    return q
end

local function removeHighlight(player)
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
end
local function applyHighlight(player)
    removeHighlight(player)
    if not State.ESPEnabled then return end
    local char = player.Character
    if not char then return end
    local hl = Instance.new("Highlight")
    hl.Adornee = char; hl.FillColor = State.ESPColor; hl.OutlineColor = State.ESPColor
    hl.FillTransparency = 0.6; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    espHighlights[player] = hl
end

local function cleanESP(player)
    local o = espObjects[player]
    if not o then return end
    for _, l in ipairs(o.lines) do l:Remove() end
    o.label:Remove(); o.fill:Remove()
    o.tracer:Remove(); o.dist:Remove()
    o.hpBg:Remove();  o.hpBar:Remove()
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    espObjects[player] = nil
    removeHighlight(player)
end

local function buildESP(player)
    cleanESP(player)
    local lines = {}
    for _ = 1, 4 do table.insert(lines, mkLine()) end
    espObjects[player] = {
        lines = lines, label = mkText(14), fill = mkQuad(), tracer = mkLine(State.TracerColor, 1.5),
        dist = mkText(12, Color3.fromRGB(255, 220, 80)), hpBg = mkLine(Color3.fromRGB(40, 40, 40), 4),
        hpBar = mkLine(Color3.fromRGB(0, 220, 80), 4), chams = {}
    }
end

local function applyCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
    local char = player.Character
    if not char then return end
    local sb = Instance.new("SelectionBox")
    sb.Color3 = State.ChamColor; sb.LineThickness = 0.05
    sb.SurfaceColor3 = State.ChamColor; sb.SurfaceTransparency = 0.5
    sb.Adornee = char; sb.Parent = workspace
    table.insert(o.chams, sb)
end

local function removeCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
end

local function getBox(char)
    local parts = {}
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            local isHitboxExpanded = (v.Transparency >= 1 and v.Size.X > 4 and v.Size.Y > 4)
            if not isHitboxExpanded then table.insert(parts, v) end
        end
    end
    if #parts == 0 then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then table.insert(parts, v) end
        end
    end
    if #parts == 0 then return nil end

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyVisible = false

    for _, part in ipairs(parts) do
        local sz = part.Size * 0.5
        local cf = part.CFrame
        local corners = {
            cf * Vector3.new( sz.X,  sz.Y,  sz.Z), cf * Vector3.new(-sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new( sz.X, -sz.Y,  sz.Z), cf * Vector3.new(-sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new( sz.X,  sz.Y, -sz.Z), cf * Vector3.new(-sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new( sz.X, -sz.Y, -sz.Z), cf * Vector3.new(-sz.X, -sz.Y, -sz.Z),
        }
        for _, corner in ipairs(corners) do
            local sp = Camera:WorldToViewportPoint(corner)
            if sp.Z > 0 then
                anyVisible = true
                if sp.X < minX then minX = sp.X end
                if sp.Y < minY then minY = sp.Y end
                if sp.X > maxX then maxX = sp.X end
                if sp.Y > maxY then maxY = sp.Y end
            end
        end
    end
    if not anyVisible then return nil end
    local pad = 2
    return {
        tl = Vector2.new(minX - pad, minY - pad), tr = Vector2.new(maxX + pad, minY - pad),
        br = Vector2.new(maxX + pad, maxY + pad), bl = Vector2.new(minX - pad, maxY + pad),
        cx = (minX + maxX) / 2, top = minY - pad, bot = maxY + pad,
    }
end

local hitboxConn = nil
local function removeHitbox()
    if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        pcall(function()
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = false
                hrp.Material = Enum.Material.SmoothPlastic
            end
        end)
    end
end
local function startHitbox()
    if hitboxConn then return end
    hitboxConn = RunService.Heartbeat:Connect(function()
        if not State.HitboxEnabled then return end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl == LocalPlayer then continue end
            pcall(function()
                local char = pl.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local s = State.HitboxSize or 10
                hrp.Size = Vector3.new(s, s, s)
                hrp.Transparency = State.HitboxAlpha
                hrp.BrickColor = BrickColor.new(State.HitboxColor or "Really red")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end)
        end
    end)
end
local function refreshHitboxes()
    if State.HitboxEnabled then startHitbox() else removeHitbox() end
end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false; fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Thickness = 1.5; fovCircle.Filled = false

local function getTarget()
    local best, bestD = nil, math.huge
    local cx = Camera.ViewportSize.X / 2; local cy = Camera.ViewportSize.Y / 2
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if not isEnemy(pl) then continue end
        local ch = pl.Character
        if not ch then continue end
        local hd = ch:FindFirstChild("Head")
        if not hd then continue end
        local sp, on = Camera:WorldToViewportPoint(hd.Position)
        if not on then continue end
        if State.VisibleCheck then
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character, ch}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(Camera.CFrame.Position, (hd.Position - Camera.CFrame.Position), rp)
            if result then continue end
        end
        local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
        if d < State.AimbotFOV and d < bestD then
            best = hd; bestD = d
        end
    end
    return best
end

-- ══════════════════════════════════════════════════════
--  SISTEMAS EXTRAS (VISUALS & v6.0)
-- ══════════════════════════════════════════════════════
local function setFullBright(on)
    if on then
        State._origBrightness = Lighting.Brightness; State._origAmbient = Lighting.Ambient
        Lighting.Brightness = 2; Lighting.Ambient = Color3.fromRGB(178, 178, 178); Lighting.GlobalShadows = false
    else
        if State._origBrightness then Lighting.Brightness = State._origBrightness end
        if State._origAmbient    then Lighting.Ambient    = State._origAmbient    end
        Lighting.GlobalShadows = true
    end
end

local function setNoFog(on)
    if on then
        State._origFogEnd = Lighting.FogEnd; State._origFogStart = Lighting.FogStart
        Lighting.FogEnd = 1e9; Lighting.FogStart = 1e9
    else
        if State._origFogEnd then Lighting.FogEnd = State._origFogEnd end
        if State._origFogStart then Lighting.FogStart = State._origFogStart end
    end
end

local function setNightMode(on)
    if on then
        State._origClockTime = Lighting.ClockTime; Lighting.ClockTime = 0
    else
        if State._origClockTime then Lighting.ClockTime = State._origClockTime end
    end
end

local function setFOV(v)
    if not State._origFOV then State._origFOV = Camera.FieldOfView end
    Camera.FieldOfView = v
end
local function resetFOV()
    if State._origFOV then Camera.FieldOfView = State._origFOV end
end

local function setObjTransparency(v)
    local charModels = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then charModels[pl.Character] = true end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local inChar = false; local p = obj.Parent
            while p do
                if charModels[p] then inChar = true; break end
                p = p.Parent
            end
            if not inChar then pcall(function() obj.Transparency = v end) end
        end
    end
end

local freecamConn = nil; local freecamEnabled = false; local freecamCF = CFrame.new()
local function startFreeCamera()
    if freecamConn then return end
    freecamEnabled = true; freecamCF = Camera.CFrame; Camera.CameraType = Enum.CameraType.Scriptable
    freecamConn = RunService.RenderStepped:Connect(function(dt)
        if not freecamEnabled then return end
        local spd = State.FreecamSpeed * 20 * dt; local cf = freecamCF; local move = Vector3.zero
        local uis = UserInputService
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            freecamCF = CFrame.new(cf.Position + move.Unit * spd) * (cf - cf.Position)
        end
        Camera.CFrame = freecamCF
    end)
end
local function stopFreeCamera()
    freecamEnabled = false
    if freecamConn then freecamConn:Disconnect(); freecamConn = nil end
    Camera.CameraType = Enum.CameraType.Custom
end

local panicHidden = false

-- Lunar Gravity
local origGravity = workspace.Gravity
local function setLunarGravity(on)
    if on then
        origGravity = workspace.Gravity
        workspace.Gravity = 35
    else
        workspace.Gravity = origGravity
    end
end

-- Hide Name
local function setHideName(on)
    State.HideName = on
    local hum = getHum()
    if hum then
        hum.DisplayDistanceType = on and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end
end

local Theme = {
    TextColor        = Color3.fromRGB(240, 240, 255),
    LabelColor       = Color3.fromRGB(200, 200, 220),
    TitleColor       = Color3.fromRGB(255, 255, 255),
    DescriptionColor = Color3.fromRGB(160, 160, 180),
    BackgroundColor  = Color3.fromRGB(13,  13,  15 ),
    WindowColor      = Color3.fromRGB(20,  20,  30 ),
    AccentColor      = Color3.fromHex("#7B2FFF"),
    PrimaryColor     = Color3.fromHex("#7B2FFF"),
    SecondaryColor   = Color3.fromHex("#FF2FA0"),
    ButtonColor      = Color3.fromRGB(30,  30,  46 ),
    ButtonTextColor  = Color3.fromRGB(240, 240, 255),
    ButtonActive     = Color3.fromHex("#7B2FFF"),
    BorderColor      = Color3.fromRGB(42,  42,  53 ),
    GlowColor        = Color3.fromHex("#7B2FFF"),
    HighlightColor   = Color3.fromHex("#FF2FA0"),
    ToggleColor      = Color3.fromHex("#7B2FFF"),
    SliderColor      = Color3.fromHex("#7B2FFF"),
    DropdownColor    = Color3.fromRGB(30,  30,  46 ),
}
local function applyTheme()
    pcall(function()
        WindUI:AddTheme({
            Name = "HubTheme", Accent = Theme.AccentColor, Background = Theme.BackgroundColor,
            Outline = Theme.BorderColor, Text = Theme.TextColor, Placeholder = Theme.DescriptionColor,
            Button = Theme.ButtonColor, Icon = Theme.AccentColor,
        })
        WindUI:SetTheme("HubTheme")
    end)
end

-- ══════════════════════════════════════════════════════
--  RENDER LOOP
-- ══════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    local vcx = Camera.ViewportSize.X / 2
    local vcy = Camera.ViewportSize.Y / 2

    fovCircle.Position = Vector2.new(vcx, vcy)
    fovCircle.Radius   = State.AimbotFOV
    fovCircle.Visible  = State.AimbotEnabled

    if State.AimbotEnabled then
        local tgt = getTarget()
        if tgt then
            local alpha = 1 / (State.AimbotSmooth + 1)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, tgt.Position), alpha)
        end
    end

    local bottomY = Camera.ViewportSize.Y
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        -- Team Check ESP: skip teammates
        if State.TeamCheckESP and player.Team == LocalPlayer.Team then
            local o2 = espObjects[player]
            if o2 then
                for _, l in ipairs(o2.lines) do l.Visible = false end
                o2.label.Visible = false; o2.fill.Visible = false
                o2.tracer.Visible = false; o2.dist.Visible = false
                o2.hpBg.Visible = false; o2.hpBar.Visible = false
            end
            continue
        end
        if not espObjects[player] then buildESP(player) end
        local o = espObjects[player]
        if not o then continue end
        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
        local anyOn = State.ESPEnabled or State.TracerEnabled or State.DistESP or State.HealthESP

        if not char or not root or not anyOn then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
            o.tracer.Visible= false; o.dist.Visible = false
            o.hpBg.Visible  = false; o.hpBar.Visible = false
            continue
        end

        local box = getBox(char)
        if not box then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
            o.tracer.Visible= false; o.dist.Visible = false
            o.hpBg.Visible  = false; o.hpBar.Visible = false
            continue
        end

        local col = State.ESPColor
        if State.ESPEnabled then
            local corners = { box.tl, box.tr, box.br, box.bl }
            for i = 1, 4 do
                o.lines[i].From = corners[i]; o.lines[i].To = corners[(i % 4) + 1]
                o.lines[i].Color = col; o.lines[i].Visible = true
            end
            o.label.Text = player.Name; o.label.Color = col
            o.label.Position = Vector2.new(box.cx, box.top - 16); o.label.Visible = true
            o.fill.PointA = box.tl; o.fill.PointB = box.tr; o.fill.PointC = box.br; o.fill.PointD = box.bl
            o.fill.Color = col; o.fill.Transparency = 1 - State.ESPFillAlpha; o.fill.Visible = State.ESPFill
        else
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
        end

        if State.TracerEnabled and root then
            local sp, _ = Camera:WorldToViewportPoint(root.Position)
            o.tracer.From = Vector2.new(vcx, bottomY); o.tracer.To = Vector2.new(sp.X, sp.Y)
            o.tracer.Color = State.TracerColor; o.tracer.Visible = true
        else
            o.tracer.Visible = false
        end

        if State.DistESP and root then
            local myRoot = getRoot()
            if myRoot then
                local d = math.floor((root.Position - myRoot.Position).Magnitude)
                o.dist.Text = d .. " studs"; o.dist.Position = Vector2.new(box.cx, box.bot + 3)
                o.dist.Visible = true
            else
                o.dist.Visible = false
            end
        else
            o.dist.Visible = false
        end

        if State.HealthESP and hum then
            local ratio = hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth) or 0
            local barX = box.tl.X - 5; local barH = box.bot - box.top
            o.hpBg.From = Vector2.new(barX, box.top); o.hpBg.To = Vector2.new(barX, box.bot); o.hpBg.Visible = true
            o.hpBar.From = Vector2.new(barX, box.bot); o.hpBar.To = Vector2.new(barX, box.bot - barH * ratio)
            o.hpBar.Color = Color3.fromRGB(math.floor(255 * (1 - ratio)), math.floor(255 * ratio), 50); o.hpBar.Visible = true
        else
            o.hpBg.Visible = false; o.hpBar.Visible = false
        end
    end
end)

-- ══════════════════════════════════════════════════════
--  PLAYER EVENTS (Death Counter, Spawn, etc)
-- ══════════════════════════════════════════════════════
local deathLabelUi = nil -- Será atualizada pela Tab Server Info

local function connectCharacterEvents(pl)
    pl.CharacterAdded:Connect(function(char)
        buildESP(pl)
        if State.ESPEnabled then task.spawn(function() task.wait() applyHighlight(pl) end) end
        if State.HitboxEnabled then
            if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
            task.wait()
            startHitbox()
        end
        if State.ChamEnabled then applyCham(pl) end
    end)
end

for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LocalPlayer then
        buildESP(pl); connectCharacterEvents(pl)
        if State.HitboxEnabled and pl.Character then task.spawn(function() applyHitbox(pl) end) end
        if State.ESPEnabled and pl.Character then task.spawn(function() applyHighlight(pl) end) end
    end
end

Players.PlayerAdded:Connect(function(pl)
    buildESP(pl); connectCharacterEvents(pl)
end)
Players.PlayerRemoving:Connect(function(pl)
    cleanESP(pl); removeHitbox(pl)
end)

-- Nosso próprio respawn e monitor de morte
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if State.SpeedEnabled then hum.WalkSpeed = State.WalkSpeed end
        if State.JumpEnabled  then hum.JumpPower  = State.JumpPower  end
        if State.GodMode then applyGodMode(hum) end
        
        -- Atualiza nome escondido
        if State.HideName then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        
        -- Tracker de Mortes
        hum.Died:Connect(function()
            State.DeathCount = State.DeathCount + 1
            if deathLabelUi then pcall(function() deathLabelUi.Title = "☠️ Mortes: " .. State.DeathCount end) end
        end)
    end
    if State.HitboxEnabled then refreshHitboxes() end
    if State.DeleteRagdoll then deleteRagdoll() end
end)

setupAutoRejoin()

-- ══════════════════════════════════════════════════════
--  SISTEMAS v6.1 — NOVAS FEATURES
-- ══════════════════════════════════════════════════════

-- Anti Freeze
local antiFreezeConn = nil
local function startAntiFreeze()
    if antiFreezeConn then return end
    antiFreezeConn = RunService.Heartbeat:Connect(function()
        if not State.AntiFreeze then return end
        local hum = getHum()
        if not hum then return end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Physics
        or s == Enum.HumanoidStateType.None then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        local root = getRoot()
        if root then
            local vel = root.AssemblyLinearVelocity
            if vel == Vector3.zero and hum.MoveDirection.Magnitude > 0 then
                root.AssemblyLinearVelocity = Vector3.new(
                    hum.MoveDirection.X * hum.WalkSpeed,
                    vel.Y,
                    hum.MoveDirection.Z * hum.WalkSpeed
                )
            end
        end
    end)
end
local function stopAntiFreeze()
    if antiFreezeConn then antiFreezeConn:Disconnect(); antiFreezeConn = nil end
end

-- Anti Sit
local antiSitConn = nil
local function startAntiSit()
    if antiSitConn then return end
    antiSitConn = RunService.Heartbeat:Connect(function()
        if not State.AntiSit then return end
        local hum = getHum()
        if hum and hum:GetState() == Enum.HumanoidStateType.Seated then
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
local function stopAntiSit()
    if antiSitConn then antiSitConn:Disconnect(); antiSitConn = nil end
end

-- Gravity Slider
local _origGravitySlider = workspace.Gravity
local function setGravity(v)
    State.GravitySlider = v
    workspace.Gravity = v
end
local function resetGravity()
    workspace.Gravity = _origGravitySlider
end

-- FastFall
local fastFallConn = nil
local function startFastFall()
    if fastFallConn then return end
    fastFallConn = RunService.Heartbeat:Connect(function()
        if not State.FastFall then return end
        local root = getRoot()
        if not root then return end
        local vel = root.AssemblyLinearVelocity
        if vel.Y < 0 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, vel.Y - 4, vel.Z)
        end
    end)
end
local function stopFastFall()
    if fastFallConn then fastFallConn:Disconnect(); fastFallConn = nil end
end

-- AirWalk
local airWalkConn  = nil
local airWalkPart  = nil
local function startAirWalk()
    if airWalkConn then return end
    airWalkConn = RunService.Heartbeat:Connect(function()
        if not State.AirWalk then
            if airWalkPart and airWalkPart.Parent then airWalkPart:Destroy(); airWalkPart = nil end
            return
        end
        local root = getRoot()
        if not root then return end
        local hum  = getHum()
        if not hum then return end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Freefall or s == Enum.HumanoidStateType.Jumping then
            if not airWalkPart or not airWalkPart.Parent then
                airWalkPart = Instance.new("Part")
                airWalkPart.Size = Vector3.new(4, 0.2, 4)
                airWalkPart.Anchored = true
                airWalkPart.CanCollide = true
                airWalkPart.Transparency = 1
                airWalkPart.Name = "_AirWalkPlatform"
                airWalkPart.Parent = workspace
            end
            airWalkPart.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3, root.Position.Z)
        else
            if airWalkPart and airWalkPart.Parent then airWalkPart:Destroy(); airWalkPart = nil end
        end
    end)
end
local function stopAirWalk()
    if airWalkConn then airWalkConn:Disconnect(); airWalkConn = nil end
    if airWalkPart and airWalkPart.Parent then airWalkPart:Destroy(); airWalkPart = nil end
end

-- Float
local floatConn = nil
local floatBody = nil
local function startFloat()
    if floatConn then return end
    local root = getRoot()
    if not root then return end
    floatBody = Instance.new("BodyPosition")
    floatBody.Position = root.Position
    floatBody.MaxForce = Vector3.new(0, 1e5, 0)
    floatBody.D = 1000
    floatBody.P = 10000
    floatBody.Parent = root
    floatConn = RunService.Heartbeat:Connect(function()
        if not State.Float then stopFloat(); return end
        local r = getRoot()
        if r and floatBody and floatBody.Parent then
            floatBody.Position = Vector3.new(r.Position.X, floatBody.Position.Y, r.Position.Z)
        end
    end)
end
local function stopFloat()
    if floatConn then floatConn:Disconnect(); floatConn = nil end
    if floatBody and floatBody.Parent then floatBody:Destroy() end
    floatBody = nil
end

-- Spin (local player)
local spinConn = nil
local function startSpin()
    if spinConn then return end
    spinConn = RunService.Heartbeat:Connect(function()
        if not State.Spin then stopSpin(); return end
        local root = getRoot()
        if root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(255) * (1/60), 0)
        end
    end)
end
local function stopSpin()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
end

-- Spin Players (Visual Only)
local spinPlayersConn = nil
local spinOffsets = {}
local function startSpinPlayers()
    if spinPlayersConn then return end
    spinPlayersConn = RunService.Heartbeat:Connect(function()
        if not State.SpinPlayers then stopSpinPlayers(); return end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl == LocalPlayer then continue end
            local char = pl.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            spinOffsets[pl] = (spinOffsets[pl] or 0) + math.rad(255) * (1/60)
            pcall(function()
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, spinOffsets[pl], 0)
            end)
        end
    end)
end
local function stopSpinPlayers()
    if spinPlayersConn then spinPlayersConn:Disconnect(); spinPlayersConn = nil end
    spinOffsets = {}
end

-- NoFall Damage
local noFallConn = nil
local function startNoFall()
    if noFallConn then return end
    noFallConn = RunService.Heartbeat:Connect(function()
        if not State.NoFallDmg then return end
        local hum = getHum()
        if hum then
            hum.MaxHealth = math.huge
            -- Intercept state to prevent landing damage
            if hum:GetState() == Enum.HumanoidStateType.Landed then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
end
local function stopNoFall()
    if noFallConn then noFallConn:Disconnect(); noFallConn = nil end
end

-- MoonWalk
local moonWalkConn = nil
local function startMoonWalk()
    if moonWalkConn then return end
    moonWalkConn = RunService.Heartbeat:Connect(function()
        if not State.MoonWalk then stopMoonWalk(); return end
        local root = getRoot()
        local hum  = getHum()
        if not root or not hum then return end
        if hum.MoveDirection.Magnitude > 0 then
            local slideCF = CFrame.new(root.Position, root.Position + hum.MoveDirection)
            root.CFrame = slideCF * CFrame.Angles(0, math.pi, 0)
        end
    end)
end
local function stopMoonWalk()
    if moonWalkConn then moonWalkConn:Disconnect(); moonWalkConn = nil end
end

-- Find Empty Server
local findEmptyActive = false
local function findEmptyServer()
    if findEmptyActive then return end
    findEmptyActive = true
    WindUI:Notify({ Title = "Find Empty Server", Content = "Buscando servidor vazio...", Duration = 3 })
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            ))
        end)
        if ok and data and data.data then
            local best = nil
            local bestCount = math.huge
            for _, s in ipairs(data.data) do
                local cnt = s.playing or 9999
                if s.id ~= game.JobId and cnt < bestCount then
                    best = s; bestCount = cnt
                end
            end
            if best then
                WindUI:Notify({ Title = "Empty Server", Content = "Conectando... (" .. bestCount .. " players)", Duration = 3 })
                task.wait(2)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer)
            else
                WindUI:Notify({ Title = "Empty Server", Content = "Nenhum servidor encontrado.", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "Empty Server", Content = "Erro ao buscar servidores.", Duration = 3 })
        end
        findEmptyActive = false
    end)
end

-- Screen Stretch
-- Usa ViewportFrame para capturar a cena e exibir esticada,
-- sem tocar no Camera.CFrame ou FieldOfView — aimbot/FOV intactos.
local _stretchGui        = nil
local _stretchViewport   = nil
local _stretchConn2      = nil

local function startScreenStretch()
    if _stretchGui then return end

    -- ScreenGui de sobreposição
    _stretchGui = Instance.new("ScreenGui")
    _stretchGui.Name            = "_HubStretchGui"
    _stretchGui.ResetOnSpawn    = false
    _stretchGui.DisplayOrder    = 99
    _stretchGui.IgnoreGuiInset  = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(_stretchGui) end
        _stretchGui.Parent = game:GetService("CoreGui")
    end)
    if not _stretchGui.Parent then
        pcall(function() _stretchGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
    end

    -- ViewportFrame ocupa a tela inteira mas esticada verticalmente
    _stretchViewport = Instance.new("ViewportFrame")
    _stretchViewport.Size                = UDim2.new(1, 0, 1, 0)    -- ocupa 100% da tela
    _stretchViewport.Position            = UDim2.new(0, 0, 0, 0)
    _stretchViewport.BackgroundTransparency = 1
    _stretchViewport.LightColor          = Color3.fromRGB(255,255,255)
    _stretchViewport.Ambient             = Color3.fromRGB(255,255,255)
    _stretchViewport.CurrentCamera       = Camera   -- mesma câmera do jogo
    _stretchViewport.Parent              = _stretchGui

    -- Escala vertical para simular stretch (reduz altura a 50% → imagem esticada 2×)
    local scale = Instance.new("UIScale")
    scale.Scale  = 1
    scale.Parent = _stretchViewport

    -- Ajuste: encolhe o UIScale no eixo Y usando UIAspectRatioConstraint
    -- Abordagem mais estável: redimensiona o Frame para altura de 50% centralizado
    _stretchViewport.Size     = UDim2.new(1, 0, 0.5, 0)     -- metade da altura
    _stretchViewport.Position = UDim2.new(0, 0, 0.25, 0)    -- centralizado verticalmente
    _stretchViewport.ClipsDescendants = false

    -- Sincroniza a câmera do viewport com a câmera do jogo a cada frame
    _stretchConn2 = RunService.RenderStepped:Connect(function()
        if not State.ScreenStretch or not _stretchViewport or not _stretchViewport.Parent then
            stopScreenStretch(); return
        end
        _stretchViewport.CurrentCamera = Camera
    end)
end

local function stopScreenStretch()
    if _stretchConn2 then _stretchConn2:Disconnect(); _stretchConn2 = nil end
    if _stretchGui   then _stretchGui:Destroy();      _stretchGui   = nil end
    _stretchViewport = nil
end

-- ══════════════════════════════════════════════════════
--  ABA: USEFUL
-- ══════════════════════════════════════════════════════
do
    TabUseful:Section({ Title = "Fling" })

    TabUseful:Toggle({
        Title = "Touch Fling",
        Desc  = "Aplica força em objetos próximos",
        Value = false,
        Callback = function(v)
            State.TouchFling = v
            if v then startFling() else stopFling() end
        end,
    })

    TabUseful:Button({
        Title = "Anti-Fling (toggle)",
        Desc  = "Bloqueia velocity anormal",
        Icon  = "shield",
        Callback = function()
            State.AntiFling = not State.AntiFling
            if State.AntiFling then startAntiFling() else stopAntiFling() end
            WindUI:Notify({ Title="Anti-Fling", Content=State.AntiFling and "ATIVADO ✅" or "DESATIVADO ❌", Duration=2 })
        end,
    })

    TabUseful:Section({ Title = "Proteções Básicas" })

    TabUseful:Toggle({
        Title = "God Mode",
        Desc  = "Vida infinita — difícil de matar",
        Value = false,
        Callback = function(v)
            State.GodMode = v
            local hum = getHum()
            if not hum then return end
            if v then applyGodMode(hum) else removeGodMode(hum) end
        end,
    })

    TabUseful:Toggle({
        Title = "Anti-Void",
        Desc  = "Salva ao cair no void",
        Value = false,
        Callback = function(v)
            State.AntiVoid = v
            if v then startAntiVoid() else stopAntiVoid() end
        end,
    })

    TabUseful:Button({
        Title = "Delete Ragdoll",
        Desc  = "Remove constraints de ragdoll e evita erros",
        Icon  = "trash-2",
        Callback = function()
            deleteRagdoll()
            WindUI:Notify({ Title = "Ragdoll", Content = "Deletado com segurança!", Duration = 2 })
        end,
    })

    TabUseful:Section({ Title = "Tools" })

    local tools = {
        { "Instant Interact", "zap",    "https://pastefy.app/vg1Ap8MO/raw" },
        { "Destroy Tool",     "trash-2","https://rawscripts.net/raw/Universal-Script-destroy-tool-31432" },
        { "Fly Tool",         "wind",   "https://raw.githubusercontent.com/CoiledTom/Fly-tween-CoiledTom-/refs/heads/main/fly%20tween" },
        { "F3X Tool",         "box",    "https://rawscripts.net/raw/Universal-Script-F3X-Tool-44387" },
        { "Shift Lock",       "lock",   "https://raw.githubusercontent.com/CoiledTom/Shift-Lock-CoiledTom-/refs/heads/main/shift%20Lock%20CoiledTom" },
    }
    for _, t in ipairs(tools) do
        TabUseful:Button({ Title=t[1], Icon=t[2], Callback=function() loadstring(game:HttpGet(t[3]))() end })
    end

    TabUseful:Section({ Title = "🎭 Efeitos Visuais" })

    TabUseful:Toggle({
        Title = "Screen Stretch",
        Desc  = "Estica a tela verticalmente (visual local, sem bug no aimbot)",
        Value = false,
        Callback = function(v)
            State.ScreenStretch = v
            if v then startScreenStretch() else stopScreenStretch() end
        end,
    })

    TabUseful:Section({ Title = "🔍 Servidor" })

    TabUseful:Button({
        Title = "Find Empty Server",
        Icon  = "wifi",
        Desc  = "Busca servidor com menos players e teleporta",
        Callback = function()
            findEmptyServer()
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: SCRIPTS
-- ══════════════════════════════════════════════════════
do
    TabScripts:Section({ Title = "GUIs Externas & Scripts" })

    local guis = {
        { "Fly GUI",        "airplay",    "https://raw.githubusercontent.com/CoiledTom/Fly-gui/refs/heads/main/%25" },
        { "Refast GUI",     "activity",   "https://raw.githubusercontent.com/CoiledTom/Refast-CoiledTom-/refs/heads/main/refast%20CoiledTom" },
        { "Speed GUI",      "zap",        "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Waypoint GUI",   "map-pin",    "https://raw.githubusercontent.com/CoiledTom/Way-point-universal-/refs/heads/main/Teleport%2Btween" },
        { "Speed X Hub",    "rocket",     "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
        { "Infinite Yield", "terminal",   "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" },
        { "Reverse",        "refresh-cw", "https://raw.githubusercontent.com/CoiledTom/Reverse/refs/heads/main/reverse%20script%20by%20CoiledTom" },
        { "Speed CoiledTom","zap",        "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Plataforma",     "layers",     "https://raw.githubusercontent.com/CoiledTom/CoiledTom-plataforma/refs/heads/main/By%2520CoiledTom" },
        -- Adicionados v6.0
        { "Desync",         "zap",        "https://raw.githubusercontent.com/danielsan75008-ux/Bjwbmkr/refs/heads/main/Desync.lua" },
        { "Invis Desync",   "eye-off",    "https://raw.githubusercontent.com/CoiledTom/Invisibilidade-/refs/heads/main/invisibilityDesync.lua" },
        { "CMD-X",          "terminal",   "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true },
        { "Dark Dex",       "code",       "https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua" },
    }
    
    for _, g in ipairs(guis) do
        TabScripts:Button({
            Title    = g[1],
            Icon     = g[2],
            Callback = function() 
                if g[4] then
                    loadstring(game:HttpGet(g[3], true))()
                else
                    loadstring(game:HttpGet(g[3]))()
                end
            end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: PLAYER
-- ══════════════════════════════════════════════════════
do
    TabPlayer:Section({ Title = "Movimento" })

    TabPlayer:Toggle({
        Title = "Speed Hack",
        Desc  = "Ativa / desativa o WalkSpeed customizado",
        Value = false,
        Callback = function(v)
            State.SpeedEnabled = v
            local hum = getHum()
            if not hum then return end
            hum.WalkSpeed = v and State.WalkSpeed or 16
        end,
    })
    TabPlayer:Slider({
        Title = "WalkSpeed", Step = 1, Value = { Min = 0, Max = 500, Default = 16 },
        Callback = function(v) State.WalkSpeed = v; local hum = getHum(); if hum and State.SpeedEnabled then hum.WalkSpeed = v end end,
    })

    TabPlayer:Toggle({
        Title = "Jump Hack",
        Desc  = "Ativa / desativa o JumpPower customizado",
        Value = false,
        Callback = function(v)
            State.JumpEnabled = v
            local hum = getHum()
            if not hum then return end
            hum.JumpPower = v and State.JumpPower or 50
        end,
    })
    TabPlayer:Slider({
        Title = "JumpPower", Step = 1, Value = { Min = 0, Max = 500, Default = 50 },
        Callback = function(v) State.JumpPower = v; local hum = getHum(); if hum and State.JumpEnabled then hum.JumpPower = v end end,
    })

    TabPlayer:Toggle({ Title = "Infinite Jump", Desc = "Pula no ar indefinidamente", Value = false, Callback = function(v) State.InfiniteJump = v end })

    TabPlayer:Section({ Title = "Movimento Avançado" })

    TabPlayer:Toggle({
        Title = "Noclip", Desc = "Atravessa paredes e objetos", Value = false,
        Callback = function(v) State.Noclip = v; if v then startNoclip() else stopNoclip() end end,
    })

    TabPlayer:Toggle({
        Title = "Fly", Desc = "Voa com WASD + Espaço (subir) + Ctrl (descer)", Value = false,
        Callback = function(v)
            State.Fly = v
            if v then startFly() else
                stopFly()
                local hum = getHum()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Freefall) end
            end
        end,
    })
    TabPlayer:Slider({ Title = "Velocidade do Fly", Step = 5, Value = { Min = 10, Max = 500, Default = 50 }, Callback = function(v) FLY_SPEED = v end })

    TabPlayer:Section({ Title = "Defesas / Proteções" })

    TabPlayer:Toggle({
        Title = "Anti Knockback 🧱",
        Desc  = "Impede de ser empurrado ou jogado longe",
        Value = false,
        Callback = function(v)
            State.AntiKnockback = v
            if v then startAntiKnockback() else stopAntiKnockback() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Anti Stun",
        Desc  = "Remove stun e animações de queda (Knock-down)",
        Value = false,
        Callback = function(v)
            State.AntiStun = v
            if v then startAntiStun() else stopAntiStun() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Anti Slow",
        Desc  = "Impede que sua velocidade diminua abaixo do normal",
        Value = false,
        Callback = function(v)
            State.AntiSlow = v
            if v then startAntiSlow() else stopAntiSlow() end
        end,
    })

    TabPlayer:Section({ Title = "gravidade lunar 🌙" })

    TabPlayer:Toggle({
        Title = "Simular Gravidade Lunar 🌙",
        Desc  = "Pulos altos e lentos, simulando gravidade da lua",
        Value = false,
        Callback = function(v)
            State.LunarGravity = v
            setLunarGravity(v)
        end,
    })

    TabPlayer:Section({ Title = "Free Camera" })

    TabPlayer:Toggle({
        Title = "Free Camera", Desc = "Move camera independently — WASD + Q/E", Value = false,
        Callback = function(v) State.FreeCamera = v; if v then startFreeCamera() else stopFreeCamera() end end,
    })
    TabPlayer:Slider({ Title = "Freecam Speed", Step = 0.5, Value = { Min = 0.5, Max = 5, Default = 1 }, Callback = function(v) State.FreecamSpeed = v end })

    -- ── v6.1 NOVAS FEATURES ─────────────────────────────

    TabPlayer:Section({ Title = "🛡️ Anti-Travas" })

    TabPlayer:Toggle({
        Title = "Anti Freeze 🛡️",
        Desc  = "Impede scripts de travar ou congelar o movimento",
        Value = false,
        Callback = function(v)
            State.AntiFreeze = v
            if v then startAntiFreeze() else stopAntiFreeze() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Anti Sit 🧷",
        Desc  = "Impede scripts de forçar o personagem a sentar",
        Value = false,
        Callback = function(v)
            State.AntiSit = v
            if v then startAntiSit() else stopAntiSit() end
        end,
    })

    TabPlayer:Toggle({
        Title = "NoFall 🪂",
        Desc  = "Remove dano de queda",
        Value = false,
        Callback = function(v)
            State.NoFallDmg = v
            if v then startNoFall() else stopNoFall() end
        end,
    })

    TabPlayer:Section({ Title = "🌍 Gravidade" })

    TabPlayer:Slider({
        Title = "Gravity Slider 🌍",
        Desc  = "Ajusta a gravidade do workspace (0 = sem gravidade)",
        Step  = 1,
        Value = { Min = 0, Max = 196, Default = 196 },
        Callback = function(v)
            setGravity(v)
        end,
    })

    TabPlayer:Section({ Title = "☁️ Movimentos Aéreos" })

    TabPlayer:Toggle({
        Title = "FastFall ⬇️",
        Desc  = "Cai mais rápido que o normal",
        Value = false,
        Callback = function(v)
            State.FastFall = v
            if v then startFastFall() else stopFastFall() end
        end,
    })

    TabPlayer:Toggle({
        Title = "AirWalk ☁️",
        Desc  = "Anda no ar como se houvesse uma plataforma invisível",
        Value = false,
        Callback = function(v)
            State.AirWalk = v
            if v then startAirWalk() else stopAirWalk() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Float 🎈",
        Desc  = "Mantém o personagem flutuando parado no ar",
        Value = false,
        Callback = function(v)
            State.Float = v
            if v then startFloat() else stopFloat() end
        end,
    })

    TabPlayer:Section({ Title = "🌀 Spin / MoonWalk" })

    TabPlayer:Toggle({
        Title = "Spin 🌀",
        Desc  = "Faz o personagem girar continuamente (velocidade 255)",
        Value = false,
        Callback = function(v)
            State.Spin = v
            if v then startSpin() else stopSpin() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Spin Players (Visual) 🌀",
        Desc  = "Faz outros players girarem — apenas visual local",
        Value = false,
        Callback = function(v)
            State.SpinPlayers = v
            if v then startSpinPlayers() else stopSpinPlayers() end
        end,
    })

    TabPlayer:Toggle({
        Title = "MoonWalk 🌙",
        Desc  = "Movimento deslizante estilo moonwalk ao andar",
        Value = false,
        Callback = function(v)
            State.MoonWalk = v
            if v then startMoonWalk() else stopMoonWalk() end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: COMBAT
-- ══════════════════════════════════════════════════════
do
    TabCombat:Section({ Title = "Aimbot" })
    TabCombat:Toggle({ Title = "Aimbot", Desc = "Mira automática no alvo mais próximo", Value = false, Callback = function(v) State.AimbotEnabled = v end })
    TabCombat:Toggle({ Title = "Team Check", Desc = "Ignora jogadores do mesmo time", Value = false, Callback = function(v) State.TeamCheck = v end })
    TabCombat:Slider({ Title = "FOV", Step = 1, Value = { Min = 10, Max = 600, Default = 120 }, Callback = function(v) State.AimbotFOV = v end })
    TabCombat:Slider({ Title = "Smooth", Step = 1, Value = { Min = 1, Max = 30, Default = 5 }, Callback = function(v) State.AimbotSmooth = v end })
    TabCombat:Toggle({ Title = "Visible Check", Desc = "Only target players visible from camera (raycast)", Value = false, Callback = function(v) State.VisibleCheck = v end })

    TabCombat:Section({ Title = "ESP — Box 2D" })
    TabCombat:Toggle({
        Title = "ESP Box", Desc = "Box 2D + Highlight através de paredes", Value = false,
        Callback = function(v)
            State.ESPEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl == LocalPlayer then continue end
                if v then applyHighlight(pl) else
                    removeHighlight(pl)
                    local o = espObjects[pl]
                    if o then for _, l in ipairs(o.lines) do l.Visible = false end o.label.Visible = false o.fill.Visible = false end
                end
            end
        end,
    })
    TabCombat:Toggle({ Title = "Fill", Desc = "Preenchimento semitransparente", Value = false, Callback = function(v) State.ESPFill = v end })
    TabCombat:Colorpicker({ Title = "Cor do ESP", Default = Color3.fromRGB(255, 50, 50), Callback = function(c) State.ESPColor = c; for _, hl in pairs(espHighlights) do pcall(function() hl.FillColor = c; hl.OutlineColor = c end) end end })
    TabCombat:Slider({ Title = "Opacidade Fill", Step = 0.05, Value = { Min = 0.05, Max = 1, Default = 0.15 }, Callback = function(v) State.ESPFillAlpha = v end })

    TabCombat:Section({ Title = "Chams" })
    TabCombat:Toggle({ Title = "Chams", Desc = "Highlight colorido no corpo dos players", Value = false, Callback = function(v) State.ChamEnabled = v; for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LocalPlayer then if v then applyCham(pl) else removeCham(pl) end end end end })
    TabCombat:Colorpicker({ Title = "Cor dos Chams", Default = Color3.fromRGB(255, 100, 0), Callback = function(c) State.ChamColor = c; if State.ChamEnabled then for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LocalPlayer then applyCham(pl) end end end end })

    TabCombat:Section({ Title = "Tracers" })
    TabCombat:Toggle({ Title = "Tracers", Desc = "Linha do centro da tela até cada player", Value = false, Callback = function(v) State.TracerEnabled = v end })
    TabCombat:Colorpicker({ Title = "Cor dos Tracers", Default = Color3.fromRGB(0, 255, 128), Callback = function(c) State.TracerColor = c end })

    TabCombat:Section({ Title = "Info Extra" })
    TabCombat:Toggle({ Title = "Distance ESP", Desc = "Distância em studs abaixo do box", Value = false, Callback = function(v) State.DistESP = v end })
    TabCombat:Toggle({ Title = "Health ESP", Desc = "Barra de vida à esquerda do box", Value = false, Callback = function(v) State.HealthESP = v end })
    TabCombat:Toggle({
        Title = "Team Check ESP 🎯",
        Desc  = "ESP ignora jogadores do mesmo time",
        Value = false,
        Callback = function(v)
            State.TeamCheckESP = v
        end,
    })

    TabCombat:Section({ Title = "Hitbox Expander" })
    TabCombat:Toggle({ Title = "Hitbox Expander", Desc = "Expande o HRP de todos os players", Value = false, Callback = function(v) State.HitboxEnabled = v; if v then startHitbox() else removeHitbox() end end })
    TabCombat:Slider({ Title = "Tamanho", Step = 1, Value = { Min = 1, Max = 100, Default = 10 }, Callback = function(v) State.HitboxSize = v end })
    TabCombat:Slider({ Title = "Transparência", Step = 0.05, Value = { Min = 0, Max = 1, Default = 0.7 }, Callback = function(v) State.HitboxAlpha = v end })
    TabCombat:Dropdown({ Title = "Cor da Hitbox", Values = {"Really red", "Bright orange", "Bright yellow", "Lime green", "Cyan", "Really blue", "Hot pink", "White"}, Value = "Really red", Callback = function(v) State.HitboxColor = v end })
end

-- ══════════════════════════════════════════════════════
--  ABA: DESEMPENHO
-- ══════════════════════════════════════════════════════
do
    TabPerf:Section({ Title = "⚡ Otimizações" })
    TabPerf:Toggle({ Title = "Anti-Lag", Desc = "Otimiza física e rendering engine", Value = false, Callback = function(v) State.AntiLag = v; applyAntiLag(v) end })
    TabPerf:Toggle({ Title = "FPS Boost", Desc = "Reduz qualidade para mais FPS", Value = false, Callback = function(v) State.FPSBoost = v; applyFPSBoost(v) end })
    TabPerf:Toggle({ Title = "Disable Particles", Desc = "Remove fumaça, fogo, faíscas e partículas", Value = false, Callback = function(v) State.DisableParticles = v; disableParticles(v) end })
    TabPerf:Toggle({ Title = "Texture Low", Desc = "Substitui materiais por SmoothPlastic", Value = false, Callback = function(v) State.TextureLow = v; setTextureLow(v) end })
    TabPerf:Toggle({ Title = "Remove Decals", Desc = "Remove decals e texturas do mapa", Value = false, Callback = function(v) State.RemoveDecals = v; removeDecals(v) end })
    TabPerf:Toggle({ Title = "Dynamic Render Distance", Desc = "Ajusta qualidade automaticamente pelo ping", Value = false, Callback = function(v) State.DynRender = v; setDynRender(v) end })
    TabPerf:Toggle({ Title = "Entity Limiter", Desc = "Limita modelos no workspace (máx 80)", Value = false, Callback = function(v) State.EntityLimiter = v; setEntityLimiter(v) end })
    TabPerf:Toggle({ Title = "Lighting Cleaner", Desc = "Remove fog, bloom, DOF e sombras", Value = false, Callback = function(v) State.LightingClean = v; cleanLighting(v) end })
    TabPerf:Toggle({ Title = "Low Poly Mode", Desc = "Reduz LOD de meshes para mais FPS", Value = false, Callback = function(v) State.LowPoly = v; setLowPoly(v) end })
end

-- ══════════════════════════════════════════════════════
--  ABA: SETTINGS
-- ══════════════════════════════════════════════════════
do
    TabSettings:Section({ Title = "Sistemas v6.0" })

    TabSettings:Toggle({
        Title = "Ocultar próprio nome",
        Desc  = "Oculta o nome flutuante acima do seu personagem",
        Value = false,
        Callback = function(v) setHideName(v) end,
    })

    -- Lógica do botão flutuante para a Câmera
    local camGui = nil
    local camBtn = nil
    local isFirstPerson = false
    local function toggleCameraButton(v)
        if v then
            if not camGui then
                camGui = Instance.new("ScreenGui")
                camGui.Name = "WindUICamToggle"
                camGui.ResetOnSpawn = false
                local ok = pcall(function()
                    if syn and syn.protect_gui then syn.protect_gui(camGui) end
                    camGui.Parent = game:GetService("CoreGui")
                end)
                if not ok or not camGui.Parent then pcall(function() camGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end

                camBtn = Instance.new("TextButton")
                camBtn.Size = UDim2.new(0, 45, 0, 45)
                camBtn.Position = UDim2.new(1, -60, 0.5, -22)
                camBtn.BackgroundColor3 = Theme.BackgroundColor
                camBtn.TextColor3 = Theme.TextColor
                camBtn.Font = Enum.Font.GothamBold
                camBtn.TextSize = 14
                camBtn.Text = "3ª"
                camBtn.Parent = camGui

                local corner = Instance.new("UICorner", camBtn)
                corner.CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", camBtn)
                stroke.Color = Theme.AccentColor
                stroke.Thickness = 2

                camBtn.MouseButton1Click:Connect(function()
                    isFirstPerson = not isFirstPerson
                    if isFirstPerson then
                        camBtn.Text = "1ª"
                        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                    else
                        camBtn.Text = "3ª"
                        LocalPlayer.CameraMode = Enum.CameraMode.Classic
                        LocalPlayer.CameraMinZoomDistance = 0.5
                        LocalPlayer.CameraMaxZoomDistance = 128
                    end
                end)
            end
            camGui.Enabled = true
        else
            if camGui then camGui.Enabled = false end
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        end
    end

    TabSettings:Toggle({
        Title = "Botão Câmera 1ª/3ª Pessoa",
        Desc  = "Ativa um botão flutuante moderno na tela para trocar de câmera",
        Value = false,
        Callback = function(v) toggleCameraButton(v) end,
    })

    TabSettings:Section({ Title = "Visualizar Players (Spectate)" })

    local spectatePlayers = {"Nenhum"}
    for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(spectatePlayers, p.Name) end end
    
    local spectateDropdown = TabSettings:Dropdown({
        Title = "Escolher Player",
        Values = spectatePlayers,
        Callback = function(v) State.SpectateTarget = v end,
    })

    TabSettings:Button({
        Title = "Atualizar Lista", Icon = "refresh-cw",
        Callback = function()
            local newList = {}
            for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(newList, p.Name) end end
            pcall(function() spectateDropdown:Refresh(newList) end)
            WindUI:Notify({ Title = "Spectate", Content = "Lista atualizada!", Duration = 2 })
        end,
    })

    TabSettings:Button({
        Title = "Visualizar Player (Câmera)", Icon = "eye",
        Callback = function()
            if not State.SpectateTarget then return end
            local p = Players:FindFirstChild(State.SpectateTarget)
            if p and p.Character then
                Camera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid") or p.Character:FindFirstChild("HumanoidRootPart")
                WindUI:Notify({ Title = "Spectate", Content = "Visualizando " .. p.Name, Duration = 2 })
            end
        end,
    })

    TabSettings:Button({
        Title = "Voltar Câmera Normal", Icon = "eye-off",
        Callback = function()
            local hum = getHum()
            if hum then Camera.CameraSubject = hum end
            WindUI:Notify({ Title = "Spectate", Content = "Câmera restaurada.", Duration = 2 })
        end,
    })

    TabSettings:Button({
        Title = "Teleportar até o Player", Icon = "map-pin",
        Callback = function()
            if not State.SpectateTarget then return end
            local p = Players:FindFirstChild(State.SpectateTarget)
            local myRoot = getRoot()
            if p and p.Character and myRoot then
                local tgtRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if tgtRoot then
                    myRoot.CFrame = tgtRoot.CFrame * CFrame.new(0, 0, 3)
                    WindUI:Notify({ Title = "Teleport", Content = "Teleportado para " .. p.Name, Duration = 2 })
                end
            end
        end,
    })

    TabSettings:Section({ Title = "Proteções" })
    TabSettings:Toggle({ Title = "Anti-AFK", Desc = "Evita kick por inatividade", Value = false, Callback = function(v) State.AntiAFK = v; if v then startAntiAFK() else stopAntiAFK() end end })
    TabSettings:Toggle({ Title = "Anti-Kick / Anti-Ban", Desc = "Bloqueia kick via metamétodo", Value = false, Callback = function(v) State.AntiKick = v; if v then hookAntiKick() end end })

    TabSettings:Section({ Title = "Servidor" })
    TabSettings:Button({ Title = "Rejoin", Icon = "refresh-cw", Desc = "Teleport back to the same server", Callback = function() WindUI:Notify({ Title="Rejoin", Content="Rejoining...", Duration=2 }); task.wait(1) pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end })
    TabSettings:Toggle({ Title = "Auto Rejoin", Desc = "Caiu? Volta sozinho", Value = false, Callback = function(v) State.AutoRejoin = v end })
    TabSettings:Button({ Title = "Server Hopper", Desc = "Menor ping disponível", Icon = "wifi", Callback = function() WindUI:Notify({ Title="Server Hopper", Content="Buscando...", Duration=3 }); startServerHop() end })

    TabSettings:Section({ Title = "Atalhos" })
    TabSettings:Keybind({ Title = "Toggle UI", Desc = "Abre/fecha o hub", Value = "RightShift", Callback = function(v) pcall(function() Window:SetToggleKey(Enum.KeyCode[v]) end) end })

    TabSettings:Section({ Title = "Aparência Rápida" })
    TabSettings:Colorpicker({ Title = "Cor da GUI", Desc = "Muda o destaque", Default = Color3.fromHex("#7B2FFF"), Callback = function(c) Theme.AccentColor = c; Theme.PrimaryColor = c; Theme.GlowColor = c; Theme.ToggleColor = c; Theme.SliderColor = c; applyTheme() end })

    TabSettings:Section({ Title = "Visuals do Mundo" })
    TabSettings:Toggle({ Title = "FullBright", Value = false, Callback = function(v) State.FullBright = v; setFullBright(v) end })
    TabSettings:Toggle({ Title = "No Fog", Value = false, Callback = function(v) State.NoFog = v; setNoFog(v) end })
    TabSettings:Toggle({ Title = "Sky Changer (Night)", Value = false, Callback = function(v) State.NightMode = v; setNightMode(v) end })
    TabSettings:Slider({ Title = "Custom FOV", Step = 1, Value = { Min = 40, Max = 120, Default = 70 }, Callback = function(v) State.CustomFOV = v; setFOV(v) end })
    TabSettings:Slider({ Title = "Object Transparency", Step = 0.05, Value = { Min = 0, Max = 0.8, Default = 0 }, Callback = function(v) State.ObjTransparency = v; setObjTransparency(v) end })

    TabSettings:Section({ Title = "Configurações Globais" })
    TabSettings:Button({ Title = "Config Load", Icon = "folder-open", Callback = function() pcall(function() if not isfile("CoiledTomHub_Config.json") then WindUI:Notify({Title="Config", Content="Nenhum save.", Duration=3}) return end local data = HttpService:JSONDecode(readfile("CoiledTomHub_Config.json")) if data.WalkSpeed then State.WalkSpeed = data.WalkSpeed end if data.JumpPower then State.JumpPower = data.JumpPower end if data.AimbotFOV then State.AimbotFOV = data.AimbotFOV end if data.HitboxSize then State.HitboxSize = data.HitboxSize end WindUI:Notify({Title="✅ Load", Content="Carregado com sucesso.", Duration=3}) end) end })
    TabSettings:Button({ Title = "Reset Config", Icon = "rotate-ccw", Callback = function() State.FullBright = false; setFullBright(false) State.NoFog = false; setNoFog(false) State.NightMode = false; setNightMode(false) State.CustomFOV = 70; resetFOV() State.ObjTransparency = 0; setObjTransparency(0) State.VisibleCheck = false; State.FreeCamera = false; stopFreeCamera() WindUI:Notify({Title="✅ Reset", Content="Padrões restaurados.", Duration=3}) end })
    TabSettings:Keybind({ Title = "Panic Key", Desc = "Pressione para esconder tudo", Value = "P", Callback = function(v) if not panicHidden then panicHidden = true; setFullBright(false); setNoFog(false); setNightMode(false); resetFOV(); stopFreeCamera(); pcall(function() Window:Toggle(false) end) else panicHidden = false; pcall(function() Window:Toggle(true) end) end end })
    TabSettings:Button({ Title = "Salvar Config", Icon = "save", Callback = function() local ok, err = pcall(function() writefile("CoiledTomHub_Config.json", HttpService:JSONEncode(State)) end) if ok then WindUI:Notify({Title="✅ Salvo!", Content="CoiledTomHub_Config.json", Duration=3}) end end })
end

-- ══════════════════════════════════════════════════════
--  ABA: SERVER INFO
-- ══════════════════════════════════════════════════════
do
    TabServerInfo:Section({ Title = "📡 Game" })

    local gameName = "Unknown"
    pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    TabServerInfo:Section({ Title = "Game: " .. gameName })
    TabServerInfo:Section({ Title = "Players: " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers .. "\nJobId: " .. tostring(game.JobId):sub(1, 18) .. "...\nPlaceId: " .. tostring(game.PlaceId) })

    TabServerInfo:Section({ Title = "📊 Live Stats" })

    local fpsLabel  = TabServerInfo:Section({ Title = "FPS: --" })
    local pingLabel = TabServerInfo:Section({ Title = "Ping: --" })
    local playLabel = TabServerInfo:Section({ Title = "Players: --" })
    
    TabServerInfo:Section({ Title = "⚔️ Player Stats" })
    deathLabelUi = TabServerInfo:Section({ Title = "☠️ Mortes: " .. State.DeathCount }) -- Atualizado automaticamente

    local fpsFrames, fpsTimer, fpsDisplay = 0, 0, 0
    RunService.RenderStepped:Connect(function(dt)
        fpsFrames = fpsFrames + 1
        fpsTimer  = fpsTimer  + dt
        if fpsTimer >= 1 then
            fpsDisplay = fpsFrames; fpsFrames = 0; fpsTimer = 0
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if fpsLabel then fpsLabel.Title = "FPS: " .. fpsDisplay end
                if pingLabel then pingLabel.Title = "Ping: " .. math.floor((LocalPlayer.NetworkPing or 0) * 1000) .. "ms" end
                if playLabel then playLabel.Title = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers end
            end)
        end
    end)
end

-- ══════════════════════════════════════════════════════
--  ABA: GUI / UI — Theme System
-- ══════════════════════════════════════════════════════
do
    TabGUI:Section({ Title = "TEXT" })
    TabGUI:Colorpicker({ Title = "Text Color", Default = Theme.TextColor, Callback = function(c) Theme.TextColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Label Color", Default = Theme.LabelColor, Callback = function(c) Theme.LabelColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Title Color", Default = Theme.TitleColor, Callback = function(c) Theme.TitleColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Description Color", Default = Theme.DescriptionColor, Callback = function(c) Theme.DescriptionColor = c; applyTheme() end })

    TabGUI:Section({ Title = "INTERFACE" })
    TabGUI:Colorpicker({ Title = "Background Color", Default = Theme.BackgroundColor, Callback = function(c) Theme.BackgroundColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Window Color", Default = Theme.WindowColor, Callback = function(c) Theme.WindowColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "UI Accent Color", Default = Theme.AccentColor, Callback = function(c) Theme.AccentColor = c; Theme.PrimaryColor = c; applyTheme() end })

    TabGUI:Section({ Title = "BUTTONS" })
    TabGUI:Colorpicker({ Title = "Button Color", Default = Theme.ButtonColor, Callback = function(c) Theme.ButtonColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Button Text Color", Default = Theme.ButtonTextColor, Callback = function(c) Theme.ButtonTextColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Button Active", Default = Theme.ButtonActive, Callback = function(c) Theme.ButtonActive = c; applyTheme() end })

    TabGUI:Section({ Title = "DETAILS" })
    TabGUI:Colorpicker({ Title = "Border Color", Default = Theme.BorderColor, Callback = function(c) Theme.BorderColor = c; applyTheme() end })
    TabGUI:Colorpicker({ Title = "Glow Color", Default = Theme.GlowColor, Callback = function(c) Theme.GlowColor = c; applyTheme() end })

    TabGUI:Button({ Title = "Reset Theme", Icon = "rotate-ccw", Callback = function() Theme.AccentColor = Color3.fromHex("#7B2FFF"); Theme.BackgroundColor = Color3.fromRGB(13, 13, 15); Theme.BorderColor = Color3.fromRGB(42, 42, 53); Theme.TextColor = Color3.fromRGB(240, 240, 255); Theme.ButtonColor = Color3.fromRGB(30, 30, 46); applyTheme(); WindUI:Notify({ Title = "Theme", Content = "Reset to default.", Duration = 2 }) end })
end

-- ══════════════════════════════════════════════════════
--  NOTIFICAÇÃO INICIAL
-- ══════════════════════════════════════════════════════
WindUI:Notify({
    Title    = "FFHX4ZZ hub v6.1",
    Content  = "Carregado.. xitado até o talo tá ligado 🥷.",
    Duration = 5,
})