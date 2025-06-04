-- COMBAT SYSTEM TERMINAL SETUP SCRIPT
-- Run this in Roblox Studio command bar to set up the entire combat system

local function setupCombatSystem()
    print("Setting up Combat System...")
    
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
    
    print("Combat System setup complete!")
    print("Folders created in:")
    print("- ServerScriptService/Combat")
    print("- ServerScriptService/Handlers")
    print("- ServerScriptService/Validation")
    print("- ReplicatedStorage/Modules")
    print("- ReplicatedStorage/RemoteEvents")
    print("- ReplicatedStorage/CombatData")
    print("- ReplicatedStorage/CombatAnimations")
    print("- ReplicatedStorage/CombatConfig")
    print("- StarterPlayer/StarterPlayerScripts/Combat")
    print("- StarterPlayer/StarterPlayerScripts/UI")
    print("- StarterPlayer/StarterPlayerScripts/Effects")
    print("- StarterGui/CombatUI")
    print("\nRemoteEvents created:")
    for _, event in ipairs(remoteEvents) do
        print("- " .. event)
    end
    print("\nNow paste your script files into the appropriate folders!")
end

-- Run the setup
setupCombatSystem()