# Roblox Combat System

A complete multiplayer combat system for Roblox with server-authoritative validation, smooth client prediction, and comprehensive combat mechanics.

## Setup Instructions

1. Open Roblox Studio
2. Paste and run `TerminalSetupScript.lua` in the command bar
3. The script creates all folders, RemoteEvents, animations and scripts automatically.

## Controls

- **E** - Toggle combat stance (required for all combat actions)
- **F** - Hold to block (75% damage reduction) / Tap to parry (200ms window)
- **Q** - Dodge/dash in movement direction (costs 20 stamina)
- **M1** - Basic attack (25 damage, chainable)
- **R** - Critical attack (40 damage, breaks blocks)
- **Double-tap W** - Sprint (drains stamina while running)

## Combat Mechanics

### Health System
- Maximum: 100 HP
- Displays as green bar with smooth animations
- Red flash on damage, green glow on heal

### Stamina System
- Maximum: 100 stamina
- Regenerates at 25/second when not performing actions
- Costs:
  - Dodge: 20 stamina
  - Parry attempt: 15 stamina
  - Running: 10/second drain
- Blue bar with pulsing effect when low

### Posture System
- Range: 0-100
- Gains:
  - +25 when blocking hits
  - +40 when getting parried
- Losses:
  - -30 on successful parry
  - -10/second passive decay
- At 100%: 1-second complete stun
- Yellow bar with warning effects at high values

### Combat States
- **IDLE** - Default state
- **COMBAT** - In combat stance
- **BLOCKING** - Actively blocking
- **STUNNED** - Posture broken
- **RUNNING** - Sprinting

## Features

### Multiplayer Support
- Server-authoritative combat validation
- Client prediction for responsive controls
- Anti-exploit measures for timing and damage
- Synchronized effects across all clients

### Visual Effects
- Damage numbers with color coding
- Slash effects for attacks
- Impact rings for hits
- Block shields
- Dodge trails
- Stun stars
- Running dust particles

### Animation System
- Smooth UI transitions with easing
- Screen shake on high posture
- Interpolated stat bars
- State-based color indicators

## Technical Details

### Server Architecture
- `CombatHandler` - Main combat logic and state management
- `DamageHandler` - Hitbox detection and damage calculation
- `CombatValidator` - Anti-exploit validation

### Client Architecture
- `CombatInput` - Input handling and action requests
- `CombatUI` - UI updates and stat display
- `CombatEffects` - Visual effect generation

### Shared Modules
- `CombatConstants` - All combat values and settings
- `CombatUtilities` - Helper functions for effects and tweening

## Customization

Edit values in `CombatConstants.lua` to adjust:
- Damage values
- Stamina costs
- Regeneration rates
- Animation durations
- Combat ranges
- Cooldown timers

## Notes

- All players must be in combat stance to perform combat actions
- Blocking prevents stamina regeneration
- Critical attacks break through blocks but can be parried
- Dodge has 200ms of invincibility frames starting 100ms after activation
- Running requires minimum 10 stamina to start
### Debug Commands
- `/debug_mode` - Toggle hitbox visualization and combat info
- `/spawn_dummies` - Spawn blocking/parrying/idle dummies
- `/clear_dummies` - Remove test dummies

