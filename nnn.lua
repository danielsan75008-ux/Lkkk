--[[
╔═══════════════════════════════════════════════════════╗
║            CoiledTom Hub  |  WindUI v2               ║
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
    -- v5.0 new features
    VisibleCheck     = false,
    FreeCamera       = false,
    FreecamSpeed     = 1,
    FullBright       = false,
    NoFog            = false,
    NightMode        = false,
    CustomFOV        = 70,
    ObjTransparency  = 0,
    PanicActive      = false,
    -- saved lighting originals
    _origBrightness  = nil,
    _origAmbient     = nil,
    _origFogEnd      = nil,
    _origFogStart    = nil,
    _origClockTime   = nil,
    _origFOV         = nil,
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
    if not State.TeamCheck then return true end
    return p.Team ~= LocalPlayer.Team
end

-- ═══════════════════════════════════
--  WINDOW
-- ═══════════════════════════════════
local Window = WindUI:CreateWindow({
    Title       = "CoiledTom Hub",
    Icon        = "solar:planet-bold",
    Author      = "by CoiledTom",
    Folder      = "CoiledTomHub",
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
            ver   = "v6.0  —  New Features",
            items = {
                "[+] Scripts: Desync, Invis Desync, CMD X, Dark Dex",
                "[+] Player: Anti-Knockback 🧱",
                "[+] Player: Anti-Slow",
                "[+] Player: Gravidade Lunar 🌙",
                "[\\] Player: Delete Ragdoll corrigido (Motor6D restore)",
                "[+] Player: Listar & Pegar Tools do jogo",
                "[+] Settings: Detectar Admin (Auto-Sair)",
                "[+] Settings: Ocultar Nome acima da cabeça",
                "[+] Settings: View Camera (Spectate) com dropdown",
                "[+] Settings: Teleportar ao player selecionado",
                "[+] Settings: Botão POV externo (1ª/3ª pessoa)",
                "[+] Settings: AutoLoad Config",
                "[+] Server Info: Contador de Mortes ☠️",
            },
        },
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
                "[+] Nome: CoiledTom Hub",
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
    -- Restaura colisão
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

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            dir = dir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
           UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir = dir - Vector3.new(0, 1, 0)
        end

        flyBody.Velocity = dir.Magnitude > 0
            and dir.Unit * FLY_SPEED
            or Vector3.zero

        flyGyro.CFrame = cf
    end)
end
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody and flyBody.Parent then flyBody:Destroy() end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy() end
    flyBody = nil; flyGyro = nil
end
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

-- Delete Ragdoll
local function deleteRagdoll()
    local char = getChar()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint")
           or v:IsA("UniversalConstraint") or v:IsA("RodConstraint")
           or v.Name == "Ragdoll" or v.Name == "RagdollConstraint"
           or v.Name == "NoPhysics" then
            pcall(function() v:Destroy() end)
        end
    end
    -- Restore Motor6Ds that may have been disabled by ragdoll
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("Motor6D") then
            pcall(function() v.Enabled = true end)
        end
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
--  ESP — Drawing Objects
-- ══════════════════════════════════════════════════════
local espObjects = {}

local function mkLine(col, thick)
    local l = Drawing.new("Line")
    l.Visible     = false
    l.Color       = col   or Color3.fromRGB(255, 50, 50)
    l.Thickness   = thick or 1.5
    pcall(function() l.AlwaysOnTop = true end)
    return l
end

local function mkText(size, col)
    local t = Drawing.new("Text")
    t.Visible  = false
    t.Size     = size or 14
    t.Outline  = true
    t.Color    = col or Color3.fromRGB(255, 255, 255)
    t.Text     = ""
    pcall(function() t.AlwaysOnTop = true end)
    return t
end

local function mkQuad()
    local q = Drawing.new("Quad")
    q.Visible      = false
    q.Filled       = true
    q.Color        = Color3.fromRGB(255, 50, 50)
    q.Transparency = 0.85
    pcall(function() q.AlwaysOnTop = true end)
    return q
end

-- Highlight: ESP nativo do Roblox que aparece ATRAVÉS de paredes
-- Funciona em qualquer executor sem Drawing API
local espHighlights = {}  -- [player] = Highlight

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
    hl.Adornee          = char
    hl.FillColor        = State.ESPColor
    hl.OutlineColor     = State.ESPColor
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent           = char
    espHighlights[player] = hl
end

local function cleanESP(player)
    local o = espObjects[player]
    if not o then return end
    for _, l in ipairs(o.lines) do l:Remove() end
    o.label:Remove(); o.fill:Remove()
    o.tracer:Remove(); o.dist:Remove()
    o.hpBg:Remove();  o.hpBar:Remove()
    for _, sb in ipairs(o.chams) do
        pcall(function() sb:Destroy() end)
    end
    espObjects[player] = nil
    removeHighlight(player)
end

local function buildESP(player)
    cleanESP(player)
    local lines = {}
    for _ = 1, 4 do table.insert(lines, mkLine()) end
    espObjects[player] = {
        lines  = lines,
        label  = mkText(14),
        fill   = mkQuad(),
        tracer = mkLine(State.TracerColor, 1.5),
        dist   = mkText(12, Color3.fromRGB(255, 220, 80)),
        hpBg   = mkLine(Color3.fromRGB(40, 40, 40), 4),
        hpBar  = mkLine(Color3.fromRGB(0, 220, 80),  4),
        chams  = {},
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
    sb.Color3              = State.ChamColor
    sb.LineThickness       = 0.05
    sb.SurfaceColor3       = State.ChamColor
    sb.SurfaceTransparency = 0.5
    sb.Adornee             = char
    sb.Parent              = workspace
    table.insert(o.chams, sb)
end

local function removeCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
end

-- Calcula bounding box 2D universal — funciona em R6, R15 e custom rigs
-- Ignora parts expandidas pelo hitbox (Transparency = 1 E Size > 4)
local function getBox(char)
    local parts = {}

    -- Pega apenas parts ORIGINAIS do personagem (não hitbox expandidas)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            -- Ignora parts que o hitbox expandiu (ficam com Transparency=1)
            -- mas mantém parts originalmente transparentes do personagem
            local isHitboxExpanded = (v.Transparency >= 1 and
                                      v.Size.X > 4 and
                                      v.Size.Y > 4)
            if not isHitboxExpanded then
                table.insert(parts, v)
            end
        end
    end

    if #parts == 0 then
        -- fallback: pega tudo
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then table.insert(parts, v) end
        end
    end
    if #parts == 0 then return nil end

    -- Projeta todos os 8 cantos de cada part (funciona com rotações)
    local minX, minY =  math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyVisible = false

    for _, part in ipairs(parts) do
        local sz = part.Size * 0.5
        local cf = part.CFrame
        local corners = {
            cf * Vector3.new( sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new( sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new( sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new( sz.X, -sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y, -sz.Z),
        }
        for _, corner in ipairs(corners) do
            local sp = Camera:WorldToViewportPoint(corner)
            -- sp.Z > 0 = na frente da câmera (inclui atrás de paredes)
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
    minX = minX - pad; minY = minY - pad
    maxX = maxX + pad; maxY = maxY + pad

    return {
        tl  = Vector2.new(minX, minY),
        tr  = Vector2.new(maxX, minY),
        br  = Vector2.new(maxX, maxY),
        bl  = Vector2.new(minX, maxY),
        cx  = (minX + maxX) / 2,
        top = minY,
        bot = maxY,
    }
end

-- ══════════════════════════════════════════════════════
--  HITBOX — baseado no método que funciona
--  RenderStepped: expande HRP, Transparency, CanCollide
-- ══════════════════════════════════════════════════════
local hitboxData    = {}   -- não usado, mantido para compatibilidade
local hitboxConn    = nil  -- conexão única do RenderStepped

local function removeHitbox()
    if hitboxConn then
        hitboxConn:Disconnect()
        hitboxConn = nil
    end
    -- Restaura HRP de todos os players
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        pcall(function()
            local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size         = Vector3.new(2, 2, 1)   -- tamanho padrão HRP
                hrp.Transparency = 1                        -- HRP é invisível por padrão
                hrp.CanCollide   = false
                hrp.Material     = Enum.Material.SmoothPlastic
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
                hrp.Size         = Vector3.new(s, s, s)
                hrp.Transparency = State.HitboxAlpha
                hrp.BrickColor   = BrickColor.new(State.HitboxColor or "Really red")
                hrp.Material     = Enum.Material.Neon
                hrp.CanCollide   = false
            end)
        end
    end)
end

-- Reconecta hitbox sempre que um player entra ou respawna
-- Manter compatibilidade com chamadas existentes
local function applyHitbox(player)   end
local function startHitboxSync()     end
local function stopHitboxSync()      end

local function refreshHitboxes()
    if State.HitboxEnabled then
        startHitbox()
    else
        removeHitbox()
    end
end

-- ══════════════════════════════════════════════════════
--  FOV CIRCLE + AIMBOT TARGET
-- ══════════════════════════════════════════════════════
local fovCircle     = Drawing.new("Circle")
fovCircle.Visible   = false
fovCircle.Radius    = State.AimbotFOV
fovCircle.Color     = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled    = false

local function getTarget()
    local best, bestD = nil, math.huge
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if not isEnemy(pl) then continue end
        local ch = pl.Character
        if not ch then continue end
        local hd = ch:FindFirstChild("Head")
        if not hd then continue end
        local sp, on = Camera:WorldToViewportPoint(hd.Position)
        if not on then continue end
        -- Visible Check: raycast from camera to head
        if State.VisibleCheck then
            local origin    = Camera.CFrame.Position
            local direction = (hd.Position - origin)
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character, ch}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(origin, direction, rp)
            if result then continue end  -- blocked by something
        end
        local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
        if d < State.AimbotFOV and d < bestD then
            best = hd; bestD = d
        end
    end
    return best
end

-- ══════════════════════════════════════════════════════
--  v6.0 SYSTEMS
-- ══════════════════════════════════════════════════════

-- Anti-Knockback
local antiKnockConn = nil
local stopAdminDetect  -- forward declaration
local function startAntiKnockback()
    if antiKnockConn then return end
    antiKnockConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        if root.AssemblyLinearVelocity.Magnitude > 50 then
            local vel = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(
                math.clamp(vel.X, -50, 50),
                vel.Y,
                math.clamp(vel.Z, -50, 50)
            )
        end
    end)
end
local function stopAntiKnockback()
    if antiKnockConn then antiKnockConn:Disconnect(); antiKnockConn = nil end
end

-- Anti-Slow (keeps WalkSpeed above a threshold even if server tries to slow)
local antiSlowConn = nil
local function startAntiSlow()
    if antiSlowConn then return end
    antiSlowConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum then return end
        if State.SpeedEnabled and hum.WalkSpeed < State.WalkSpeed then
            hum.WalkSpeed = State.WalkSpeed
        end
    end)
end
local function stopAntiSlow()
    if antiSlowConn then antiSlowConn:Disconnect(); antiSlowConn = nil end
end

-- Lunar Gravity
local function setLunarGravity(on)
    workspace.Gravity = on and 6.25 or 196.2
end

-- Admin Detector (checks for common admin scripts/commands in Players)
local adminDetectConn = nil
local adminNames = {

-- Hide Name above head
local hiddenBillboards = {}
local function setHideName(on)
    local char = getChar()
    if not char then return end
    if on then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("TextLabel") then
                local skip = (v.Name == "NameTag" or v.Name == "Head" or
                   (v:IsA("BillboardGui") and v.Name == "HealthBar"))
                if not skip then
                    pcall(function()
                        hiddenBillboards[v] = v.Enabled ~= nil and v.Enabled or v.Visible
                        if v:IsA("BillboardGui") then v.Enabled = false
                        else v.Visible = false end
                    end)
                end
            end
        end
        -- Hide the Humanoid display name
        local hum = getHum()
        if hum then
            hiddenBillboards["DisplayName"] = hum.DisplayDistanceType
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    else
        local hum = getHum()
        if hum and hiddenBillboards["DisplayName"] then
            hum.DisplayDistanceType = hiddenBillboards["DisplayName"]
        end
        for obj, val in pairs(hiddenBillboards) do
            if type(obj) == "userdata" then
                pcall(function()
                    if obj:IsA("BillboardGui") then obj.Enabled = val
                    else obj.Visible = val end
                end)
            end
        end
        hiddenBillboards = {}
    end
end

-- View Camera (spectate player)
local spectateTarget  = nil
local spectateConn    = nil
local originalCamType = Enum.CameraType.Custom

local function startSpectate(player)
    if spectateConn then spectateConn:Disconnect() end
    spectateTarget = player
    originalCamType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    spectateConn = RunService.RenderStepped:Connect(function()
        if not spectateTarget or not spectateTarget.Character then return end
        local head = spectateTarget.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 2, -6),
                                       head.Position)
        end
    end)
    WindUI:Notify({ Title = "👁 Spectating", Content = player.Name, Duration = 3 })
end

local function stopSpectate()
    if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
    spectateTarget = nil
    Camera.CameraType = Enum.CameraType.Custom
end

local function teleportToTarget()
    if not spectateTarget or not spectateTarget.Character then return end
    local hrp = spectateTarget.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = getRoot()
    if hrp and myRoot then
        myRoot.CFrame = hrp.CFrame + Vector3.new(3, 0, 0)
    end
end

-- POV Toggle (1st / 3rd person external button)
local povGui     = nil
local povIs1st   = false

local function createPOVButton()
    if povGui then return end
    -- Creates a small external ScreenGui button
    local sg = Instance.new("ScreenGui")
    sg.Name        = "CT_POVBtn"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    local frame = Instance.new("Frame")
    frame.Size            = UDim2.fromOffset(90, 36)
    frame.Position        = UDim2.new(0.5, -45, 0, 8)
    frame.BackgroundColor3 = Color3.fromHex("#0d0d0f")
    frame.BorderSizePixel  = 0
    frame.Parent           = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent       = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromHex("#7B2FFF")
    stroke.Thickness = 1.5
    stroke.Parent    = frame

    local btn = Instance.new("TextButton")
    btn.Size              = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text              = "👁 3rd"
    btn.TextColor3        = Color3.fromRGB(240, 240, 255)
    btn.TextSize          = 14
    btn.Font              = Enum.Font.GothamBold
    btn.Parent            = frame

    -- Make draggable
    local dragging, dragStart, startPos = false, nil, nil
    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or
                         inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    btn.MouseButton1Click:Connect(function()
        povIs1st = not povIs1st
        if povIs1st then
            btn.Text = "👁 1st"
            -- Lock camera to first person
            LocalPlayer.CameraMinZoomDistance = 0
            LocalPlayer.CameraMaxZoomDistance = 0
        else
            btn.Text = "👁 3rd"
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 400
        end
    end)

    povGui = sg
end

local function destroyPOVButton()
    if povGui then
        pcall(function() povGui:Destroy() end)
        povGui = nil
    end
    -- Restore zoom
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 400
    povIs1st = false
end

-- AutoLoad Config on start
local function autoLoadConfig()
    pcall(function()
        if isfile and isfile("CoiledTomHub_Config.json") then
            local data = HttpService:JSONDecode(readfile("CoiledTomHub_Config.json"))
            if data.WalkSpeed    then State.WalkSpeed    = data.WalkSpeed    end
            if data.JumpPower    then State.JumpPower    = data.JumpPower    end
            if data.AimbotFOV   then State.AimbotFOV    = data.AimbotFOV    end
            if data.HitboxSize   then State.HitboxSize   = data.HitboxSize   end
        end
    end)
end

-- Death Counter
local deathCount = 0
local function setupDeathCounter()
    local hum = getHum()
    if hum then
        hum.Died:Connect(function()
            deathCount = deathCount + 1
        end)
    end
    LocalPlayer.CharacterAdded:Connect(function(char)
        local h = char:WaitForChild("Humanoid", 5)
        if h then
            h.Died:Connect(function()
                deathCount = deathCount + 1
            end)
        end
    end)
end
setupDeathCounter()

-- ══════════════════════════════════════════════════════
--  v5.0 SYSTEMS
-- ══════════════════════════════════════════════════════

-- FullBright
local function setFullBright(on)
    if on then
        State._origBrightness = Lighting.Brightness
        State._origAmbient    = Lighting.Ambient
        Lighting.Brightness   = 2
        Lighting.Ambient      = Color3.fromRGB(178, 178, 178)
        Lighting.GlobalShadows = false
    else
        if State._origBrightness then Lighting.Brightness = State._origBrightness end
        if State._origAmbient    then Lighting.Ambient    = State._origAmbient    end
        Lighting.GlobalShadows = true
    end
end

-- No Fog
local function setNoFog(on)
    if on then
        State._origFogEnd   = Lighting.FogEnd
        State._origFogStart = Lighting.FogStart
        Lighting.FogEnd     = 1e9
        Lighting.FogStart   = 1e9
    else
        if State._origFogEnd   then Lighting.FogEnd   = State._origFogEnd   end
        if State._origFogStart then Lighting.FogStart = State._origFogStart end
    end
end

-- Night Mode
local function setNightMode(on)
    if on then
        State._origClockTime = Lighting.ClockTime
        Lighting.ClockTime   = 0
    else
        if State._origClockTime then Lighting.ClockTime = State._origClockTime end
    end
end

-- Custom FOV
local function setFOV(v)
    if not State._origFOV then State._origFOV = Camera.FieldOfView end
    Camera.FieldOfView = v
end
local function resetFOV()
    if State._origFOV then Camera.FieldOfView = State._origFOV end
end

-- Object Transparency (workspace BaseParts, skip characters)
local function setObjTransparency(v)
    local charModels = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then charModels[pl.Character] = true end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local inChar = false
            local p = obj.Parent
            while p do
                if charModels[p] then inChar = true; break end
                p = p.Parent
            end
            if not inChar then
                pcall(function() obj.Transparency = v end)
            end
        end
    end
end

-- Free Camera
local freecamConn    = nil
local freecamEnabled = false
local freecamCF      = CFrame.new()

local function startFreeCamera()
    if freecamConn then return end
    freecamEnabled = true
    freecamCF = Camera.CFrame
    Camera.CameraType = Enum.CameraType.Scriptable
    freecamConn = RunService.RenderStepped:Connect(function(dt)
        if not freecamEnabled then return end
        local spd  = State.FreecamSpeed * 20 * dt
        local cf   = freecamCF
        local move = Vector3.zero
        local uis  = UserInputService
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector  end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector  end
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

-- Panic Key state
local panicHidden = false

-- Theme table (stores colors for the GUI/UI tab)
local Theme = {
    TextColor        = Color3.fromRGB(240, 240, 255),
    FontColor        = Color3.fromRGB(240, 240, 255),
    LabelColor       = Color3.fromRGB(200, 200, 220),
    TitleColor       = Color3.fromRGB(255, 255, 255),
    DescriptionColor = Color3.fromRGB(160, 160, 180),
    BackgroundColor  = Color3.fromRGB(13,  13,  15 ),
    WindowColor      = Color3.fromRGB(20,  20,  30 ),
    PanelColor       = Color3.fromRGB(25,  25,  40 ),
    AccentColor      = Color3.fromHex("#7B2FFF"),
    PrimaryColor     = Color3.fromHex("#7B2FFF"),
    SecondaryColor   = Color3.fromHex("#FF2FA0"),
    ButtonColor      = Color3.fromRGB(30,  30,  46 ),
    ButtonHoverColor = Color3.fromRGB(50,  50,  80 ),
    ButtonTextColor  = Color3.fromRGB(240, 240, 255),
    ButtonOutline    = Color3.fromRGB(60,  60,  90 ),
    ButtonActive     = Color3.fromHex("#7B2FFF"),
    BorderColor      = Color3.fromRGB(42,  42,  53 ),
    ShadowColor      = Color3.fromRGB(0,   0,   0  ),
    GlowColor        = Color3.fromHex("#7B2FFF"),
    HighlightColor   = Color3.fromHex("#FF2FA0"),
    ToggleColor      = Color3.fromHex("#7B2FFF"),
    SliderColor      = Color3.fromHex("#7B2FFF"),
    DropdownColor    = Color3.fromRGB(30,  30,  46 ),
}

local function applyTheme()
    pcall(function()
        WindUI:AddTheme({
            Name        = "HubTheme",
            Accent      = Theme.AccentColor,
            Background  = Theme.BackgroundColor,
            Outline     = Theme.BorderColor,
            Text        = Theme.TextColor,
            Placeholder = Theme.DescriptionColor,
            Button      = Theme.ButtonColor,
            Icon        = Theme.AccentColor,
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

    -- FOV circle
    fovCircle.Position = Vector2.new(vcx, vcy)
    fovCircle.Radius   = State.AimbotFOV
    fovCircle.Visible  = State.AimbotEnabled

    -- Aimbot
    if State.AimbotEnabled then
        local tgt = getTarget()
        if tgt then
            local alpha = 1 / (State.AimbotSmooth + 1)
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.lookAt(Camera.CFrame.Position, tgt.Position), alpha
            )
        end
    end

    -- ESP loop
    local bottomY = Camera.ViewportSize.Y
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        -- Se não tem objeto ESP, cria automaticamente
        if not espObjects[player] then
            buildESP(player)
        end

        local o = espObjects[player]
        if not o then continue end

        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart")
                           or char:FindFirstChildWhichIsA("BasePart"))
        local anyOn = State.ESPEnabled or State.TracerEnabled
                   or State.DistESP   or State.HealthESP

        if not char or not root or not anyOn then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local box = getBox(char)
        if not box then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local col = State.ESPColor

        -- Box
        if State.ESPEnabled then
            local corners = { box.tl, box.tr, box.br, box.bl }
            for i = 1, 4 do
                o.lines[i].From    = corners[i]
                o.lines[i].To      = corners[(i % 4) + 1]
                o.lines[i].Color   = col
                o.lines[i].Visible = true
            end
            o.label.Text     = player.Name
            o.label.Color    = col
            o.label.Position = Vector2.new(box.cx, box.top - 16)
            o.label.Visible  = true
            o.fill.PointA    = box.tl; o.fill.PointB = box.tr
            o.fill.PointC    = box.br; o.fill.PointD = box.bl
            o.fill.Color     = col
            o.fill.Transparency = 1 - State.ESPFillAlpha
            o.fill.Visible   = State.ESPFill
        else
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
        end

        -- Tracer — aparece mesmo atrás de paredes
        if State.TracerEnabled and root then
            local sp, _ = Camera:WorldToViewportPoint(root.Position)
            o.tracer.From    = Vector2.new(vcx, bottomY)
            o.tracer.To      = Vector2.new(sp.X, sp.Y)
            o.tracer.Color   = State.TracerColor
            o.tracer.Visible = true
        else
            o.tracer.Visible = false
        end

        -- Distance
        if State.DistESP and root then
            local myRoot = getRoot()
            if myRoot then
                local d = math.floor((root.Position - myRoot.Position).Magnitude)
                o.dist.Text     = d .. " studs"
                o.dist.Position = Vector2.new(box.cx, box.bot + 3)
                o.dist.Visible  = true
            else
                o.dist.Visible = false
            end
        else
            o.dist.Visible = false
        end

        -- Health bar
        if State.HealthESP and hum then
            local ratio  = hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth) or 0
            local barX   = box.tl.X - 5
            local barH   = box.bot - box.top
            o.hpBg.From  = Vector2.new(barX, box.top)
            o.hpBg.To    = Vector2.new(barX, box.bot)
            o.hpBg.Visible = true
            o.hpBar.From   = Vector2.new(barX, box.bot)
            o.hpBar.To     = Vector2.new(barX, box.bot - barH * ratio)
            o.hpBar.Color  = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(255 * ratio),
                50
            )
            o.hpBar.Visible = true
        else
            o.hpBg.Visible  = false
            o.hpBar.Visible = false
        end
    end
end)

