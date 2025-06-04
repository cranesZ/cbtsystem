-- Enhanced Terminal Setup Script for Roblox Studio Command Bar
-- This script sets up the complete enhanced combat system

local function setupCombatSystem()
    print("Starting Enhanced Combat System Setup...")
    
    -- Create folder structure
    local folders = {
        -- ReplicatedStorage
        {parent = game.ReplicatedStorage, name = "CombatData"},
        {parent = game.ReplicatedStorage, name = "Modules"},
        {parent = game.ReplicatedStorage, name = "RemoteEvents"},
        
        -- ServerScriptService
        {parent = game.ServerScriptService, name = "Combat"},
        {parent = game.ServerScriptService, name = "Handlers"},
        {parent = game.ServerScriptService, name = "Validation"},
        {parent = game.ServerScriptService, name = "Debug"},
        
        -- StarterPlayer
        {parent = game.StarterPlayer.StarterPlayerScripts, name = "Combat"},
        {parent = game.StarterPlayer.StarterPlayerScripts, name = "Effects"},
        {parent = game.StarterPlayer.StarterPlayerScripts, name = "UI"},
        
        -- StarterGui
        {parent = game.StarterGui, name = "CombatUI"},
        {parent = game.StarterGui.CombatUI, name = "Controllers"},
        {parent = game.StarterGui.CombatUI, name = "Frames"}
    }
    
    for _, folder in ipairs(folders) do
        if not folder.parent:FindFirstChild(folder.name) then
            local newFolder = Instance.new("Folder")
            newFolder.Name = folder.name
            newFolder.Parent = folder.parent
            print("Created folder:", folder.name)
        end
    end
    
    -- Create RemoteEvents
    local remoteEvents = {
        "CombatAction",
        "UpdateCombatUI",
        "PlayCombatEffect",
        "DamageNumber",
        "ChatMessage",
        "DebugUpdate"
    }
    
    for _, eventName in ipairs(remoteEvents) do
        if not game.ReplicatedStorage.RemoteEvents:FindFirstChild(eventName) then
            local remote = Instance.new("RemoteEvent")
            remote.Name = eventName
            remote.Parent = game.ReplicatedStorage.RemoteEvents
            print("Created RemoteEvent:", eventName)
        end
    end
    
    -- Create RemoteFunctions
    local remoteFunctions = {
        "GetCombatState",
        "ValidateAction"
    }
    
    for _, funcName in ipairs(remoteFunctions) do
        if not game.ReplicatedStorage.RemoteEvents:FindFirstChild(funcName) then
            local remote = Instance.new("RemoteFunction")
            remote.Name = funcName
            remote.Parent = game.ReplicatedStorage.RemoteEvents
            print("Created RemoteFunction:", funcName)
        end
    end
    
    print("Enhanced Combat System Setup Complete!")
    print("")
    print("=== NEXT STEPS ===")
    print("1. Copy all the module scripts to their respective folders")
    print("2. Test with /debug_mode command (admins only)")
    print("3. Spawn test dummies with /spawn_dummies")
    print("4. Configure admin usernames in DebugCommands.lua")
    print("")
    print("=== AVAILABLE COMMANDS ===")
    print("/debug_mode - Toggle debug visualization")
    print("/spawn_dummies - Spawn test dummies")
    print("/clear_dummies - Remove all test dummies")
    print("/reset_combat - Reset all combat states")
    print("/set_damage [number] - Change M1 damage")
    print("/god_mode - Enable god mode")
    print("/show_hitboxes - Toggle hitbox visualization")
    print("")
    print("=== CONTROLS ===")
    print("E - Toggle combat stance")
    print("Mouse1 - Basic attack (4-hit combo)")
    print("F (hold) - Block")
    print("F (tap) - Parry")
    print("Q + Direction - Directional dash")
    print("R - Critical attack")
    print("Double W - Sprint")
    
    -- Create a setup info script
    local setupInfo = Instance.new("Script")
    setupInfo.Name = "CombatSystemInfo"
    setupInfo.Source = [[
-- Enhanced Combat System v1.0
-- Setup completed on ]] .. os.date() .. [[

-- This system includes:
-- • 4-hit M1 combo with proper animations
-- • Directional dashing system
-- • Hitstun to prevent M1 trading
-- • Endlag after 4th hit
-- • Debug visualization mode
-- • Test dummy spawning
-- • Parrying during combos
-- • Proper stamina management

print("Enhanced Combat System Loaded!")
    ]]
    setupInfo.Parent = game.ServerScriptService
    setupInfo.Disabled = true
end

-- Run setup
setupCombatSystem()