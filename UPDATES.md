# Combat System Updates Log

## Version 1.0 - Enhanced Combat System
*Date: January 2025*

### Major Features Added:

#### 1. **M1 Combat Enhancements**
- ✅ Integrated new M1 animations (4-hit combo chain)
- ✅ Added movement slowdown during M1 attacks to prevent movement abuse
- ✅ Implemented hitstun to prevent M1 trading
- ✅ Added endlag after 4th hit with cooldown before next combo
- ✅ Players can now parry during enemy combo chains

#### 2. **Directional Dash System**
- ✅ Implemented 4-directional dashing (forward, backward, left, right)
- ✅ Each direction has unique animations
- ✅ Dash cooldown: 1.5 seconds
- ✅ Dash distance: 10 studs
- ✅ Dash duration: 0.3 seconds

#### 3. **Debug Mode Features**
- ✅ Added `/debug_mode` command (admin only)
- ✅ Visual hitbox display for all players
- ✅ M1 attack hitbox visualization
- ✅ Block/parry state indicators
- ✅ Real-time combat state display

#### 4. **Test Dummy System**
- ✅ `/spawn_dummies` command to create test dummies
- ✅ Dummies with different states: idle, blocking, parrying
- ✅ `/clear_dummies` to remove all test dummies

#### 5. **Stamina System Fixes**
- ✅ Fixed stamina drain rates for all actions
- ✅ Proper stamina regeneration when not in combat
- ✅ Stamina now properly prevents actions when depleted

### Technical Improvements:

#### Animation IDs:
```lua
M1 Animations:
- Hit 1: rbxassetid://112627375965381
- Hit 2: rbxassetid://107219571959162
- Hit 3: rbxassetid://71244140880155
- Hit 4: rbxassetid://119494483714064

Dash Animations:
- Forward: rbxassetid://72951822742730
- Backward: rbxassetid://1284642812
- Left: rbxassetid://1201718473
- Right: rbxassetid://871699376

Hitstun Animation: rbxassetid://928454497
```

### Balance Changes:
- M1 Damage: 10 per hit (40 total for full combo)
- M1 Duration: 0.5 seconds per hit
- 4th hit endlag: 1 second
- Movement speed during M1: 50% reduction
- Hitstun duration: 0.3 seconds
- Dash stamina cost: 20

### Bug Fixes:
- Fixed players being able to M1 while moving at full speed
- Fixed M1 trading where both players could hit each other simultaneously
- Fixed stamina not regenerating properly
- Fixed parry window not working during enemy combos

### Known Issues:
- Animation transitions may occasionally appear choppy
- Dash can sometimes clip through thin walls (working on validation)

### Future Plans:
- Add heavy attacks with different properties
- Implement combo variations
- Add more defensive options
- Create ranked combat mode

---

## How to Update Your Game:

1. Run the new `EnhancedTerminalSetup.lua` in the command bar
2. Copy all updated module scripts to their folders
3. Test with `/debug_mode` enabled
4. Spawn test dummies with `/spawn_dummies`

## Admin Commands:
- `/debug_mode` - Toggle debug visualization
- `/spawn_dummies` - Spawn test dummies
- `/clear_dummies` - Remove all test dummies
- `/reset_combat` - Reset all combat states
- `/set_damage [number]` - Change M1 damage
- `/god_mode` - Enable invincibility for testing

---

## Version 2.0 - Ultimate Combat System
*Date: March 2025*

### Major Enhancements:

#### 1. **Enhanced M1 Combat Mechanics**
- ✅ Implemented proper momentum loss during attacks (stops player movement)
- ✅ Enhanced movement slowdown to 30% speed during M1 attacks
- ✅ Variable endlag per hit (0.2s, 0.2s, 0.3s, 0.8s for hits 1-4)
- ✅ Added combo cooldown after 4th hit (0.5s before next combo)
- ✅ Proper hitstun duration (0.4s) prevents M1 trading

#### 2. **Improved Blocking & Parry System**
- ✅ Parry window: 300ms (skill-based timing)
- ✅ Successful parry stuns attacker for 1.0s
- ✅ Block damage reduction: 80%
- ✅ Guard break system when stamina < 30
- ✅ Can parry during enemy combo chains (interrupt combos)
- ✅ Posture system integration with guard breaks

#### 3. **Enhanced Stamina System**
- ✅ Proper stamina costs: M1 (5), Dash (20), Block drain (5/s)
- ✅ Stamina regen: 15/second with 1s delay after action
- ✅ Sprint stamina drain: 10/second
- ✅ No stamina regen while blocking

#### 4. **Advanced Debug Mode**
- ✅ Toggle with `/debug_mode` command
- ✅ Visualizes all player hitboxes in green
- ✅ Shows M1 attack hitboxes in red
- ✅ Block state indicators in blue
- ✅ Real-time combat info display
- ✅ Damage number visualization
- ✅ Stamina bar overlays

#### 5. **Improved Test Dummy System**
- ✅ 5 dummy behaviors: Idle, Blocking, Parrying, Attacking, Dodging
- ✅ Visual indicators for dummy states
- ✅ Weighted behavior selection for realistic combat
- ✅ Proper spawn positions for testing

#### 6. **Directional Dash Improvements**
- ✅ All 4 directions fully functional with unique animations
- ✅ I-frames option (0.15s invincibility during dash)
- ✅ Proper dash velocity calculations
- ✅ Cannot dash while stunned or already dashing

### Technical Improvements:

#### New Configuration Structure:
```lua
CombatSettings = {
    M1 = {
        MovementSlowdown = 0.3,
        MomentumLoss = true,
        HitstunDuration = 0.4,
        ComboCooldown = 0.5,
        Endlag = {0.2, 0.2, 0.3, 0.8}
    },
    Block = {
        ParryWindow = 0.3,
        ParryStunDuration = 1.0,
        DamageReduction = 0.8,
        BlockBreakThreshold = 30,
        CanParryDuringCombo = true
    },
    Stamina = {
        Max = 100,
        RegenRate = 15,
        RegenDelay = 1.0,
        M1Cost = 5,
        SprintDrain = 10,
        BlockDrain = 5
    }
}
```

### New Features:

1. **Posture System**
   - Max posture: 100
   - M1 posture damage: 15
   - Block posture damage: 5
   - Posture break stun: 2.0s
   - Posture regen: 20/second

2. **Ragdoll System**
   - Triggers on 4th M1 hit
   - Triggers on posture break
   - Duration: 2 seconds
   - Smooth recovery animation

3. **Server-Authoritative Combat**
   - All combat validated server-side
   - Anti-exploit measures
   - Lag compensation
   - Hit validation

### Installation:

1. Run `UltimateCombatSetup.lua` in command bar
2. System auto-creates all necessary components
3. No manual file copying required
4. Automatic UI generation

### Commands:
- `/debug_mode` - Toggle debug visualization
- `/spawn_dummies` - Create test dummies
- `/clear_dummies` - Remove dummies

### Balance Notes:
- Combat is now more tactical with proper punish windows
- Stamina management is crucial
- Parrying rewards skilled timing
- Movement control prevents spam

---

*For questions or bug reports, contact the development team.*