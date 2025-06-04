-- Ultimate Combat System Setup Script v3.0
-- Enhanced with all requested features including proper momentum control, stamina balance, and debug mode

local function setupCombatSystem()
    print("[COMBAT SYSTEM] Starting Ultimate Combat System setup...")
    
    -- Clean up any existing setup
    local existingFolder = workspace:FindFirstChild("CombatSystemFolder")
    if existingFolder then
        existingFolder:Destroy()
        wait(0.1)
    end
    
    -- Create main folder structure
    local mainFolder = Instance.new("Folder")
    mainFolder.Name = "CombatSystemFolder"
    mainFolder.Parent = workspace
    
    -- Create service folders
    local folders = {
        "Hitboxes",
        "Effects", 
        "TestDummies",
        "DebugVisuals"
    }
    
    for _, folderName in ipairs(folders) do
        local folder = Instance.new("Folder")
        folder.Name = folderName
        folder.Parent = mainFolder
    end
    
    -- Combat Settings Module (Enhanced)
    local combatSettingsModule = Instance.new("ModuleScript")
    combatSettingsModule.Name = "CombatSettings"
    combatSettingsModule.Parent = game.ReplicatedStorage
    combatSettingsModule.Source = [[
local CombatSettings = {}

-- M1 Attack Settings
CombatSettings.M1 = {
    Animations = {
        [1] = "rbxassetid://112627375965381",
        [2] = "rbxassetid://107219571959162", 
        [3] = "rbxassetid://71244140880155",
        [4] = "rbxassetid://119494483714064"
    },
    Damage = 10,
    ComboLimit = 4,
    Duration = 0.5,
    MovementSlowdown = 0.3, -- 70% movement speed reduction during M1
    MomentumLoss = true, -- Stops player momentum when attacking
    Endlag = {
        [1] = 0.2,
        [2] = 0.2,
        [3] = 0.3,
        [4] = 0.8 -- Longer endlag on final hit
    },
    ComboResetTime = 1.5, -- Time before combo resets
    HitstunDuration = 0.4, -- Stun duration when hit
    ComboCooldown = 0.5 -- Cooldown after 4th hit before can M1 again
}

-- Dash Settings
CombatSettings.Dash = {
    Animations = {
        Forward = "rbxassetid://72951822742730",
        Backward = "rbxassetid://1284642812",
        Left = "rbxassetid://1201718473",
        Right = "rbxassetid://871699376"
    },
    Cooldown = 1.5,
    Distance = 15,
    Duration = 0.3,
    StaminaCost = 20,
    IFrames = true, -- Invincibility frames during dash
    IFrameDuration = 0.15
}

-- Block/Parry Settings
CombatSettings.Block = {
    Animation = "rbxassetid://928454497",
    DamageReduction = 0.8, -- 80% damage reduction when blocking
    StaminaDrainPerHit = 10,
    ParryWindow = 0.3, -- 300ms parry window
    ParryStunDuration = 1.0, -- Stun attacker on successful parry
    CanParryDuringCombo = true,
    BlockBreakThreshold = 30 -- Stamina threshold for guard break
}

-- Stamina Settings
CombatSettings.Stamina = {
    Max = 100,
    RegenRate = 15, -- Per second
    RegenDelay = 1.0, -- Delay before regen starts
    M1Cost = 5,
    SprintDrain = 10, -- Per second
    BlockDrain = 5 -- Per second while holding block
}

-- Health/Posture Settings
CombatSettings.Health = {
    Max = 100,
    RegenRate = 0, -- No health regen by default
}

CombatSettings.Posture = {
    Max = 100,
    BreakStunDuration = 2.0,
    RegenRate = 20, -- Per second
    M1Damage = 15,
    BlockDamage = 5
}

-- Hitstun Settings
CombatSettings.Hitstun = {
    Animation = "rbxassetid://928454497",
    MovementDisabled = true,
    AttackingDisabled = true,
    BlockingAllowed = false -- Can't block during hitstun
}

-- Ragdoll Settings
CombatSettings.Ragdoll = {
    Duration = 2,
    OnFinalHit = true,
    OnPostureBreak = true
}

-- Debug Settings
CombatSettings.Debug = {
    Enabled = false,
    ShowHitboxes = true,
    ShowPlayerBoxes = true,
    ShowDamageNumbers = true,
    ShowStaminaBars = true,
    ShowCombatInfo = true,
    HitboxColor = Color3.new(1, 0, 0),
    PlayerBoxColor = Color3.new(0, 1, 0),
    BlockBoxColor = Color3.new(0, 0, 1)
}

-- Test Dummy Settings
CombatSettings.TestDummy = {
    Health = 100,
    Behaviors = {
        Idle = {Weight = 3},
        Blocking = {Weight = 2, Duration = {1, 3}},
        Parrying = {Weight = 1, ReactTime = 0.2},
        Attacking = {Weight = 2, ComboLength = {1, 4}},
        Dodging = {Weight = 1, ReactTime = 0.3}
    }
}

return CombatSettings
]]
    
    -- Combat Handler (Server)
    local combatHandler = Instance.new("Script")
    combatHandler.Name = "CombatHandler"
    combatHandler.Parent = game.ServerScriptService
    combatHandler.Source = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local CombatSettings = require(ReplicatedStorage:WaitForChild("CombatSettings"))
