-- COMPLETE COMBAT SYSTEM SETUP SCRIPT
-- Run this entire script in Roblox Studio command bar to set up the complete combat system

local function setupCombatSystem()
    print("Setting up Complete Combat System...")
    
    -- Create main folders
    local serverScriptService = game:GetService("ServerScriptService")
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local starterPlayer = game:GetService("StarterPlayer")
    local starterGui = game:GetService("StarterGui")
    
    -- Create ServerScriptService folders
    local combatFolder = Instance.new("Folder")
    combatFolder.Name = "Combat"
    combatFolder.Parent = serverScriptService
    
    local handlersFolder = Instance.new("Folder")
    handlersFolder.Name = "Handlers"
    handlersFolder.Parent = serverScriptService
    
    local validationFolder = Instance.new("Folder")
    validationFolder.Name = "Validation"
    validationFolder.Parent = serverScriptService
    
    -- Create ReplicatedStorage folders
    local modulesFolder = Instance.new("Folder")
    modulesFolder.Name = "Modules"
    modulesFolder.Parent = replicatedStorage
    
    local remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = replicatedStorage
    
    local combatDataFolder = Instance.new("Folder")
    combatDataFolder.Name = "CombatData"
    combatDataFolder.Parent = replicatedStorage
    
    -- Create all RemoteEvents
    local remoteEvents = {
        "CombatAction",
        "UpdateStats",
        "DamageDealt",
        "EffectRequest",
        "RunStateChanged"
    }
    
    for _, eventName in ipairs(remoteEvents) do
        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = eventName
        remoteEvent.Parent = remoteEventsFolder
    end
    
    -- Create RemoteFunctions
    local remoteFunctions = {
        "GetCombatState",
        "ValidateHit"
    }
    
    for _, funcName in ipairs(remoteFunctions) do
        local remoteFunction = Instance.new("RemoteFunction")
        remoteFunction.Name = funcName
        remoteFunction.Parent = remoteEventsFolder
    end
    
    -- Create StarterPlayer folders
    local starterPlayerScripts = starterPlayer:WaitForChild("StarterPlayerScripts")
    
    local clientCombatFolder = Instance.new("Folder")
    clientCombatFolder.Name = "Combat"
    clientCombatFolder.Parent = starterPlayerScripts
    
    local uiFolder = Instance.new("Folder")
    uiFolder.Name = "UI"
    uiFolder.Parent = starterPlayerScripts
    
    local effectsFolder = Instance.new("Folder")
    effectsFolder.Name = "Effects"
    effectsFolder.Parent = starterPlayerScripts
    
    -- Create StarterGui structure
    local combatGui = Instance.new("ScreenGui")
    combatGui.Name = "CombatUI"
    combatGui.ResetOnSpawn = false
    combatGui.Parent = starterGui
    
    -- Create main frame for UI
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.3, 0, 0.15, 0)
    mainFrame.Position = UDim2.new(0.35, 0, 0.02, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = combatGui
    
    -- Create Health Bar
    local healthContainer = Instance.new("Frame")
    healthContainer.Name = "HealthContainer"
    healthContainer.Size = UDim2.new(1, 0, 0.3, 0)
    healthContainer.Position = UDim2.new(0, 0, 0, 0)
    healthContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthContainer.BorderSizePixel = 2
    healthContainer.BorderColor3 = Color3.new(0, 0, 0)
    healthContainer.Parent = mainFrame
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthContainer
    
    local healthGradient = Instance.new("UIGradient")
    healthGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.4, 1, 0.4)),
        ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.8, 0.2))
    }
    healthGradient.Rotation = 90
    healthGradient.Parent = healthBar
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 / 100"
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.Parent = healthContainer
    
    -- Create Stamina Bar
    local staminaContainer = Instance.new("Frame")
    staminaContainer.Name = "StaminaContainer"
    staminaContainer.Size = UDim2.new(1, 0, 0.3, 0)
    staminaContainer.Position = UDim2.new(0, 0, 0.35, 0)
    staminaContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    staminaContainer.BorderSizePixel = 2
    staminaContainer.BorderColor3 = Color3.new(0, 0, 0)
    staminaContainer.Parent = mainFrame
    
    local staminaBar = Instance.new("Frame")
    staminaBar.Name = "StaminaBar"
    staminaBar.Size = UDim2.new(1, 0, 1, 0)
    staminaBar.BackgroundColor3 = Color3.new(0.2, 0.5, 0.8)
    staminaBar.BorderSizePixel = 0
    staminaBar.Parent = staminaContainer
    
    local staminaGradient = Instance.new("UIGradient")
    staminaGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.4, 0.7, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.5, 0.8))
    }
    staminaGradient.Rotation = 90
    staminaGradient.Parent = staminaBar
    
    local staminaLabel = Instance.new("TextLabel")
    staminaLabel.Name = "StaminaLabel"
    staminaLabel.Size = UDim2.new(1, 0, 1, 0)
    staminaLabel.BackgroundTransparency = 1
    staminaLabel.Text = "100 / 100"
    staminaLabel.TextScaled = true
    staminaLabel.Font = Enum.Font.SourceSansBold
    staminaLabel.TextColor3 = Color3.new(1, 1, 1)
    staminaLabel.TextStrokeTransparency = 0
    staminaLabel.Parent = staminaContainer
    
    -- Create Posture Bar
    local postureContainer = Instance.new("Frame")
    postureContainer.Name = "PostureContainer"
    postureContainer.Size = UDim2.new(1, 0, 0.3, 0)
    postureContainer.Position = UDim2.new(0, 0, 0.7, 0)
    postureContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    postureContainer.BorderSizePixel = 2
    postureContainer.BorderColor3 = Color3.new(0, 0, 0)
    postureContainer.Parent = mainFrame
    
    local postureBar = Instance.new("Frame")
    postureBar.Name = "PostureBar"
    postureBar.Size = UDim2.new(0, 0, 1, 0)
    postureBar.BackgroundColor3 = Color3.new(0.8, 0.8, 0.2)
    postureBar.BorderSizePixel = 0
    postureBar.Parent = postureContainer
    
    local postureGradient = Instance.new("UIGradient")
    postureGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0.4)),
        ColorSequenceKeypoint.new(1, Color3.new(0.8, 0.8, 0.2))
    }
    postureGradient.Rotation = 90
    postureGradient.Parent = postureBar
    
    local postureLabel = Instance.new("TextLabel")
    postureLabel.Name = "PostureLabel"
    postureLabel.Size = UDim2.new(1, 0, 1, 0)
    postureLabel.BackgroundTransparency = 1
    postureLabel.Text = "0 / 100"
    postureLabel.TextScaled = true
    postureLabel.Font = Enum.Font.SourceSansBold
    postureLabel.TextColor3 = Color3.new(1, 1, 1)
    postureLabel.TextStrokeTransparency = 0
    postureLabel.Parent = postureContainer
    
    -- Add corner rounding
    local corners = {healthContainer, staminaContainer, postureContainer}
    for _, container in ipairs(corners) do
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 4)
        uiCorner.Parent = container
    end
    
    -- Create combat state indicator
    local stateIndicator = Instance.new("Frame")
    stateIndicator.Name = "StateIndicator"
    stateIndicator.Size = UDim2.new(0.15, 0, 0.08, 0)
    stateIndicator.Position = UDim2.new(0.425, 0, 0.2, 0)
    stateIndicator.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    stateIndicator.BorderSizePixel = 2
    stateIndicator.BorderColor3 = Color3.new(0, 0, 0)
    stateIndicator.Parent = combatGui
    
    local stateCorner = Instance.new("UICorner")
    stateCorner.CornerRadius = UDim.new(0, 8)
    stateCorner.Parent = stateIndicator
    
    local stateText = Instance.new("TextLabel")
    stateText.Name = "StateText"
    stateText.Size = UDim2.new(1, 0, 1, 0)
    stateText.BackgroundTransparency = 1
    stateText.Text = "IDLE"
    stateText.TextScaled = true
    stateText.Font = Enum.Font.SourceSansBold
    stateText.TextColor3 = Color3.new(1, 1, 1)
    stateText.Parent = stateIndicator
    
    -- Create animations folder in ReplicatedStorage
    local animationsFolder = Instance.new("Folder")
    animationsFolder.Name = "CombatAnimations"
    animationsFolder.Parent = replicatedStorage
    
    -- Create animation objects
    local animations = {
        {Name = "BasicAttack", AnimationId = "rbxassetid://0"},
        {Name = "CriticalAttack", AnimationId = "rbxassetid://0"},
        {Name = "Block", AnimationId = "rbxassetid://0"},
        {Name = "Dodge", AnimationId = "rbxassetid://0"},
        {Name = "CombatStance", AnimationId = "rbxassetid://0"},
        {Name = "Stun", AnimationId = "rbxassetid://0"},
        {Name = "Run", AnimationId = "rbxassetid://0"}
    }
    
    for _, animData in ipairs(animations) do
        local animation = Instance.new("Animation")
        animation.Name = animData.Name
        animation.AnimationId = animData.AnimationId
        animation.Parent = animationsFolder
    end
    
    -- Create configuration values
    local configFolder = Instance.new("Folder")
    configFolder.Name = "CombatConfig"
    configFolder.Parent = replicatedStorage
    
    local configs = {
        {Name = "DebugMode", Value = false, Type = "BoolValue"},
        {Name = "DamageNumbersEnabled", Value = true, Type = "BoolValue"},
        {Name = "ScreenShakeEnabled", Value = true, Type = "BoolValue"},
        {Name = "ParticleEffectsEnabled", Value = true, Type = "BoolValue"}
    }
    
    for _, config in ipairs(configs) do
        local value = Instance.new(config.Type)
        value.Name = config.Name
        value.Value = config.Value
        value.Parent = configFolder
    end
    
    print("Structure created! Now creating scripts...")
    
    -- CREATE ALL SCRIPTS WITH CONTENT
    
    -- CombatHandler.lua
    local combatHandlerScript = Instance.new("Script")
    combatHandlerScript.Name = "CombatHandler"
    combatHandlerScript.Source = [[local CombatHandler = {}
CombatHandler.__index = CombatHandler

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CombatData = require(ReplicatedStorage:WaitForChild("CombatData"):WaitForChild("CombatConstants"))
local CombatValidator = require(script.Parent.Parent.Validation.CombatValidator)
local DamageHandler = require(script.Parent.Parent.Handlers.DamageHandler)

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local combatActionRemote = remoteEvents:WaitForChild("CombatAction")
local updateStatsRemote = remoteEvents:WaitForChild("UpdateStats")
local runStateChangedRemote = remoteEvents:WaitForChild("RunStateChanged")

local playerCombatStates = {}

function CombatHandler.new(player)
    local self = setmetatable({}, CombatHandler)
    
    self.player = player
    self.character = player.Character or player.CharacterAdded:Wait()
    self.humanoid = self.character:WaitForChild("Humanoid")
    
    self.stats = {
        health = CombatData.MAX_HEALTH,
        stamina = CombatData.MAX_STAMINA,
        posture = 0
    }
    
    self.state = {
        isBlocking = false,
        isParrying = false,
        isDodging = false,
        isAttacking = false,
        isStunned = false,
        inCombatStance = false,
        isRunning = false,
        lastParryTime = 0,
        lastDodgeTime = 0,
        lastAttackTime = 0,
        comboCount = 0
    }
    
    self.regenConnection = nil
    self:StartRegen()
    
    playerCombatStates[player] = self
    
    return self
end

function CombatHandler:StartRegen()
    self.regenConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not self.state.isStunned then
            if self.stats.posture > 0 then
                self.stats.posture = math.max(0, self.stats.posture - CombatData.POSTURE_DECAY_RATE * deltaTime)
            end
            
            if self.state.isRunning and self.stats.stamina > 0 then
                self.stats.stamina = math.max(0, self.stats.stamina - CombatData.RUN_STAMINA_DRAIN_RATE * deltaTime)
                if self.stats.stamina <= 0 then
                    self:SetRunning(false)
                end
            elseif not (self.state.isAttacking or self.state.isBlocking or self.state.isDodging or self.state.isRunning) then
                if self.stats.stamina < CombatData.MAX_STAMINA then
                    self.stats.stamina = math.min(CombatData.MAX_STAMINA, 
                        self.stats.stamina + CombatData.STAMINA_REGEN_RATE * deltaTime)
                end
            end
            
            self:UpdateClientStats()
        end
    end)
end

function CombatHandler:UpdateClientStats()
    updateStatsRemote:FireClient(self.player, {
        health = self.stats.health,
        stamina = self.stats.stamina,
        posture = self.stats.posture
    })
end

function CombatHandler:ToggleCombatStance()
    self.state.inCombatStance = not self.state.inCombatStance
    return self.state.inCombatStance
end

function CombatHandler:StartBlock()
    if self.state.isStunned or self.state.isAttacking then return false end
    
    self.state.isBlocking = true
    local currentTime = tick()
    
    if currentTime - self.state.lastParryTime <= CombatData.PARRY_WINDOW then
        self.state.isParrying = true
        task.wait(CombatData.PARRY_WINDOW)
        self.state.isParrying = false
    end
    
    self.state.lastParryTime = currentTime
    return true
end

function CombatHandler:EndBlock()
    self.state.isBlocking = false
    self.state.isParrying = false
end

function CombatHandler:AttemptDodge(direction)
    local currentTime = tick()
    
    if self.state.isStunned or self.state.isDodging then return false end
    if currentTime - self.state.lastDodgeTime < CombatData.DODGE_COOLDOWN then return false end
    if self.stats.stamina < CombatData.DODGE_STAMINA_COST then return false end
    
    self.stats.stamina = self.stats.stamina - CombatData.DODGE_STAMINA_COST
    self.state.isDodging = true
    self.state.lastDodgeTime = currentTime
    
    task.spawn(function()
        task.wait(CombatData.DODGE_STARTUP_TIME)
        
        task.wait(CombatData.DODGE_IFRAME_DURATION)
        
        task.wait(CombatData.DODGE_DURATION - CombatData.DODGE_STARTUP_TIME - CombatData.DODGE_IFRAME_DURATION)
        self.state.isDodging = false
    end)
    
    self:UpdateClientStats()
    return true
end

function CombatHandler:AttemptAttack(attackType)
    local currentTime = tick()
    
    if self.state.isStunned or self.state.isBlocking then return false end
    
    local attackData = attackType == "critical" and CombatData.CRITICAL_ATTACK or CombatData.BASIC_ATTACK
    
    if currentTime - self.state.lastAttackTime < attackData.cooldown and not self.state.isAttacking then
        return false
    end
    
    self.state.isAttacking = true
    self.state.lastAttackTime = currentTime
    
    if attackType == "basic" and currentTime - self.state.lastAttackTime < CombatData.COMBO_WINDOW then
        self.state.comboCount = math.min(self.state.comboCount + 1, CombatData.MAX_COMBO)
    else
        self.state.comboCount = 0
    end
    
    task.wait(attackData.duration)
    self.state.isAttacking = false
    
    return true
end

function CombatHandler:TakeDamage(damage, attacker, attackType)
    if self.state.isDodging and tick() > self.state.lastDodgeTime + CombatData.DODGE_STARTUP_TIME then
        return {blocked = false, dodged = true, parried = false, damage = 0}
    end
    
    local result = {
        blocked = false,
        dodged = false,
        parried = false,
        damage = damage
    }
    
    if self.state.isParrying then
        result.parried = true
        result.damage = 0
        self.stats.posture = math.max(0, self.stats.posture - CombatData.PARRY_POSTURE_REDUCTION)
        
        if playerCombatStates[attacker] then
            playerCombatStates[attacker].stats.posture = math.min(CombatData.MAX_POSTURE,
                playerCombatStates[attacker].stats.posture + CombatData.PARRY_POSTURE_GAIN)
            playerCombatStates[attacker]:CheckPostureBreak()
        end
    elseif self.state.isBlocking and attackType ~= "critical" then
        result.blocked = true
        result.damage = damage * (1 - CombatData.BLOCK_DAMAGE_REDUCTION)
        self.stats.posture = math.min(CombatData.MAX_POSTURE, 
            self.stats.posture + CombatData.BLOCK_POSTURE_GAIN)
    end
    
    self.stats.health = math.max(0, self.stats.health - result.damage)
    self:CheckPostureBreak()
    self:UpdateClientStats()
    
    if self.stats.health <= 0 then
        self:OnDeath()
    end
    
    return result
end

function CombatHandler:CheckPostureBreak()
    if self.stats.posture >= CombatData.MAX_POSTURE and not self.state.isStunned then
        self.state.isStunned = true
        self.state.isBlocking = false
        self.state.isAttacking = false
        
        task.wait(CombatData.POSTURE_BREAK_STUN_DURATION)
        
        self.state.isStunned = false
        self.stats.posture = 0
        self:UpdateClientStats()
    end
end

function CombatHandler:SetRunning(isRunning)
    if not self.state.inCombatStance then return false end
    if isRunning and self.stats.stamina < CombatData.MIN_STAMINA_TO_RUN then return false end
    
    self.state.isRunning = isRunning
    return true
end

function CombatHandler:OnDeath()
    self.humanoid.Health = 0
end

function CombatHandler:Cleanup()
    if self.regenConnection then
        self.regenConnection:Disconnect()
    end
    playerCombatStates[self.player] = nil
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        CombatHandler.new(player)
    end)
    
    player.CharacterRemoving:Connect(function()
        if playerCombatStates[player] then
            playerCombatStates[player]:Cleanup()
        end
    end)