-- ══════════════════════════════════════════════════════
--  PLAYER EVENTS
-- ══════════════════════════════════════════════════════

local function connectCharacterEvents(pl)
    pl.CharacterAdded:Connect(function(char)
        buildESP(pl)
        if State.ESPEnabled then
            task.spawn(function()
                task.wait()
                applyHighlight(pl)
            end)
        end
        -- Ciclo liga/desliga para forçar hitbox no novo char
        if State.HitboxEnabled then
            if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
            task.wait()
            startHitbox()
        end
        if State.ChamEnabled then applyCham(pl) end
    end)
end

-- Players já no jogo quando o script rodou
for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LocalPlayer then
        buildESP(pl)
        connectCharacterEvents(pl)
        if State.HitboxEnabled and pl.Character then
            task.spawn(function() applyHitbox(pl) end)
        end
        if State.ESPEnabled and pl.Character then
            task.spawn(function() applyHighlight(pl) end)
        end
    end
end

-- Novos players
Players.PlayerAdded:Connect(function(pl)
    buildESP(pl)
    connectCharacterEvents(pl)
end)

Players.PlayerRemoving:Connect(function(pl)
    cleanESP(pl)
    removeHitbox(pl)
end)

-- Nosso próprio respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        -- Só aplica speed/jump se o toggle estiver ativo
        if State.SpeedEnabled then hum.WalkSpeed = State.WalkSpeed end
        if State.JumpEnabled  then hum.JumpPower  = State.JumpPower  end
        if State.GodMode then applyGodMode(hum) end
    end
    if State.HitboxEnabled then refreshHitboxes() end
    if State.DeleteRagdoll then deleteRagdoll() end