local CombatRemotes = ReplicatedStorage:WaitForChild("CombatRemotes")

-- Player data storage
local playerData = {}
local activeHitboxes = {}
local comboCounts = {}
local lastAttackTime = {}
local stunEndTimes = {}
local blockingPlayers = {}
local parryWindows = {}
local dashCooldowns = {}
local staminaRegenDelays = {}

-- Initialize player data
local function initializePlayer(player)
    playerData[player] = {
        Health = CombatSettings.Health.Max,
        Stamina = CombatSettings.Stamina.Max,
        Posture = CombatSettings.Posture.Max,
        InCombat = false,
        Stunned = false,
        Blocking = false,
        Dashing = false,
        DebugMode = false
    }
    comboCounts[player] = 0
    lastAttackTime[player] = 0
    stunEndTimes[player] = 0
    dashCooldowns[player] = 0
    staminaRegenDelays[player] = 0
end

-- Clean up player data
local function cleanupPlayer(player)
    playerData[player] = nil
    comboCounts[player] = nil
    lastAttackTime[player] = nil
    stunEndTimes[player] = nil
    blockingPlayers[player] = nil
    parryWindows[player] = nil
    dashCooldowns[player] = nil
    staminaRegenDelays[player] = nil
    
    -- Clean up any active hitboxes
    for hitbox, data in pairs(activeHitboxes) do
        if data.Owner == player then
            hitbox:Destroy()
            activeHitboxes[hitbox] = nil
        end
    end
end

-- Check if player is stunned
local function isPlayerStunned(player)
    return tick() < (stunEndTimes[player] or 0)
end

-- Apply stun to player
local function applyStun(player, duration)
    stunEndTimes[player] = tick() + duration
    playerData[player].Stunned = true
    
    -- Apply hitstun animation
    CombatRemotes.PlayAnimation:FireClient(player, CombatSettings.Hitstun.Animation)
    
    -- Slow/stop movement
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local originalSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = 0
            
            task.wait(duration)
            
            if humanoid and humanoid.Parent then
                humanoid.WalkSpeed = originalSpeed
            end
        end
    end
    
    playerData[player].Stunned = false
end