end

local function onCombatAction(player, action, data)
    local handler = playerCombatStates[player]
    if not handler then return end
    
    if not CombatValidator:ValidateAction(player, action, data) then
        return
    end
    
    if action == "toggleStance" then
        local newState = handler:ToggleCombatStance()
        combatActionRemote:FireClient(player, "stanceChanged", newState)
        
    elseif action == "startBlock" then
        handler:StartBlock()
        
    elseif action == "endBlock" then
        handler:EndBlock()
        
    elseif action == "dodge" then
        local success = handler:AttemptDodge(data.direction)
        if success then
            combatActionRemote:FireClient(player, "dodgeStarted", {direction = data.direction})
        end
        
    elseif action == "attack" then
        local success = handler:AttemptAttack(data.type)
        if success then
            combatActionRemote:FireClient(player, "attackStarted", {type = data.type})
            DamageHandler:ProcessAttack(player, data.type, handler.state.comboCount)
        end
    end
end

local function onRunStateChanged(player, isRunning)
    local handler = playerCombatStates[player]
    if not handler then return end
    
    local success = handler:SetRunning(isRunning)
    if success then
        local effectRemote = remoteEvents:WaitForChild("EffectRequest")
        if isRunning then
            effectRemote:FireAllClients("running", {character = player.Character})
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
combatActionRemote.OnServerEvent:Connect(onCombatAction)
runStateChangedRemote.OnServerEvent:Connect(onRunStateChanged)