end)

setupAutoRejoin()

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
            WindUI:Notify({
                Title   = "Anti-Fling",
                Content = State.AntiFling and "ATIVADO ✅" or "DESATIVADO ❌",
                Duration = 2,
            })
        end,
    })

    TabUseful:Section({ Title = "Proteções" })

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

    TabUseful:Toggle({
        Title = "Anti-Stun",
        Desc  = "Remove stun e knock-down",
        Value = false,
        Callback = function(v)
            State.AntiStun = v
            if v then startAntiStun() else stopAntiStun() end
        end,
    })

    TabUseful:Button({
        Title = "Delete Ragdoll",
        Desc  = "Remove constraints de ragdoll",
        Icon  = "trash-2",
        Callback = function()
            deleteRagdoll()
            WindUI:Notify({ Title = "Ragdoll", Content = "Deletado!", Duration = 2 })
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
        TabUseful:Button({
            Title    = t[1],
            Icon     = t[2],
            Callback = function() loadstring(game:HttpGet(t[3]))() end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: SCRIPTS
-- ══════════════════════════════════════════════════════
do
    TabScripts:Section({ Title = "GUIs Externas" })

    local guis = {
        { "Fly GUI",        "airplay",   "https://raw.githubusercontent.com/CoiledTom/Fly-gui/refs/heads/main/%25" },
        { "Refast GUI",     "activity",  "https://raw.githubusercontent.com/CoiledTom/Refast-CoiledTom-/refs/heads/main/refast%20CoiledTom" },
        { "Speed GUI",      "zap",       "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Waypoint GUI",   "map-pin",   "https://raw.githubusercontent.com/CoiledTom/Way-point-universal-/refs/heads/main/Teleport%2Btween" },
        { "Speed X Hub",    "rocket",    "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
        { "Infinite Yield", "terminal",  "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" },
        { "Reverse",        "refresh-cw","https://raw.githubusercontent.com/CoiledTom/Reverse/refs/heads/main/reverse%20script%20by%20CoiledTom" },
        { "Speed CoiledTom","zap",       "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Plataforma",     "layers",    "https://raw.githubusercontent.com/CoiledTom/CoiledTom-plataforma/refs/heads/main/By%2520CoiledTom" },
        { "Desync",         "shuffle",   "https://raw.githubusercontent.com/danielsan75008-ux/Bjwbmkr/refs/heads/main/Desync.lua" },
        { "Invis Desync",   "eye-off",   "https://raw.githubusercontent.com/CoiledTom/Invisibilidade-/refs/heads/main/invisibilityDesync.lua" },
        { "CMD X",          "command",   "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source" },
        { "Dark Dex",       "search",    "https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua" },
    }
    for _, g in ipairs(guis) do
        TabScripts:Button({
            Title    = g[1],
            Icon     = g[2],
            Callback = function() loadstring(game:HttpGet(g[3]))() end,
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
        Title = "WalkSpeed",
        Desc  = "Velocidade de caminhada",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 16 },
        Callback = function(v)
            State.WalkSpeed = v
            local hum = getHum()
            if hum and State.SpeedEnabled then hum.WalkSpeed = v end
        end,
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
        Title = "JumpPower",
        Desc  = "Força do pulo",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 50 },
        Callback = function(v)
            State.JumpPower = v
            local hum = getHum()
            if hum and State.JumpEnabled then hum.JumpPower = v end
        end,
    })

    TabPlayer:Section({ Title = "Pulo" })

    TabPlayer:Toggle({
        Title = "Infinite Jump",
        Desc  = "Pula no ar indefinidamente",
        Value = false,
        Callback = function(v) State.InfiniteJump = v end,
    })

    TabPlayer:Section({ Title = "Movimento Avançado" })

    TabPlayer:Toggle({
        Title = "Noclip",
        Desc  = "Atravessa paredes e objetos",
        Value = false,
        Callback = function(v)
            State.Noclip = v
            if v then startNoclip() else stopNoclip() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Fly",
        Desc  = "Voa com WASD + Espaço (subir) + Ctrl (descer)",
        Value = false,
        Callback = function(v)
            State.Fly = v
            if v then
                startFly()
            else
                stopFly()
                -- Restaura gravidade
                local hum = getHum()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end
            end
        end,
    })

    TabPlayer:Slider({
        Title = "Velocidade do Fly",
        Desc  = "Velocidade ao voar",
        Step  = 5,
        Value = { Min = 10, Max = 500, Default = 50 },
        Callback = function(v)
            FLY_SPEED = v
        end,
    })

    TabPlayer:Section({ Title = "Free Camera" })

    TabPlayer:Toggle({
        Title = "Free Camera",
        Desc  = "Move camera independently — WASD + Q/E",
        Value = false,
        Callback = function(v)
            State.FreeCamera = v
            if v then startFreeCamera() else stopFreeCamera() end
        end,
    })

    TabPlayer:Slider({
        Title = "Freecam Speed",
        Desc  = "Free camera movement speed",
        Step  = 0.5,
        Value = { Min = 0.5, Max = 5, Default = 1 },
        Callback = function(v) State.FreecamSpeed = v end,
    })

    TabPlayer:Section({ Title = "Proteções de Movimento" })

    TabPlayer:Toggle({
        Title = "Anti-Knockback 🧱",
        Desc  = "Limita velocidade horizontal para resistir knockback",
        Value = false,
        Callback = function(v)
            if v then startAntiKnockback() else stopAntiKnockback() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Anti-Slow",
        Desc  = "Impede que o servidor reduza sua velocidade",
        Value = false,
        Callback = function(v)
            if v then startAntiSlow() else stopAntiSlow() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Gravidade Lunar 🌙",
        Desc  = "Reduz a gravidade para simular a Lua",
        Value = false,
        Callback = function(v)
            setLunarGravity(v)
        end,
    })

    TabPlayer:Button({
        Title = "Delete Ragdoll (Fix)",
        Desc  = "Remove constraints de ragdoll e restaura Motor6Ds",
        Icon  = "trash-2",
        Callback = function()
            deleteRagdoll()
            WindUI:Notify({ Title = "Ragdoll", Content = "Removido e Motor6Ds restaurados!", Duration = 3 })
        end,
    })

    TabPlayer:Section({ Title = "🎒 Tools do Jogo" })

    TabPlayer:Button({
        Title = "Listar & Pegar Tools",
        Desc  = "Mostra todos os tools disponíveis no jogo",
        Icon  = "package",
        Callback = function()
            -- Collect all tools from workspace and lighting
            local found = {}
            local function scanFor(parent)
                for _, v in ipairs(parent:GetDescendants()) do
                    if v:IsA("Tool") and not v:IsDescendantOf(LocalPlayer.Character or Instance.new("Part")) then
                        if not found[v.Name] then
                            found[v.Name] = v
                        end
                    end
                end
            end
            scanFor(workspace)
            -- Also check ServerStorage if accessible
            pcall(function() scanFor(game:GetService("ServerStorage")) end)
            pcall(function() scanFor(game:GetService("ReplicatedStorage")) end)

            if next(found) == nil then
                WindUI:Notify({ Title = "Tools", Content = "Nenhum tool encontrado no jogo.", Duration = 4 })
                return
            end

            local list = ""
            local tools_ref = {}
            for name, tool in pairs(found) do
                list = list .. "• " .. name .. "\n"
                table.insert(tools_ref, tool)
            end

            WindUI:Notify({
                Title    = "🎒 Tools encontrados (" .. #tools_ref .. ")",
                Content  = list:sub(1, 200),
                Duration = 8,
            })

            -- Clone all found tools to backpack
            task.wait(0.5)
            for _, tool in ipairs(tools_ref) do
                pcall(function()
                    local clone = tool:Clone()
                    clone.Parent = LocalPlayer.Backpack
                end)
            end
            WindUI:Notify({ Title = "✅ Tools", Content = "Todos clonados para seu Backpack!", Duration = 4 })
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: COMBAT
-- ══════════════════════════════════════════════════════
do
    TabCombat:Section({ Title = "Aimbot" })

    TabCombat:Toggle({
        Title = "Aimbot",
        Desc  = "Mira automática no alvo mais próximo",
        Value = false,
        Callback = function(v) State.AimbotEnabled = v end,
    })

    TabCombat:Toggle({
        Title = "Team Check",
        Desc  = "Ignora jogadores do mesmo time",
        Value = false,
        Callback = function(v) State.TeamCheck = v end,
    })

    TabCombat:Slider({
        Title = "FOV",
        Desc  = "Raio de alcance em pixels",
        Step  = 1,
        Value = { Min = 10, Max = 600, Default = 120 },
        Callback = function(v) State.AimbotFOV = v end,
    })

    TabCombat:Slider({
        Title = "Smooth",
        Desc  = "Suavidade da mira",
        Step  = 1,
        Value = { Min = 1, Max = 30, Default = 5 },
        Callback = function(v) State.AimbotSmooth = v end,
    })

    TabCombat:Toggle({
        Title = "Visible Check",
        Desc  = "Only target players visible from camera (raycast)",
        Value = false,
        Callback = function(v) State.VisibleCheck = v end,
    })

    TabCombat:Section({ Title = "ESP — Box 2D" })

    TabCombat:Toggle({
        Title = "ESP Box",
        Desc  = "Box 2D + Highlight através de paredes",
        Value = false,
        Callback = function(v)
            State.ESPEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl == LocalPlayer then continue end
                if v then
                    applyHighlight(pl)
                else
                    removeHighlight(pl)
                    local o = espObjects[pl]
                    if o then
                        for _, l in ipairs(o.lines) do l.Visible = false end
                        o.label.Visible = false
                        o.fill.Visible  = false
                    end
                end
            end
        end,
    })

    TabCombat:Toggle({
        Title = "Fill",
        Desc  = "Preenchimento semitransparente",
        Value = false,
        Callback = function(v) State.ESPFill = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor do ESP",
        Default  = Color3.fromRGB(255, 50, 50),
        Callback = function(c)
            State.ESPColor = c
            -- Atualiza Highlights em tempo real
            for _, hl in pairs(espHighlights) do
                pcall(function()
                    hl.FillColor    = c
                    hl.OutlineColor = c
                end)
            end
        end,
    })

    TabCombat:Slider({
        Title = "Opacidade Fill",
        Step  = 0.05,
        Value = { Min = 0.05, Max = 1, Default = 0.15 },
        Callback = function(v) State.ESPFillAlpha = v end,
    })

    TabCombat:Section({ Title = "Chams" })

    TabCombat:Toggle({
        Title = "Chams",
        Desc  = "Highlight colorido no corpo dos players",
        Value = false,
        Callback = function(v)
            State.ChamEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer then
                    if v then applyCham(pl) else removeCham(pl) end
                end
            end
        end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Chams",
        Default  = Color3.fromRGB(255, 100, 0),
        Callback = function(c)
            State.ChamColor = c
            if State.ChamEnabled then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer then applyCham(pl) end
                end
            end
        end,
    })

    TabCombat:Section({ Title = "Tracers" })

    TabCombat:Toggle({
        Title = "Tracers",
        Desc  = "Linha do centro da tela até cada player",
        Value = false,
        Callback = function(v) State.TracerEnabled = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Tracers",
        Default  = Color3.fromRGB(0, 255, 128),
        Callback = function(c) State.TracerColor = c end,
    })

    TabCombat:Section({ Title = "Info Extra" })

    TabCombat:Toggle({
        Title = "Distance ESP",
        Desc  = "Distância em studs abaixo do box",
        Value = false,
        Callback = function(v) State.DistESP = v end,
    })

    TabCombat:Toggle({
        Title = "Health ESP",
        Desc  = "Barra de vida à esquerda do box",
        Value = false,
        Callback = function(v) State.HealthESP = v end,
    })

    TabCombat:Section({ Title = "Hitbox Expander" })

    TabCombat:Toggle({
        Title = "Hitbox Expander",
        Desc  = "Expande o HRP de todos os players",
        Value = false,
        Callback = function(v)
            State.HitboxEnabled = v
            if v then
                startHitbox()
            else
                removeHitbox()
            end
        end,
    })

    TabCombat:Slider({
        Title = "Tamanho",
        Desc  = "Tamanho do HumanoidRootPart expandido",
        Step  = 1,
        Value = { Min = 1, Max = 100, Default = 10 },
        Callback = function(v)
            State.HitboxSize = v
        end,
    })

    TabCombat:Slider({
        Title = "Transparência",
        Desc  = "0 = sólido visível  |  1 = invisível",
        Step  = 0.05,
        Value = { Min = 0, Max = 1, Default = 0.7 },
        Callback = function(v)
            State.HitboxAlpha = v
        end,
    })

    TabCombat:Dropdown({
        Title  = "Cor da Hitbox",
        Desc   = "Cor do HRP expandido",
        Values = {
            "Really red",
            "Bright orange",
            "Bright yellow",
            "Lime green",
            "Cyan",
            "Really blue",
            "Hot pink",
            "White",
        },
        Value    = "Really red",
        Callback = function(v)
            State.HitboxColor = v
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: DESEMPENHO
-- ══════════════════════════════════════════════════════
do
    TabPerf:Section({ Title = "⚡ Otimizações" })

    TabPerf:Toggle({
        Title = "Anti-Lag",
        Desc  = "Otimiza física e rendering engine",
        Value = false,
        Callback = function(v) State.AntiLag = v; applyAntiLag(v) end,
    })

    TabPerf:Toggle({
        Title = "FPS Boost",
        Desc  = "Reduz qualidade para mais FPS",
        Value = false,
        Callback = function(v) State.FPSBoost = v; applyFPSBoost(v) end,
    })

    TabPerf:Toggle({
        Title = "Disable Particles",
        Desc  = "Remove fumaça, fogo, faíscas e partículas",
        Value = false,
        Callback = function(v) State.DisableParticles = v; disableParticles(v) end,
    })

    TabPerf:Toggle({
        Title = "Texture Low",
        Desc  = "Substitui materiais por SmoothPlastic",
        Value = false,
        Callback = function(v) State.TextureLow = v; setTextureLow(v) end,
    })

    TabPerf:Toggle({
        Title = "Remove Decals",
        Desc  = "Remove decals e texturas do mapa",
        Value = false,
        Callback = function(v) State.RemoveDecals = v; removeDecals(v) end,
    })

    TabPerf:Toggle({
        Title = "Dynamic Render Distance",
        Desc  = "Ajusta qualidade automaticamente pelo ping",
        Value = false,
        Callback = function(v) State.DynRender = v; setDynRender(v) end,
    })

    TabPerf:Toggle({
        Title = "Entity Limiter",
        Desc  = "Limita modelos no workspace (máx 80)",
        Value = false,
        Callback = function(v) State.EntityLimiter = v; setEntityLimiter(v) end,
    })

    TabPerf:Toggle({
        Title = "Lighting Cleaner",
        Desc  = "Remove fog, bloom, DOF e sombras",
        Value = false,
        Callback = function(v) State.LightingClean = v; cleanLighting(v) end,
    })

    TabPerf:Toggle({
        Title = "Low Poly Mode",
        Desc  = "Reduz LOD de meshes para mais FPS",
        Value = false,
        Callback = function(v) State.LowPoly = v; setLowPoly(v) end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: SETTINGS
-- ══════════════════════════════════════════════════════
do
    TabSettings:Section({ Title = "Detecção & Privacidade" })

    TabSettings:Toggle({
        Title = "Detectar Admin (Auto-Sair)",
        Desc  = "Sai do server automaticamente se detectar admin",
        Value = false,
        Callback = function(v)
            if v then startAdminDetect() else stopAdminDetect() end
        end,
    })

    TabSettings:Toggle({
        Title = "Ocultar Nome 🙈",
        Desc  = "Esconde seu nome acima da cabeça",
        Value = false,
        Callback = function(v) setHideName(v) end,
    })

    TabSettings:Section({ Title = "👁 View Camera (Spectate)" })

    local spectatePlayerList = {}
    local spectateDropdown = TabSettings:Dropdown({
        Title  = "Selecionar Player",
        Desc   = "Escolha quem spectatar",
        Values = { "-- Nenhum --" },
        Value  = "-- Nenhum --",
        Callback = function(v) spectatePlayerList.selected = v end,
    })

    TabSettings:Button({
        Title = "Atualizar Lista",
        Icon  = "refresh-cw",
        Callback = function()
            local names = { "-- Nenhum --" }
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer then table.insert(names, pl.Name) end
            end
            pcall(function() spectateDropdown:Refresh(names) end)
        end,
    })

    TabSettings:Button({
        Title = "👁 Spectatar Player",
        Icon  = "eye",
        Callback = function()
            local sel = spectatePlayerList.selected
            if not sel or sel == "-- Nenhum --" then
                WindUI:Notify({ Title = "Spectate", Content = "Selecione um player primeiro.", Duration = 3 }); return
            end
            local target = Players:FindFirstChild(sel)
            if target then startSpectate(target)
            else WindUI:Notify({ Title = "Spectate", Content = "Player não encontrado.", Duration = 3 }) end
        end,
    })

    TabSettings:Button({
        Title = "↩ Voltar Câmera Normal",
        Icon  = "camera-off",
        Callback = function()
            stopSpectate()
            WindUI:Notify({ Title = "Câmera", Content = "Restaurada.", Duration = 2 })
        end,
    })

    TabSettings:Button({
        Title = "⚡ Teleportar ao Player",
        Icon  = "navigation",
        Callback = function()
            local sel = spectatePlayerList.selected
            if not sel or sel == "-- Nenhum --" then
                WindUI:Notify({ Title = "Teleporte", Content = "Selecione um player primeiro.", Duration = 3 }); return
            end
            local target = Players:FindFirstChild(sel)
            if target then
                spectateTarget = target
                teleportToTarget()
                WindUI:Notify({ Title = "⚡ Teleportado", Content = "Até " .. sel, Duration = 3 })
            end
        end,
    })

    TabSettings:Section({ Title = "POV & Auto" })

    TabSettings:Toggle({
        Title = "Botão POV Externo 📷",
        Desc  = "Botão flutuante para alternar 1ª/3ª pessoa",
        Value = false,
        Callback = function(v)
            if v then createPOVButton() else destroyPOVButton() end
        end,
    })

    TabSettings:Toggle({
        Title = "AutoLoad Config",
        Desc  = "Carrega config salva automaticamente ao executar",
        Value = false,
        Callback = function(v)
            if v then
                autoLoadConfig()
                WindUI:Notify({ Title = "AutoLoad", Content = "Config carregada!", Duration = 3 })
            end
        end,
    })

    TabSettings:Section({ Title = "Aparência" })

    TabSettings:Colorpicker({
        Title   = "Cor da GUI",
        Desc    = "Muda a cor de destaque de toda a interface",
        Default = Color3.fromHex("#7B2FFF"),
        Callback = function(c)
            pcall(function()
                WindUI:AddTheme({
                    Name        = "HubTheme",
                    Accent      = c,
                    Background  = Color3.fromHex("#0d0d0f"),
                    Outline     = Color3.fromHex("#2a2a35"),
                    Text        = Color3.fromHex("#f0f0ff"),
                    Placeholder = Color3.fromHex("#666680"),
                    Button      = Color3.fromHex("#1e1e2e"),
                    Icon        = c,
                })
                WindUI:SetTheme("HubTheme")
            end)
        end,
    })

    TabSettings:Section({ Title = "Proteções" })

    TabSettings:Toggle({
        Title = "Anti-AFK",
        Desc  = "Evita kick por inatividade",
        Value = false,
        Callback = function(v)
            State.AntiAFK = v
            if v then startAntiAFK() else stopAntiAFK() end
        end,
    })

    TabSettings:Toggle({
        Title = "Anti-Kick / Anti-Ban",
        Desc  = "Bloqueia kick via metamétodo",
        Value = false,
        Callback = function(v)
            State.AntiKick = v
            if v then hookAntiKick() end
        end,
    })

    TabSettings:Section({ Title = "Servidor" })

    TabSettings:Button({
        Title = "Rejoin",
        Icon  = "refresh-cw",
        Desc  = "Teleport back to the same server",
        Callback = function()
            WindUI:Notify({ Title = "Rejoin", Content = "Rejoining server...", Duration = 2 })
            task.wait(1)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end,
    })

    TabSettings:Toggle({
        Title = "Auto Rejoin",
        Desc  = "Caiu? Volta sozinho ao server automaticamente",
        Value = false,
        Callback = function(v) State.AutoRejoin = v end,
    })

    TabSettings:Button({
        Title = "Server Hopper",
        Desc  = "Vai para o server com menor ping disponível",
        Icon  = "wifi",
        Callback = function()
            WindUI:Notify({ Title = "Server Hopper", Content = "Buscando melhor server...", Duration = 3 })
            startServerHop()
        end,
    })

    TabSettings:Section({ Title = "Atalhos" })

    TabSettings:Keybind({
        Title = "Toggle UI",
        Desc  = "Abre/fecha o hub",
        Value = "RightShift",
        Callback = function(v)
            pcall(function()
                Window:SetToggleKey(Enum.KeyCode[v])
            end)
        end,
    })

    TabSettings:Section({ Title = "Aparência" })

    TabSettings:Colorpicker({
        Title   = "Cor da GUI",
        Desc    = "Muda a cor de destaque de toda a interface",
        Default = Color3.fromHex("#7B2FFF"),
        Callback = function(c)
            Theme.AccentColor   = c
            Theme.PrimaryColor  = c
            Theme.GlowColor     = c
            Theme.ToggleColor   = c
            Theme.SliderColor   = c
            applyTheme()
        end,
    })

    TabSettings:Section({ Title = "Visuals" })

    TabSettings:Toggle({
        Title = "FullBright",
        Desc  = "Make the map fully bright",
        Value = false,
        Callback = function(v)
            State.FullBright = v
            setFullBright(v)
        end,
    })

    TabSettings:Toggle({
        Title = "No Fog",
        Desc  = "Remove fog from the map",
        Value = false,
        Callback = function(v)
            State.NoFog = v
            setNoFog(v)
        end,
    })

    TabSettings:Toggle({
        Title = "Sky Changer (Night)",
        Desc  = "Set time to night — restores on disable",
        Value = false,
        Callback = function(v)
            State.NightMode = v
            setNightMode(v)
        end,
    })

    TabSettings:Slider({
        Title = "Custom FOV",
        Desc  = "Camera field of view",
        Step  = 1,
        Value = { Min = 40, Max = 120, Default = 70 },
        Callback = function(v)
            State.CustomFOV = v
            setFOV(v)
        end,
    })

    TabSettings:Slider({
        Title = "Object Transparency",
        Desc  = "Transparency of workspace objects (not characters)",
        Step  = 0.05,
        Value = { Min = 0, Max = 0.8, Default = 0 },
        Callback = function(v)
            State.ObjTransparency = v
            setObjTransparency(v)
        end,
    })

    TabSettings:Section({ Title = "Config" })

    TabSettings:Button({
        Title = "Config Load",
        Icon  = "folder-open",
        Desc  = "Load saved configuration and apply values",
        Callback = function()
            pcall(function()
                if not isfile("CoiledTomHub_Config.json") then
                    WindUI:Notify({ Title = "Config", Content = "No saved config found.", Duration = 3 })
                    return
                end
                local data = HttpService:JSONDecode(readfile("CoiledTomHub_Config.json"))
                if data.WalkSpeed    then State.WalkSpeed    = data.WalkSpeed    end
                if data.JumpPower    then State.JumpPower    = data.JumpPower    end
                if data.AimbotFOV   then State.AimbotFOV    = data.AimbotFOV    end
                if data.AimbotSmooth then State.AimbotSmooth = data.AimbotSmooth end
                if data.HitboxSize   then State.HitboxSize   = data.HitboxSize   end
                if data.HitboxAlpha  then State.HitboxAlpha  = data.HitboxAlpha  end
                WindUI:Notify({ Title = "✅ Config Loaded", Content = "Values applied.", Duration = 3 })
            end)
        end,
    })

    TabSettings:Button({
        Title = "Reset Config",
        Icon  = "rotate-ccw",
        Desc  = "Reset v5.0 settings to defaults",
        Callback = function()
            State.FullBright     = false;  setFullBright(false)
            State.NoFog          = false;  setNoFog(false)
            State.NightMode      = false;  setNightMode(false)
            State.CustomFOV      = 70;     resetFOV()
            State.ObjTransparency = 0;     setObjTransparency(0)
            State.VisibleCheck   = false
            State.FreeCamera     = false;  stopFreeCamera()
            State.FreecamSpeed   = 1
            WindUI:Notify({ Title = "✅ Reset", Content = "v5.0 settings restored to defaults.", Duration = 3 })
        end,
    })

    TabSettings:Section({ Title = "Panic Key" })

    TabSettings:Keybind({
        Title = "Panic Key",
        Desc  = "Press to hide/disable all — press again to restore",
        Value = "P",
        Callback = function(v)
            -- This fires when the key is pressed
            if not panicHidden then
                -- Disable all v5.0 features
                panicHidden          = true
                State.FullBright     = false;  setFullBright(false)
                State.NoFog          = false;  setNoFog(false)
                State.NightMode      = false;  setNightMode(false)
                resetFOV()
                State.FreeCamera     = false;  stopFreeCamera()
                -- Hide window
                pcall(function() Window:Toggle(false) end)
            else
                panicHidden = false
                pcall(function() Window:Toggle(true) end)
            end
        end,
    })

    TabSettings:Section({ Title = "Configuração" })

    TabSettings:Button({
        Title = "Salvar Config",
        Icon  = "save",
        Desc  = "Salva em CoiledTomHub_Config.json",
        Callback = function()
            local ok, err = pcall(function()
                local data = {
                    WalkSpeed     = State.WalkSpeed,
                    JumpPower     = State.JumpPower,
                    InfiniteJump  = State.InfiniteJump,
                    AimbotEnabled = State.AimbotEnabled,
                    TeamCheck     = State.TeamCheck,
                    AimbotFOV    = State.AimbotFOV,
                    AimbotSmooth  = State.AimbotSmooth,
                    ESPEnabled    = State.ESPEnabled,
                    ESPFill       = State.ESPFill,
                    ESPFillAlpha  = State.ESPFillAlpha,
                    ChamEnabled   = State.ChamEnabled,
                    TracerEnabled = State.TracerEnabled,
                    DistESP       = State.DistESP,
                    HealthESP     = State.HealthESP,
                    HitboxEnabled = State.HitboxEnabled,
                    HitboxSize    = State.HitboxSize,
                    HitboxAlpha   = State.HitboxAlpha,
                    AntiAFK       = State.AntiAFK,
                    AntiKick      = State.AntiKick,
                }
                writefile("CoiledTomHub_Config.json", HttpService:JSONEncode(data))
            end)
            if ok then
                WindUI:Notify({ Title="✅ Config Salva!", Content="CoiledTomHub_Config.json", Duration=3 })
            else
                WindUI:Notify({ Title="❌ Erro", Content=tostring(err), Duration=5 })
            end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  NEW TABS (v5.0)
-- ══════════════════════════════════════════════════════
local TabServerInfo = Window:Tab({ Title = "Server Info", Icon = "solar:server-bold"        })
local TabGUI        = Window:Tab({ Title = "GUI / UI",    Icon = "solar:palette-bold"       })

-- ══════════════════════════════════════════════════════
--  ABA: SERVER INFO
-- ══════════════════════════════════════════════════════
do
    TabServerInfo:Section({ Title = "📡 Game" })

    -- Game Name
    local gameName = "Unknown"
    pcall(function() gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    TabServerInfo:Section({ Title = "Game: " .. gameName })

    -- Server Info (static)
    TabServerInfo:Section({ Title = "Server Details" })
    TabServerInfo:Section({ Title =
        "Players:  " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers .. "\n" ..
        "JobId:    " .. tostring(game.JobId):sub(1, 18) .. "...\n" ..
        "PlaceId:  " .. tostring(game.PlaceId)
    })

    -- Dynamic labels via Paragraphs updated each second
    TabServerInfo:Section({ Title = "📊 Live Stats" })

    local statsSection = TabServerInfo:Section({ Title = "FPS: -- | Ping: --ms | Players: -- | ☠️ 0" })

    -- FPS counter via RenderStepped
    local fpsFrames, fpsTimer, fpsDisplay = 0, 0, 0
    RunService.RenderStepped:Connect(function(dt)
        fpsFrames = fpsFrames + 1
        fpsTimer  = fpsTimer  + dt
        if fpsTimer >= 1 then
            fpsDisplay = fpsFrames
            fpsFrames  = 0
            fpsTimer   = 0
        end
    end)

    -- Death counter label updated via notify
    local lastDeathShown = -1

    -- Update labels every second
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local fps   = fpsDisplay
                local ping  = math.floor((LocalPlayer.NetworkPing or 0) * 1000)
                local cnt   = #Players:GetPlayers()
                local max   = Players.MaxPlayers
                -- Show death change via notification
                if deathCount ~= lastDeathShown and deathCount > 0 then
                    lastDeathShown = deathCount
                    WindUI:Notify({ Title = "☠️ Morte #" .. deathCount, Content = "Total de mortes: " .. deathCount, Duration = 3 })
                end
                -- Update the section title with live stats
                if statsSection then
                    pcall(function()
                        statsSection.Title = "FPS: "..fps.." | Ping: "..ping.."ms | Players: "..cnt.."/"..max.." | ☠️ "..deathCount
                    end)
                end
            end)
        end
    end)

    -- Static death counter button that shows current count
    TabServerInfo:Button({
        Title = "☠️ Ver Mortes",
        Icon  = "activity",
        Desc  = "Mostra total de mortes na sessão",
        Callback = function()
            WindUI:Notify({ Title = "☠️ Contador de Mortes", Content = "Total nesta sessão: " .. deathCount, Duration = 5 })
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: GUI / UI — Theme System
-- ══════════════════════════════════════════════════════
do
    -- TEXT
    TabGUI:Section({ Title = "TEXT" })

    TabGUI:Colorpicker({
        Title = "Text Color",        Default = Theme.TextColor,
        Callback = function(c) Theme.TextColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Label Color",       Default = Theme.LabelColor,
        Callback = function(c) Theme.LabelColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Title Color",       Default = Theme.TitleColor,
        Callback = function(c) Theme.TitleColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Description Color", Default = Theme.DescriptionColor,
        Callback = function(c) Theme.DescriptionColor = c; applyTheme() end,
    })

    -- INTERFACE
    TabGUI:Section({ Title = "INTERFACE" })

    TabGUI:Colorpicker({
        Title = "Background Color",  Default = Theme.BackgroundColor,
        Callback = function(c) Theme.BackgroundColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Window Color",      Default = Theme.WindowColor,
        Callback = function(c) Theme.WindowColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "UI Accent Color",   Default = Theme.AccentColor,
        Callback = function(c) Theme.AccentColor = c; Theme.PrimaryColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Primary Color",     Default = Theme.PrimaryColor,
        Callback = function(c) Theme.PrimaryColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Secondary Color",   Default = Theme.SecondaryColor,
        Callback = function(c) Theme.SecondaryColor = c; applyTheme() end,
    })

    -- BUTTONS
    TabGUI:Section({ Title = "BUTTONS" })

    TabGUI:Colorpicker({
        Title = "Button Color",      Default = Theme.ButtonColor,
        Callback = function(c) Theme.ButtonColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Button Text Color", Default = Theme.ButtonTextColor,
        Callback = function(c) Theme.ButtonTextColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Button Active",     Default = Theme.ButtonActive,
        Callback = function(c) Theme.ButtonActive = c; applyTheme() end,
    })

    -- DETAILS
    TabGUI:Section({ Title = "DETAILS" })

    TabGUI:Colorpicker({
        Title = "Border Color",      Default = Theme.BorderColor,
        Callback = function(c) Theme.BorderColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Glow Color",        Default = Theme.GlowColor,
        Callback = function(c) Theme.GlowColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Highlight Color",   Default = Theme.HighlightColor,
        Callback = function(c) Theme.HighlightColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Toggle Color",      Default = Theme.ToggleColor,
        Callback = function(c) Theme.ToggleColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Slider Color",      Default = Theme.SliderColor,
        Callback = function(c) Theme.SliderColor = c; applyTheme() end,
    })
    TabGUI:Colorpicker({
        Title = "Dropdown Color",    Default = Theme.DropdownColor,
        Callback = function(c) Theme.DropdownColor = c; applyTheme() end,
    })

    TabGUI:Button({
        Title = "Reset Theme",
        Icon  = "rotate-ccw",
        Desc  = "Restore default theme colors",
        Callback = function()
            Theme.AccentColor      = Color3.fromHex("#7B2FFF")
            Theme.BackgroundColor  = Color3.fromRGB(13, 13, 15)
            Theme.BorderColor      = Color3.fromRGB(42, 42, 53)
            Theme.TextColor        = Color3.fromRGB(240, 240, 255)
            Theme.ButtonColor      = Color3.fromRGB(30, 30, 46)
            applyTheme()
            WindUI:Notify({ Title = "Theme", Content = "Reset to default.", Duration = 2 })
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  NOTIFICAÇÃO INICIAL
-- ══════════════════════════════════════════════════════
WindUI:Notify({
    Title    = "CoiledTom Hub",
    Content  = "Carregado! Confira a aba Logs para novidades.",
    Duration = 5,
})