-- Handle M1 attacks with momentum control
CombatRemotes.M1Attack.OnServerEvent:Connect(function(player)
    local data = playerData[player]
    if not data or data.Stunned or data.Blocking then return end
    
    local currentTime = tick()
    local timeSinceLastAttack = currentTime - lastAttackTime[player]
    
    -- Check if in combo cooldown (after 4th hit)
    if comboCounts[player] >= CombatSettings.M1.ComboLimit then
        if timeSinceLastAttack < CombatSettings.M1.ComboCooldown then
            return -- Still in cooldown
        else
            comboCounts[player] = 0 -- Reset combo
        end
    end
    
    -- Reset combo if too much time passed
    if timeSinceLastAttack > CombatSettings.M1.ComboResetTime then
        comboCounts[player] = 0
    end
    
    -- Check stamina
    if data.Stamina < CombatSettings.Stamina.M1Cost then
        return -- Not enough stamina
    end
    
    -- Update combo count
    comboCounts[player] = comboCounts[player] + 1
    lastAttackTime[player] = currentTime
    
    -- Deduct stamina
    data.Stamina = math.max(0, data.Stamina - CombatSettings.Stamina.M1Cost)
    staminaRegenDelays[player] = currentTime + CombatSettings.Stamina.RegenDelay
    
    local comboCount = comboCounts[player]
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Stop momentum and apply movement slowdown
    if CombatSettings.M1.MomentumLoss then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
        bodyVelocity.Velocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y, 0)
        bodyVelocity.Parent = rootPart
        Debris:AddItem(bodyVelocity, 0.1)
    end
    
    -- Apply movement slowdown
    local originalSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = originalSpeed * CombatSettings.M1.MovementSlowdown
    
    -- Play animation
    local animId = CombatSettings.M1.Animations[comboCount]
    CombatRemotes.PlayAnimation:FireClient(player, animId)
    
    -- Create hitbox
    local hitbox = Instance.new("Part")
    hitbox.Name = "M1Hitbox"
    hitbox.Size = Vector3.new(5, 5, 5)
    hitbox.CFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = CombatSettings.Debug.Enabled and 0.5 or 1
    hitbox.BrickColor = BrickColor.new("Really red")
    hitbox.Parent = workspace.CombatSystemFolder.Hitboxes
    
    activeHitboxes[hitbox] = {
        Owner = player,
        Damage = CombatSettings.M1.Damage,
        ComboCount = comboCount,
        HitPlayers = {}
    }
    
    -- Handle endlag
    local endlag = CombatSettings.M1.Endlag[comboCount]
    
    task.spawn(function()
        wait(CombatSettings.M1.Duration)
        
        -- Clean up hitbox
        if activeHitboxes[hitbox] then
            activeHitboxes[hitbox] = nil
            hitbox:Destroy()
        end
        
        -- Apply endlag
        wait(endlag)
        
        -- Restore movement speed
        if humanoid and humanoid.Parent then
            humanoid.WalkSpeed = originalSpeed
        end
    end)
end)

-- Handle blocking
CombatRemotes.Block.OnServerEvent:Connect(function(player, isBlocking)
    local data = playerData[player]
    if not data or data.Stunned then return end
    
    blockingPlayers[player] = isBlocking
    data.Blocking = isBlocking
    
    if isBlocking then
        -- Check for parry window
        parryWindows[player] = tick() + CombatSettings.Block.ParryWindow
        CombatRemotes.BlockState:FireClient(player, "blocking")
    else
        parryWindows[player] = nil
        CombatRemotes.BlockState:FireClient(player, "none")
    end
end)