return CombatHandler]]
    combatHandlerScript.Parent = combatFolder
    
    -- DamageHandler.lua
    local damageHandlerScript = Instance.new("ModuleScript")
    damageHandlerScript.Name = "DamageHandler"
    damageHandlerScript.Source = [[local DamageHandler = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local CombatData = require(ReplicatedStorage:WaitForChild("CombatData"):WaitForChild("CombatConstants"))
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local damageDealtRemote = remoteEvents:WaitForChild("DamageDealt")

local Region3 = Region3
local Vector3 = Vector3
local CFrame = CFrame

function DamageHandler:ProcessAttack(attacker, attackType, comboCount)
    local character = attacker.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local attackData = attackType == "critical" and CombatData.CRITICAL_ATTACK or CombatData.BASIC_ATTACK
    local damage = attackData.damage
    
    if attackType == "basic" and comboCount > 0 then
        damage = damage * (1 + comboCount * CombatData.COMBO_DAMAGE_MULTIPLIER)
    end
    
    local hitboxSize = Vector3.new(4, 4, attackData.range)
    local hitboxCFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -attackData.range/2)
    
    local region = Region3.new(
        hitboxCFrame.Position - hitboxSize/2,
        hitboxCFrame.Position + hitboxSize/2
    )
    region = region:ExpandToGrid(4)
    
    local parts = Workspace:FindPartsInRegion3(region, character, 20)
    local hitPlayers = {}
    
    for _, part in ipairs(parts) do
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local targetPlayer = Players:GetPlayerFromCharacter(part.Parent)
            if targetPlayer and targetPlayer ~= attacker and not hitPlayers[targetPlayer] then
                hitPlayers[targetPlayer] = true
                
                local targetRootPart = part.Parent:FindFirstChild("HumanoidRootPart")
                if targetRootPart then
                    local toTarget = (targetRootPart.Position - humanoidRootPart.Position)
                    local distance = toTarget.Magnitude
                    
                    if distance <= attackData.range then
                        local dotProduct = humanoidRootPart.CFrame.LookVector:Dot(toTarget.Unit)
                        
                        if dotProduct > 0.5 then
                            local playerCombatStates = require(script.Parent.Parent.Combat.CombatHandler)
                            local targetHandler = playerCombatStates[targetPlayer]
                            
                            if targetHandler then
                                local result = targetHandler:TakeDamage(damage, attacker, attackType)
                                
                                damageDealtRemote:FireClient(attacker, {
                                    target = targetPlayer,
                                    damage = result.damage,
                                    blocked = result.blocked,
                                    dodged = result.dodged,
                                    parried = result.parried
                                })
                                
                                damageDealtRemote:FireClient(targetPlayer, {
                                    attacker = attacker,
                                    damage = result.damage,
                                    blocked = result.blocked,
                                    dodged = result.dodged,
                                    parried = result.parried
                                })
                            end
                        end
                    end
                end
            end
        end
    end
end

return DamageHandler]]
    damageHandlerScript.Parent = handlersFolder
    
    -- CombatValidator.lua
    local combatValidatorScript = Instance.new("ModuleScript")
    combatValidatorScript.Name = "CombatValidator"
    combatValidatorScript.Source = [[local CombatValidator = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CombatData = require(ReplicatedStorage:WaitForChild("CombatData"):WaitForChild("CombatConstants"))

local lastActionTimes = {}
local actionCounts = {}

function CombatValidator:ValidateAction(player, action, data)
    if not player or not player.Character then return false end
    
    local playerId = player.UserId
    local currentTime = tick()
    
    if not lastActionTimes[playerId] then
        lastActionTimes[playerId] = {}
        actionCounts[playerId] = {}
    end
    
    local lastTime = lastActionTimes[playerId][action] or 0
    local timeDiff = currentTime - lastTime
    
    if timeDiff < 0.05 then
        return false
    end
    
    if not actionCounts[playerId][action] then
        actionCounts[playerId][action] = 0
    end
    
    actionCounts[playerId][action] = actionCounts[playerId][action] + 1
    
    if actionCounts[playerId][action] > 50 then
        if timeDiff < 1 then
            warn("Potential exploit detected from player:", player.Name, "Action:", action)
            return false
        else
            actionCounts[playerId][action] = 0
        end
    end
    
    lastActionTimes[playerId][action] = currentTime
    
    if action == "attack" then
        if not data or not data.type then return false end
        if data.type ~= "basic" and data.type ~= "critical" then return false end
    elseif action == "dodge" then
        if not data or not data.direction then return false end
        local dir = data.direction
        if typeof(dir) ~= "Vector3" or dir.Magnitude > 1.1 then return false end
    end
    
    return true
end

function CombatValidator:ValidatePosition(player, position)
    if not player.Character then return false end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local distance = (rootPart.Position - position).Magnitude
    
    if distance > 50 then
        warn("Position validation failed for player:", player.Name, "Distance:", distance)
        return false
    end
    
    return true
end

function CombatValidator:CleanupPlayer(player)
    local playerId = player.UserId
    lastActionTimes[playerId] = nil
    actionCounts[playerId] = nil
end

Players.PlayerRemoving:Connect(function(player)
    CombatValidator:CleanupPlayer(player)
end)

return CombatValidator]]
    combatValidatorScript.Parent = validationFolder
    
    -- CombatConstants.lua
    local combatConstantsScript = Instance.new("ModuleScript")
    combatConstantsScript.Name = "CombatConstants"
    combatConstantsScript.Source = [[local CombatConstants = {
    MAX_HEALTH = 100,
    MAX_STAMINA = 100,
    MAX_POSTURE = 100,
    
    STAMINA_REGEN_RATE = 25,
    POSTURE_DECAY_RATE = 10,
    
    DODGE_STAMINA_COST = 20,
    PARRY_STAMINA_COST = 15,
    
    DODGE_DURATION = 0.6,
    DODGE_STARTUP_TIME = 0.1,
    DODGE_IFRAME_DURATION = 0.2,
    DODGE_DISTANCE = 3,
    DODGE_COOLDOWN = 0.8,
    
    PARRY_WINDOW = 0.2,
    PARRY_POSTURE_REDUCTION = 30,
    PARRY_POSTURE_GAIN = 40,
    
    BLOCK_DAMAGE_REDUCTION = 0.75,
    BLOCK_POSTURE_GAIN = 25,
    
    POSTURE_BREAK_STUN_DURATION = 1,
    
    BASIC_ATTACK = {
        damage = 25,
        range = 6,
        duration = 0.3,
        cooldown = 0.4
    },
    
    CRITICAL_ATTACK = {
        damage = 40,
        range = 8,
        duration = 0.5,
        cooldown = 1
    },
    
    COMBO_WINDOW = 0.5,
    MAX_COMBO = 3,
    COMBO_DAMAGE_MULTIPLIER = 0.1,
    
    RUN_SPEED_MULTIPLIER = 1.6,
    RUN_STAMINA_DRAIN_RATE = 10,
    DOUBLE_TAP_WINDOW = 0.3,
    MIN_STAMINA_TO_RUN = 10
}

return CombatConstants]]
    combatConstantsScript.Parent = combatDataFolder
    
    -- CombatUtilities.lua
    local combatUtilitiesScript = Instance.new("ModuleScript")
    combatUtilitiesScript.Name = "CombatUtilities"
    combatUtilitiesScript.Source = [[local CombatUtilities = {}

local TweenService = game:GetService("TweenService")

function CombatUtilities:CreateTween(object, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle,
        easingDirection
    )
    
    return TweenService:Create(object, tweenInfo, properties)
end

function CombatUtilities:Lerp(a, b, t)
    return a + (b - a) * t
end

function CombatUtilities:ClampValue(value, min, max)
    return math.max(min, math.min(max, value))
end

function CombatUtilities:CreateScreenShake(camera, intensity, duration)
    local startTime = tick()
    local originalCFrame = camera.CFrame
    
    task.spawn(function()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local shake = intensity * (1 - elapsed / duration)
            
            local offsetX = math.random() * shake * 2 - shake
            local offsetY = math.random() * shake * 2 - shake
            
            camera.CFrame = originalCFrame * CFrame.new(offsetX, offsetY, 0)
            
            game:GetService("RunService").RenderStepped:Wait()
        end
        
        camera.CFrame = originalCFrame
    end)
end

function CombatUtilities:CreateDamageIndicator(position, damage, color)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(2, 0, 1, 0)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tostring(math.floor(damage))
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = color or Color3.new(1, 0.2, 0.2)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = billboardGui
    
    local attachment = Instance.new("Attachment")
    attachment.Position = position
    attachment.Parent = workspace.Terrain
    billboardGui.Parent = attachment
    
    local tween = self:CreateTween(
        textLabel,
        {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            Position = UDim2.new(0, 0, -1, 0)
        },
        1
    )
    
    tween:Play()
    tween.Completed:Connect(function()
        attachment:Destroy()
    end)
end

function CombatUtilities:CreateCombatEffect(effectType, position, color)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = color or Color3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace
    
    if effectType == "slash" then
        part.Size = Vector3.new(0.2, 5, 5)
        part.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(45), 0)
        
        local tween = self:CreateTween(
            part,
            {
                Size = Vector3.new(0.05, 8, 8),
                Transparency = 1
            },
            0.3
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            part:Destroy()
        end)
        
    elseif effectType == "impact" then
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(1, 1, 1)
        
        local tween = self:CreateTween(
            part,
            {
                Size = Vector3.new(4, 4, 4),
                Transparency = 1
            },
            0.4
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            part:Destroy()
        end)
        
    elseif effectType == "block" then
        part.Size = Vector3.new(3, 3, 0.2)
        part.Shape = Enum.PartType.Cylinder
        part.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
        
        local tween = self:CreateTween(
            part,
            {
                Size = Vector3.new(5, 5, 0.1),
                Transparency = 1
            },
            0.5
        )
        
        tween:Play()
        tween.Completed:Connect(function()
            part:Destroy()
        end)
    end
end

return CombatUtilities]]
    combatUtilitiesScript.Parent = modulesFolder
    
    -- CombatInput.lua
    local combatInputScript = Instance.new("LocalScript")
    combatInputScript.Name = "CombatInput"
    combatInputScript.Source = [[local CombatInput = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local CombatData = require(ReplicatedStorage:WaitForChild("CombatData"):WaitForChild("CombatConstants"))
local CombatUtilities = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CombatUtilities"))

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local combatActionRemote = remoteEvents:WaitForChild("CombatAction")
local runStateChangedRemote = remoteEvents:WaitForChild("RunStateChanged")

local mouse = player:GetMouse()

local combatState = {
    inStance = false,
    isBlocking = false,
    isRunning = false,
    canAttack = true,
    canDodge = true,
    lastWPress = 0,
    currentCombo = 0
}

local keybinds = {
    toggleStance = Enum.KeyCode.E,
    block = Enum.KeyCode.F,
    dodge = Enum.KeyCode.Q,
    criticalAttack = Enum.KeyCode.R,
    run = Enum.KeyCode.W
}

local normalWalkSpeed = 16
local runWalkSpeed = normalWalkSpeed * CombatData.RUN_SPEED_MULTIPLIER

local function handleCombatStance()
    combatActionRemote:FireServer("toggleStance")
end

local function startBlock()
    if not combatState.inStance or combatState.isBlocking then return end
    combatState.isBlocking = true
    combatActionRemote:FireServer("startBlock")
end

local function endBlock()
    if not combatState.isBlocking then return end
    combatState.isBlocking = false
    combatActionRemote:FireServer("endBlock")
end

local function performDodge()
    if not combatState.inStance or not combatState.canDodge then return end
    
    local moveVector = humanoid.MoveDirection
    if moveVector.Magnitude == 0 then
        moveVector = rootPart.CFrame.LookVector
    end
    
    combatState.canDodge = false
    combatActionRemote:FireServer("dodge", {direction = moveVector})
    
    task.wait(CombatData.DODGE_COOLDOWN)
    combatState.canDodge = true
end

local function performAttack(attackType)
    if not combatState.inStance or not combatState.canAttack then return end
    if combatState.isBlocking then return end
    
    combatState.canAttack = false
    combatActionRemote:FireServer("attack", {type = attackType})
    
    local attackData = attackType == "critical" and CombatData.CRITICAL_ATTACK or CombatData.BASIC_ATTACK
    task.wait(attackData.cooldown)
    combatState.canAttack = true
end

local function handleRunning()
    local currentTime = tick()
    local timeSinceLastPress = currentTime - combatState.lastWPress
    
    if timeSinceLastPress <= CombatData.DOUBLE_TAP_WINDOW then
        if not combatState.isRunning then
            combatState.isRunning = true
            humanoid.WalkSpeed = runWalkSpeed
            runStateChangedRemote:FireServer(true)
        end
    end
    
    combatState.lastWPress = currentTime
end

local function stopRunning()
    if combatState.isRunning then
        combatState.isRunning = false
        humanoid.WalkSpeed = normalWalkSpeed
        runStateChangedRemote:FireServer(false)
    end
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == keybinds.toggleStance then
        handleCombatStance()
    elseif input.KeyCode == keybinds.block then
        startBlock()
    elseif input.KeyCode == keybinds.dodge then
        performDodge()
    elseif input.KeyCode == keybinds.criticalAttack then
        performAttack("critical")
    elseif input.KeyCode == keybinds.run then
        handleRunning()
    end
end

local function onInputEnded(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == keybinds.block then
        endBlock()
    elseif input.KeyCode == keybinds.run then
        stopRunning()
    end
end

local function onMouseButton1Click()
    performAttack("basic")
end

combatActionRemote.OnClientEvent:Connect(function(action, data)
    if action == "stanceChanged" then
        combatState.inStance = data
        if not combatState.inStance then
            combatState.isBlocking = false
            stopRunning()
        end
    elseif action == "dodgeStarted" then
        local dodgeTween = TweenService:Create(
            rootPart,
            TweenInfo.new(CombatData.DODGE_DURATION, Enum.EasingStyle.Linear),
            {CFrame = rootPart.CFrame + data.direction * CombatData.DODGE_DISTANCE}
        )
        dodgeTween:Play()
    end
end)

RunService.Heartbeat:Connect(function()
    if combatState.isRunning and humanoid.MoveDirection.Magnitude == 0 then
        stopRunning()
    end
end)

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
mouse.Button1Down:Connect(onMouseButton1Click)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    combatState.isRunning = false
    combatState.inStance = false
    combatState.isBlocking = false
end)

return CombatInput]]
    combatInputScript.Parent = clientCombatFolder
    
    -- CombatUI.lua
    local combatUIScript = Instance.new("LocalScript")
    combatUIScript.Name = "CombatUI"
    combatUIScript.Source = [[local CombatUI = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CombatData = require(ReplicatedStorage:WaitForChild("CombatData"):WaitForChild("CombatConstants"))
local CombatUtilities = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CombatUtilities"))

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local updateStatsRemote = remoteEvents:WaitForChild("UpdateStats")
local damageDealtRemote = remoteEvents:WaitForChild("DamageDealt")

local combatGui = playerGui:WaitForChild("CombatUI")
local mainFrame = combatGui:WaitForChild("MainFrame")

local healthBar = mainFrame:WaitForChild("HealthContainer"):WaitForChild("HealthBar")
local healthLabel = mainFrame:WaitForChild("HealthContainer"):WaitForChild("HealthLabel")
local staminaBar = mainFrame:WaitForChild("StaminaContainer"):WaitForChild("StaminaBar")
local staminaLabel = mainFrame:WaitForChild("StaminaContainer"):WaitForChild("StaminaLabel")
local postureBar = mainFrame:WaitForChild("PostureContainer"):WaitForChild("PostureBar")
local postureLabel = mainFrame:WaitForChild("PostureContainer"):WaitForChild("PostureLabel")

local stateIndicator = combatGui:WaitForChild("StateIndicator")
local stateText = stateIndicator:WaitForChild("StateText")

local currentStats = {
    health = CombatData.MAX_HEALTH,
    stamina = CombatData.MAX_STAMINA,
    posture = 0
}

local targetStats = {
    health = CombatData.MAX_HEALTH,
    stamina = CombatData.MAX_STAMINA,
    posture = 0
}

local function updateBar(bar, current, max, label)
    local percentage = math.clamp(current / max, 0, 1)
    
    local tween = CombatUtilities:CreateTween(
        bar,
        {Size = UDim2.new(percentage, 0, 1, 0)},
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    tween:Play()
    
    label.Text = string.format("%d / %d", math.floor(current), max)
end

local function flashBar(bar, color)
    local originalColor = bar.BackgroundColor3
    bar.BackgroundColor3 = color
    
    task.wait(0.1)
    
    local tween = CombatUtilities:CreateTween(
        bar,
        {BackgroundColor3 = originalColor},
        0.2
    )
    tween:Play()
end

local function updateHealthBar(newHealth)
    targetStats.health = newHealth
    updateBar(healthBar, newHealth, CombatData.MAX_HEALTH, healthLabel)
    
    if newHealth < currentStats.health then
        flashBar(healthBar, Color3.new(1, 0.2, 0.2))
    elseif newHealth > currentStats.health then
        flashBar(healthBar, Color3.new(0.2, 1, 0.2))
    end
    
    currentStats.health = newHealth
end

local function updateStaminaBar(newStamina)
    targetStats.stamina = newStamina
    updateBar(staminaBar, newStamina, CombatData.MAX_STAMINA, staminaLabel)
    
    if newStamina < 20 then
        local pulse = math.abs(math.sin(tick() * 3))
        staminaBar.BackgroundColor3 = staminaBar.BackgroundColor3:Lerp(Color3.new(0.8, 0.2, 0.2), pulse * 0.5)
    end
    
    currentStats.stamina = newStamina
end

local function updatePostureBar(newPosture)
    targetStats.posture = newPosture
    updateBar(postureBar, newPosture, CombatData.MAX_POSTURE, postureLabel)
    
    if newPosture >= 75 then
        local warningPulse = math.abs(math.sin(tick() * 4))
        postureBar.BackgroundColor3 = postureBar.BackgroundColor3:Lerp(Color3.new(1, 0.4, 0.2), warningPulse * 0.6)
        
        if newPosture >= 90 then
            local camera = workspace.CurrentCamera
            CombatUtilities:CreateScreenShake(camera, 0.1, 0.1)
        end
    end
    
    currentStats.posture = newPosture
end

local function updateCombatState(state)
    stateText.Text = state
    
    local stateColors = {
        IDLE = Color3.new(0.3, 0.3, 0.3),
        COMBAT = Color3.new(0.8, 0.4, 0.2),
        BLOCKING = Color3.new(0.2, 0.4, 0.8),
        STUNNED = Color3.new(0.8, 0.2, 0.2),
        RUNNING = Color3.new(0.2, 0.8, 0.4)
    }
    
    local targetColor = stateColors[state] or Color3.new(0.3, 0.3, 0.3)
    
    local tween = CombatUtilities:CreateTween(
        stateIndicator,
        {BackgroundColor3 = targetColor},
        0.2
    )
    tween:Play()
end

updateStatsRemote.OnClientEvent:Connect(function(stats)
    if stats.health then
        updateHealthBar(stats.health)
    end
    if stats.stamina then
        updateStaminaBar(stats.stamina)
    end
    if stats.posture then
        updatePostureBar(stats.posture)
    end
end)

damageDealtRemote.OnClientEvent:Connect(function(data)
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local color = Color3.new(1, 0.2, 0.2)
    local effectType = "impact"
    
    if data.blocked then
        color = Color3.new(0.2, 0.4, 0.8)
        effectType = "block"
    elseif data.dodged then
        color = Color3.new(0.8, 0.8, 0.8)
        return
    elseif data.parried then
        color = Color3.new(0.8, 0.6, 0.2)
        effectType = "block"
    end
    
    if data.damage > 0 then
        CombatUtilities:CreateDamageIndicator(rootPart.Position + Vector3.new(0, 2, 0), data.damage, color)
    end
    
    CombatUtilities:CreateCombatEffect(effectType, rootPart.Position, color)
end)

RunService.Heartbeat:Connect(function(deltaTime)
    for stat, value in pairs(currentStats) do
        if math.abs(value - targetStats[stat]) > 0.1 then
            currentStats[stat] = CombatUtilities:Lerp(value, targetStats[stat], deltaTime * 10)
            
            if stat == "health" then
                updateBar(healthBar, currentStats[stat], CombatData.MAX_HEALTH, healthLabel)
            elseif stat == "stamina" then
                updateBar(staminaBar, currentStats[stat], CombatData.MAX_STAMINA, staminaLabel)
            elseif stat == "posture" then
                updateBar(postureBar, currentStats[stat], CombatData.MAX_POSTURE, postureLabel)
            end
        end
    end
end)

return CombatUI]]
    combatUIScript.Parent = uiFolder
    
    -- CombatEffects.lua
    local combatEffectsScript = Instance.new("LocalScript")
    combatEffectsScript.Name = "CombatEffects"
    combatEffectsScript.Source = [[local CombatEffects = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local CombatUtilities = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CombatUtilities"))
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local effectRequestRemote = remoteEvents:WaitForChild("EffectRequest")

local function createSlashEffect(position, direction, color)
    local slash = Instance.new("Part")
    slash.Name = "SlashEffect"
    slash.Anchored = true
    slash.CanCollide = false
    slash.Material = Enum.Material.Neon
    slash.Color = color or Color3.new(1, 1, 1)
    slash.Size = Vector3.new(0.2, 5, 5)
    slash.CFrame = CFrame.new(position, position + direction) * CFrame.Angles(0, math.rad(45), 0)
    slash.Parent = workspace
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(0.1, 1, 1)
    mesh.Parent = slash
    
    local tween = CombatUtilities:CreateTween(
        slash,
        {
            Size = Vector3.new(0.05, 8, 8),
            Transparency = 1
        },
        0.3
    )
    
    tween:Play()
    Debris:AddItem(slash, 0.5)
end

local function createImpactRing(position, color)
    local ring = Instance.new("Part")
    ring.Name = "ImpactRing"
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = color or Color3.new(1, 1, 1)
    ring.Size = Vector3.new(2, 0.2, 2)
    ring.Shape = Enum.PartType.Cylinder
    ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), 0, 0)
    ring.Parent = workspace
    
    local tween = CombatUtilities:CreateTween(
        ring,
        {
            Size = Vector3.new(10, 0.1, 10),
            Transparency = 1
        },
        0.5
    )
    
    tween:Play()
    Debris:AddItem(ring, 0.6)
end

local function createBlockShield(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local shield = Instance.new("Part")
    shield.Name = "BlockShield"
    shield.Anchored = false
    shield.CanCollide = false
    shield.Material = Enum.Material.ForceField
    shield.Color = Color3.new(0.2, 0.4, 0.8)
    shield.Transparency = 0.7
    shield.Size = Vector3.new(4, 6, 0.5)
    shield.Parent = character
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = shield
    weld.Part1 = rootPart
    weld.Parent = shield
    
    shield.CFrame = rootPart.CFrame * CFrame.new(0, 0, -2)
    
    Debris:AddItem(shield, 0.3)
end

local function createDodgeTrail(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local trail = Instance.new("Trail")
    trail.Lifetime = 0.3
    trail.MinLength = 0
    trail.FaceCamera = true
    trail.Color = ColorSequence.new(Color3.new(0.8, 0.8, 1))
    trail.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    }
    
    local attachment0 = Instance.new("Attachment", rootPart)
    attachment0.Position = Vector3.new(0, 2, 0)
    local attachment1 = Instance.new("Attachment", rootPart)
    attachment1.Position = Vector3.new(0, -2, 0)
    
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Parent = character
    
    Debris:AddItem(trail, 1)
    Debris:AddItem(attachment0, 1)
    Debris:AddItem(attachment1, 1)
end

local function createStunEffect(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    for i = 1, 3 do
        local star = Instance.new("Part")
        star.Name = "StunStar"
        star.Anchored = false
        star.CanCollide = false
        star.Material = Enum.Material.Neon
        star.Color = Color3.new(1, 1, 0)
        star.Size = Vector3.new(0.5, 0.5, 0.1)
        star.Parent = character
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxasset://fonts/timebomb.mesh"
        mesh.Scale = Vector3.new(0.5, 0.5, 0.5)
        mesh.Parent = star
        
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Parent = star
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 10, 0)
        bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
        bodyAngularVelocity.Parent = star
        
        task.spawn(function()
            local angle = (i - 1) * 120
            while star and star.Parent do
                angle = angle + 3
                local offset = Vector3.new(math.cos(math.rad(angle)) * 2, 2, math.sin(math.rad(angle)) * 2)
                bodyPosition.Position = head.Position + offset
                task.wait()
            end
        end)
        
        Debris:AddItem(star, 1)
    end
end

local function createRunningEffect(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local dust = Instance.new("ParticleEmitter")
    dust.Texture = "rbxasset://textures/particles/smoke_main.dds"
    dust.Color = ColorSequence.new(Color3.new(0.5, 0.5, 0.5))
    dust.Lifetime = NumberRange.new(0.5, 1)
    dust.Rate = 50
    dust.Speed = NumberRange.new(2, 4)
    dust.SpreadAngle = Vector2.new(20, 20)
    dust.VelocityInheritance = 0.5
    dust.EmissionDirection = Enum.NormalId.Bottom
    dust.Parent = rootPart
    
    Debris:AddItem(dust, 0.5)
end

effectRequestRemote.OnClientEvent:Connect(function(effectType, data)
    if effectType == "slash" then
        createSlashEffect(data.position, data.direction, data.color)
    elseif effectType == "impact" then
        createImpactRing(data.position, data.color)
    elseif effectType == "block" then
        createBlockShield(data.character)
    elseif effectType == "dodge" then
        createDodgeTrail(data.character)
    elseif effectType == "stun" then
        createStunEffect(data.character)
    elseif effectType == "running" then
        createRunningEffect(data.character)
    end
end)

return CombatEffects]]
    combatEffectsScript.Parent = effectsFolder
    
    print("Complete Combat System setup finished!")
    print("All scripts have been created and placed in their appropriate folders.")
    print("\nSystem includes:")
    print("- Full combat mechanics (attack, block, parry, dodge)")
    print("- Running system with double-tap W")
    print("- Health/Stamina/Posture system with UI")
    print("- Visual effects for all actions")
    print("- Server-authoritative validation")
    print("- Anti-exploit measures")
    print("\nThe system is ready to use!")
end

-- Run the setup
setupCombatSystem()