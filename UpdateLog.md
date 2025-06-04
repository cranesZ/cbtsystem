# Combat System Update Log

## Session Started: 6/3/2025

### Initial Analysis
- Examined all combat setup scripts
- Identified FixedCompleteSetup.lua as base (has placeholder animation IDs)
- UltimateCombatSetup.lua has most complete v2.0 features
- Need to merge best features from all versions

### Features to Implement
1. **M1 Combat System**
   - 4-hit combo with proper animations from CombatSettings
   - Movement slowdown (70%) and momentum loss during attacks
   - Variable endlag: 0.2s, 0.2s, 0.3s, 0.8s for hits 1-4
   - Hitstun (0.4s) to prevent M1 trading
   - Combo cooldown after 4th hit

2. **Directional Dash System**
   - All 4 directions with unique animations
   - 1.5s cooldown, configurable distance
   - Optional i-frames during dash

3. **Block/Parry System**
   - Parry window: 300ms
   - Can parry through combo chains
   - Guard break at low stamina

4. **Stamina System**
   - M1 cost: 5, Dash: 20, Block drain: 5/s
   - 15/s regen with 1s delay
   - Sprint drain: 10/s

5. **Debug Mode**
   - Toggle with /debug_mode command
   - Show hitboxes, block states, combat info

6. **Test Dummies**
   - Spawn with /spawn_dummies
   - Various behaviors (idle, blocking, parrying, attacking)

### Animation IDs from CombatSettings
- M1 Animations:
  - [1] = "rbxassetid://112627375965381"
  - [2] = "rbxassetid://107219571959162"
  - [3] = "rbxassetid://71244140880155"
  - [4] = "rbxassetid://119494483714064"
- Dash Animations:
  - Forward: "rbxassetid://72951822742730"
  - Backward: "rbxassetid://1284642812"
  - Left: "rbxassetid://1201718473"
  - Right: "rbxassetid://871699376"
- Hitstun: "rbxassetid://928454497"

### Implementation Progress
- [ ] Create new FixedCompleteSetup with all features
- [ ] Add proper animation IDs
- [ ] Implement M1 slowdown and momentum mechanics
- [ ] Add directional dashing
- [ ] Implement debug mode
- [ ] Add test dummy system
- [ ] Fix stamina drain rates
- [ ] Add parry through combos