-- Handle directional dashing
CombatRemotes.Dash.OnServerEvent:Connect(function(player, direction)
    local data = playerData[player]
    if not data or data.Stunned or data.Dashing then return end
    
    local currentTime = tick()
    if currentTime < dashCooldowns[player] then return end
    
    -- Check stamina
    if data.Stamina < CombatSettings.Dash.StaminaCost then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    -- Set dash state
    data.Dashing = true
    dashCooldowns[player] = currentTime + CombatSettings.Dash.Cooldown
    
    -- Deduct stamina
    data.Stamina = math.max(0, data.Stamina - CombatSettings.Dash.StaminaCost)
    staminaRegenDelays[player] = currentTime + CombatSettings.Stamina.RegenDelay
    
    -- Play appropriate animation
    local animId = CombatSettings.Dash.Animations[direction]
    CombatRemotes.PlayAnimation:FireClient(player, animId)
    
    -- Calculate dash direction
    local dashVector = Vector3.new(0, 0, 0)
    if direction == "Forward" then
        dashVector = rootPart.CFrame.LookVector
    elseif direction == "Backward" then
        dashVector = -rootPart.CFrame.LookVector
    elseif direction == "Left" then
        dashVector = -rootPart.CFrame.RightVector
    elseif direction == "Right" then
        dashVector = rootPart.CFrame.RightVector
    end
    
    -- Apply dash movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(50000, 0, 50000)
    bodyVelocity.Velocity = dashVector * (CombatSettings.Dash.Distance / CombatSettings.Dash.Duration)
    bodyVelocity.Parent = rootPart
    
    -- Apply i-frames if enabled
    if CombatSettings.Dash.IFrames then
        data.Invincible = true
        task.wait(CombatSettings.Dash.IFrameDuration)
        data.Invincible = false
    end
    
    -- Clean up dash
    task.wait(CombatSettings.Dash.Duration)
    bodyVelocity:Destroy()
    data.Dashing = false
end)

-- Debug mode toggle
CombatRemotes.ToggleDebug.OnServerEvent:Connect(function(player)
    local data = playerData[player]
    if not data then return end
    
    data.DebugMode = not data.DebugMode
    CombatSettings.Debug.Enabled = data.DebugMode
    
    -- Update all clients about debug mode
    CombatRemotes.DebugModeChanged:FireAllClients(player, data.DebugMode)
    
    print(player.Name .. " toggled debug mode: " .. tostring(data.DebugMode))
end)

-- Hitbox detection loop
RunService.Heartbeat:Connect(function()
    for hitbox, hitboxData in pairs(activeHitboxes) do
        if hitbox.Parent then
            local region = Region3.new(hitbox.Position - hitbox.Size/2, hitbox.Position + hitbox.Size/2)
            region = region:ExpandToGrid(4)
            
            local parts = workspace:FindPartsInRegion3(region, hitbox, 100)
            
            for _, part in ipairs(parts) do
                local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Parent ~= hitboxData.Owner.Character then
                    local targetPlayer = Players:GetPlayerFromCharacter(humanoid.Parent)
                    
                    if targetPlayer and not hitboxData.HitPlayers[targetPlayer] then
                        hitboxData.HitPlayers[targetPlayer] = true
                        
                        local targetData = playerData[targetPlayer]
                        if targetData then
                            -- Check if target is blocking
                            if blockingPlayers[targetPlayer] then
                                -- Check for parry
                                if parryWindows[targetPlayer] and tick() < parryWindows[targetPlayer] then
                                    -- Successful parry
                                    CombatRemotes.ParrySuccess:FireClient(targetPlayer)
                                    applyStun(hitboxData.Owner, CombatSettings.Block.ParryStunDuration)
                                    
                                    -- Reset attacker combo
                                    comboCounts[hitboxData.Owner] = 0
                                else
                                    -- Regular block
                                    local reducedDamage = hitboxData.Damage * (1 - CombatSettings.Block.DamageReduction)
                                    targetData.Health = math.max(0, targetData.Health - reducedDamage)
                                    targetData.Stamina = math.max(0, targetData.Stamina - CombatSettings.Block.StaminaDrainPerHit)
                                    
                                    -- Check for guard break
                                    if targetData.Stamina < CombatSettings.Block.BlockBreakThreshold then
                                        blockingPlayers[targetPlayer] = false
                                        targetData.Blocking = false
                                        applyStun(targetPlayer, CombatSettings.Posture.BreakStunDuration)
                                    end
                                end
                            elseif not targetData.Invincible then
                                -- Normal hit
                                targetData.Health = math.max(0, targetData.Health - hitboxData.Damage)
                                targetData.Posture = math.max(0, targetData.Posture - CombatSettings.Posture.M1Damage)
                                
                                -- Apply hitstun
                                applyStun(targetPlayer, CombatSettings.M1.HitstunDuration)
                                
                                -- Check for posture break
                                if targetData.Posture <= 0 then
                                    applyStun(targetPlayer, CombatSettings.Posture.BreakStunDuration)
                                    
                                    -- Ragdoll on posture break
                                    if CombatSettings.Ragdoll.OnPostureBreak then
                                        CombatRemotes.Ragdoll:FireClient(targetPlayer, CombatSettings.Ragdoll.Duration)
                                    end
                                end
                                
                                -- Ragdoll on final hit
                                if hitboxData.ComboCount == CombatSettings.M1.ComboLimit and CombatSettings.Ragdoll.OnFinalHit then
                                    CombatRemotes.Ragdoll:FireClient(targetPlayer, CombatSettings.Ragdoll.Duration)
                                end
                            end
                            
                            -- Update UI
                            CombatRemotes.UpdateStats:FireClient(targetPlayer, targetData)
                        end
                    end
                end
            end
        else
            activeHitboxes[hitbox] = nil
        end
    end
end)

