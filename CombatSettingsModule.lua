local CombatSettings = {}

-- M1 settings
CombatSettings.M1Animations = {
    [1] = "rbxassetid://112627375965381",
    [2] = "rbxassetid://107219571959162",
    [3] = "rbxassetid://71244140880155",
    [4] = "rbxassetid://119494483714064"
}
CombatSettings.M1Damage = 10
CombatSettings.ComboLimit = 4
CombatSettings.M1Duration = 0.5 -- Duration of each M1 hit

-- Dash settings
CombatSettings.DashForwardAnimation = "rbxassetid://72951822742730"
CombatSettings.DashBackwardAnimation = "rbxassetid://1284642812"
CombatSettings.DashLeftAnimation = "rbxassetid://1201718473"
CombatSettings.DashRightAnimation = "rbxassetid://871699376"
CombatSettings.DashCooldown = 1.5
CombatSettings.DashDistance = 10 -- Distance covered by dash
CombatSettings.DashDuration = 0.3 -- Duration of the dash movement (adjust for speed)

-- Hitstun animation
CombatSettings.HitstunAnimation = "rbxassetid://928454497"

-- Ragdoll settings
CombatSettings.RagdollDuration = 2

-- Debug settings
CombatSettings.DebugMode = true -- Enable or disable debug mode

return CombatSettings