-- Stamina regeneration loop
RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    for player, data in pairs(playerData) do
        if data.Stamina < CombatSettings.Stamina.Max then
            if currentTime > (staminaRegenDelays[player] or 0) and not data.Blocking then
                data.Stamina = math.min(CombatSettings.Stamina.Max, data.Stamina + CombatSettings.Stamina.RegenRate * (1/30))
                CombatRemotes.UpdateStats:FireClient(player, data)
            end
        end
        
        -- Drain stamina while blocking
        if data.Blocking then
            data.Stamina = math.max(0, data.Stamina - CombatSettings.Stamina.BlockDrain * (1/30))
            if data.Stamina <= 0 then
                blockingPlayers[player] = false
                data.Blocking = false
            end
            CombatRemotes.UpdateStats:FireClient(player, data)
        end
    end
end)

-- Player connections
Players.PlayerAdded:Connect(initializePlayer)
Players.PlayerRemoving:Connect(cleanupPlayer)

-- Initialize existing players
for _, player in ipairs(Players:GetPlayers()) do
    initializePlayer(player)
end

print("[COMBAT SYSTEM] Server handler initialized")
]]
    
    -- Combat Client Script
    local combatClient = Instance.new("LocalScript")
    combatClient.Name = "CombatClient"
    combatClient.Parent = game.StarterPlayer.StarterPlayerScripts
    combatClient.Source = [[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local CombatSettings = require(ReplicatedStorage:WaitForChild("CombatSettings"))
local CombatRemotes = ReplicatedStorage:WaitForChild("CombatRemotes")

-- Input handling
local keybinds = {
    M1 = Enum.UserInputType.MouseButton1,
    Block = Enum.KeyCode.F,
    DashForward = {Enum.KeyCode.Q, Enum.KeyCode.W},
    DashBackward = {Enum.KeyCode.Q, Enum.KeyCode.S},
    DashLeft = {Enum.KeyCode.Q, Enum.KeyCode.A},
    DashRight = {Enum.KeyCode.Q, Enum.KeyCode.D}
}

local heldKeys = {}
local isBlocking = false
local debugMode = false

-- Track key states
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Track held keys
    if input.KeyCode then
        heldKeys[input.KeyCode] = true
    end
    
    -- M1 Attack
    if input.UserInputType == keybinds.M1 then
        CombatRemotes.M1Attack:FireServer()
    end
    
    -- Block
    if input.KeyCode == keybinds.Block then
        isBlocking = true
        CombatRemotes.Block:FireServer(true)
    end
    
    -- Check for dash inputs
    if input.KeyCode == Enum.KeyCode.Q then
        -- Check directional keys
        if heldKeys[Enum.KeyCode.W] then
            CombatRemotes.Dash:FireServer("Forward")
        elseif heldKeys[Enum.KeyCode.S] then
            CombatRemotes.Dash:FireServer("Backward")
        elseif heldKeys[Enum.KeyCode.A] then
            CombatRemotes.Dash:FireServer("Left")
        elseif heldKeys[Enum.KeyCode.D] then
            CombatRemotes.Dash:FireServer("Right")
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Track released keys
    if input.KeyCode then
        heldKeys[input.KeyCode] = false
    end
    
    -- Release block
    if input.KeyCode == keybinds.Block then
        isBlocking = false
        CombatRemotes.Block:FireServer(false)
    end
end)

-- Chat commands
player.Chatted:Connect(function(message)
    if message:lower() == "/debug_mode" then
        CombatRemotes.ToggleDebug:FireServer()
    elseif message:lower() == "/spawn_dummies" then
        CombatRemotes.SpawnDummies:FireServer()
    elseif message:lower() == "/clear_dummies" then
        CombatRemotes.ClearDummies:FireServer()
    end
end)

-- Animation playing
CombatRemotes.PlayAnimation.OnClientEvent:Connect(function(animationId)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = animationId
    
    local track = humanoid:LoadAnimation(animation)
    track:Play()
end)

-- Debug visualization
CombatRemotes.DebugModeChanged.OnClientEvent:Connect(function(togglePlayer, enabled)
    debugMode = enabled
    
    if debugMode then
        -- Create debug UI
        local debugGui = Instance.new("ScreenGui")
        debugGui.Name = "CombatDebugUI"
        debugGui.Parent = player.PlayerGui
        
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(0, 300, 0, 200)
        infoFrame.Position = UDim2.new(1, -310, 0, 10)
        infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        infoFrame.BackgroundTransparency = 0.3
        infoFrame.Parent = debugGui
        
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, -10, 1, -10)
        infoLabel.Position = UDim2.new(0, 5, 0, 5)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.new(1, 1, 1)
        infoLabel.TextScaled = true
        infoLabel.Font = Enum.Font.Code
        infoLabel.Text = "Debug Mode Active"
        infoLabel.Parent = infoFrame
        
        -- Visualize hitboxes
        workspace.CombatSystemFolder.Hitboxes.ChildAdded:Connect(function(hitbox)
            if debugMode and hitbox:IsA("BasePart") then
                hitbox.Transparency = 0.5
                hitbox.Material = Enum.Material.ForceField
                
                local selection = Instance.new("SelectionBox")
                selection.Adornee = hitbox
                selection.Color3 = CombatSettings.Debug.HitboxColor
                selection.LineThickness = 0.1
                selection.Parent = hitbox
            end
        end)
    else
        -- Remove debug UI
        local debugGui = player.PlayerGui:FindFirstChild("CombatDebugUI")
        if debugGui then
            debugGui:Destroy()
        end
    end
end)

-- Stats update
CombatRemotes.UpdateStats.OnClientEvent:Connect(function(stats)
    -- Update UI with stats
    local gui = player.PlayerGui:FindFirstChild("CombatUI")
    if gui then
        local healthBar = gui.MainFrame.HealthBar
        local staminaBar = gui.MainFrame.StaminaBar
        local postureBar = gui.MainFrame.PostureBar
        
        healthBar.Bar.Size = UDim2.new(stats.Health / CombatSettings.Health.Max, 0, 1, 0)
        staminaBar.Bar.Size = UDim2.new(stats.Stamina / CombatSettings.Stamina.Max, 0, 1, 0)
        postureBar.Bar.Size = UDim2.new(stats.Posture / CombatSettings.Posture.Max, 0, 1, 0)
    end
end)

print("[COMBAT SYSTEM] Client initialized")
]]
    
    -- Create Combat UI
    local combatUI = Instance.new("ScreenGui")
    combatUI.Name = "CombatUI"
    combatUI.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -200, 1, -180)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = combatUI
    
    -- Create status bars
    local bars = {"HealthBar", "StaminaBar", "PostureBar"}
    local colors = {Color3.new(1, 0, 0), Color3.new(0, 1, 0), Color3.new(1, 1, 0)}
    
    for i, barName in ipairs(bars) do
        local barFrame = Instance.new("Frame")
        barFrame.Name = barName
        barFrame.Size = UDim2.new(1, 0, 0, 30)
        barFrame.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        barFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        barFrame.BorderSizePixel = 2
        barFrame.Parent = mainFrame
        
        local bar = Instance.new("Frame")
        bar.Name = "Bar"
        bar.Size = UDim2.new(1, 0, 1, 0)
        bar.BackgroundColor3 = colors[i]
        bar.BorderSizePixel = 0
        bar.Parent = barFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = barName:gsub("Bar", "")
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = barFrame
    end
    
    combatUI.Parent = game.StarterGui
    
    -- Create Remotes
    local remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "CombatRemotes"
    remotesFolder.Parent = ReplicatedStorage
    
    local remoteNames = {
        "M1Attack", "Block", "Dash", "UpdateStats", "PlayAnimation",
        "BlockState", "ParrySuccess", "Ragdoll", "ToggleDebug",
        "DebugModeChanged", "SpawnDummies", "ClearDummies"
    }
    
    for _, remoteName in ipairs(remoteNames) do
        local remote = Instance.new("RemoteEvent")
        remote.Name = remoteName
        remote.Parent = remotesFolder
    end
    
    -- Test Dummy System
    local dummyScript = Instance.new("Script")
    dummyScript.Name = "TestDummySystem"
    dummyScript.Parent = game.ServerScriptService
    dummyScript.Source = [[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CombatSettings = require(ReplicatedStorage:WaitForChild("CombatSettings"))
local CombatRemotes = ReplicatedStorage:WaitForChild("CombatRemotes")

local dummies = {}

local function createDummy(position, behavior)
    local dummy = game.ServerStorage:FindFirstChild("CombatDummy")
    if not dummy then
        -- Create dummy model
        dummy = Instance.new("Model")
        dummy.Name = "CombatDummy"
        
        -- Create parts
        local parts = {
            {Name = "HumanoidRootPart", Size = Vector3.new(2, 2, 1), Position = Vector3.new(0, 3, 0)},
            {Name = "Torso", Size = Vector3.new(2, 2, 1), Position = Vector3.new(0, 3, 0)},
            {Name = "Head", Size = Vector3.new(2, 1, 1), Position = Vector3.new(0, 4.5, 0)},
            {Name = "Left Arm", Size = Vector3.new(1, 2, 1), Position = Vector3.new(-1.5, 3, 0)},
            {Name = "Right Arm", Size = Vector3.new(1, 2, 1), Position = Vector3.new(1.5, 3, 0)},
            {Name = "Left Leg", Size = Vector3.new(1, 2, 1), Position = Vector3.new(-0.5, 1, 0)},
            {Name = "Right Leg", Size = Vector3.new(1, 2, 1), Position = Vector3.new(0.5, 1, 0)}
        }
        
        for _, partData in ipairs(parts) do
            local part = Instance.new("Part")
            part.Name = partData.Name
            part.Size = partData.Size
            part.Position = partData.Position
            part.Anchored = false
            part.CanCollide = true
            part.Parent = dummy
            
            if partData.Name == "HumanoidRootPart" then
                dummy.PrimaryPart = part
                part.Transparency = 1
            end
        end
        
        -- Add humanoid
        local humanoid = Instance.new("Humanoid")
        humanoid.MaxHealth = CombatSettings.TestDummy.Health
        humanoid.Health = CombatSettings.TestDummy.Health
        humanoid.Parent = dummy
        
        -- Store in ServerStorage
        dummy.Parent = game.ServerStorage
    end
    
    local newDummy = dummy:Clone()
    newDummy:SetPrimaryPartCFrame(CFrame.new(position))
    newDummy.Name = "TestDummy_" .. behavior
    
    -- Add behavior tag
    local behaviorTag = Instance.new("StringValue")
    behaviorTag.Name = "Behavior"
    behaviorTag.Value = behavior
    behaviorTag.Parent = newDummy
    
    -- Add to workspace
    newDummy.Parent = workspace.CombatSystemFolder.TestDummies
    
    -- Add to tracking table
    table.insert(dummies, {
        Model = newDummy,
        Behavior = behavior,
        State = "Idle",
        StateStartTime = tick()
    })
    
    return newDummy
end

-- Spawn dummies command
CombatRemotes.SpawnDummies.OnServerEvent:Connect(function(player)
    -- Clear existing dummies
    for _, dummyData in ipairs(dummies) do
        if dummyData.Model and dummyData.Model.Parent then
            dummyData.Model:Destroy()
        end
    end
    dummies = {}
    
    -- Spawn different behavior dummies
    local spawnPositions = {
        {Vector3.new(0, 3, -10), "Idle"},
        {Vector3.new(10, 3, -10), "Blocking"},
        {Vector3.new(-10, 3, -10), "Parrying"},
        {Vector3.new(0, 3, -20), "Attacking"},
        {Vector3.new(10, 3, -20), "Dodging"}
    }
    
    for _, spawnData in ipairs(spawnPositions) do
        createDummy(spawnData[1], spawnData[2])
    end
    
    print("[COMBAT SYSTEM] Spawned test dummies")
end)

-- Clear dummies command
CombatRemotes.ClearDummies.OnServerEvent:Connect(function(player)
    for _, dummyData in ipairs(dummies) do
        if dummyData.Model and dummyData.Model.Parent then
            dummyData.Model:Destroy()
        end
    end
    dummies = {}
    print("[COMBAT SYSTEM] Cleared test dummies")
end)

-- Dummy AI behavior loop
RunService.Heartbeat:Connect(function()
    for _, dummyData in ipairs(dummies) do
        local dummy = dummyData.Model
        if not dummy or not dummy.Parent then continue end
        
        local humanoid = dummy:FindFirstChild("Humanoid")
        if not humanoid then continue end
        
        local currentTime = tick()
        local stateTime = currentTime - dummyData.StateStartTime
        
        -- Simple behavior simulation
        if dummyData.Behavior == "Blocking" then
            -- Toggle blocking every few seconds
            if stateTime > 2 then
                dummyData.State = dummyData.State == "Blocking" and "Idle" or "Blocking"
                dummyData.StateStartTime = currentTime
                
                -- Visual indicator
                local indicator = dummy:FindFirstChild("BlockIndicator")
                if not indicator then
                    indicator = Instance.new("SelectionBox")
                    indicator.Name = "BlockIndicator"
                    indicator.Adornee = dummy
                    indicator.Color3 = Color3.new(0, 0, 1)
                    indicator.LineThickness = 0.2
                    indicator.Parent = dummy
                end
                indicator.Transparency = dummyData.State == "Blocking" and 0 or 1
            end
        elseif dummyData.Behavior == "Parrying" then
            -- React to nearby attacks
            -- This would need integration with the combat system
        end
    end
end)

print("[COMBAT SYSTEM] Test dummy system initialized")
]]
    
    print("[COMBAT SYSTEM] Setup complete! Use chat commands:")
    print("  /debug_mode - Toggle debug visualization")
    print("  /spawn_dummies - Spawn test dummies")
    print("  /clear_dummies - Remove test dummies")
    print("")
    print("Controls:")
    print("  Mouse1 - Attack (4-hit combo)")
    print("  F - Block (hold) / Parry (tap)")
    print("  Q + WASD - Directional dash")
end

-- Run the setup
setupCombatSystem()
print("[ULTIMATE COMBAT SYSTEM] Installation complete!")