# Sacrifices Must Be Made - Gameplay Guide

## Overview
Navigate a small maze where every locked gate demands a sacrifice. To pass, you must permanently give up something: health, speed, vision, or movement direction. Reach the exit before your choices trap you.

## Controls
- **WASD** or **Arrow Keys**: Move player
- **R**: Reset/Restart game
- **Mouse**: Click UI buttons in gate modals

## Game Mechanics

### Player Stats
- **Health**: Start with 3 hearts ❤❤❤
- **Speed**: Base movement speed (can be reduced)
- **Vision**: Light radius around player (can be reduced)
- **Movement**: All directions available initially (can be disabled)

### Sacrifice Types
1. **Health (-1 Heart)**: Lose one heart. Game over at 0 hearts.
2. **Speed (-20%)**: Reduce movement speed by 20% (stacking).
3. **Vision (-25%)**: Reduce light radius by 25% (stacking).
4. **Direction Lock**: Permanently disable one movement direction.
5. **Timer (-10s)**: Reduce countdown timer by 10 seconds.

### Gates & Doors
- Each gate presents 2 sacrifice choices
- Choose one to open the associated door
- Doors remain open permanently after sacrifice
- Gates become inactive after use

### Win/Lose Conditions
**Win**: Reach the golden exit tile
**Lose**: 
- Health reaches 0
- Timer reaches 0
- Soft-lock (can't reach exit due to movement restrictions)

### UI Elements
- **Top-Left**: Hearts display and Reset button
- **Top-Right**: Active sacrifice indicators (L✖, SPD-20%, etc.)
- **Top-Center**: Countdown timer
- **Modal**: Gate sacrifice choice dialog

## Strategy Tips

### Path Planning
- Plan your route before making sacrifices
- Consider which directions you'll need later
- Health sacrifices are often safer than movement restrictions

### Sacrifice Priority
1. **Safest**: Health (if you have multiple hearts)
2. **Moderate**: Speed and Vision (manageable with multiple stacks)
3. **Risky**: Movement directions (can create soft-locks)
4. **Emergency**: Timer reduction (reduces pressure)

### Multiple Winning Paths
The level is designed with at least 2 different sacrifice combinations that lead to victory:
- **Path A**: Preserve movement, sacrifice health/speed/vision
- **Path B**: Sacrifice some movement directions, preserve health

## Stretch Features

### Purge Tokens (Purple Collectibles)
- Collect to gain ability to reverse one sacrifice
- Use at gates for a third option: "Negate existing sacrifice"
- Limited quantity - use wisely

### Enemies (Red Patrolling Objects)
- Push player on contact (no damage)
- Patrol between fixed points
- Can complicate navigation but won't kill you

### Timer & Scoring
- 120-second countdown timer
- Completion time tracked
- Best time saved locally
- Displayed on victory screen

## Level Layout
```
Start → Gate1 → Gate2 → Gate3 → Exit
  ↓       ↓       ↓       ↓
Door1   Door2   Door3   Victory!
```

### Gate Configurations
- **Gate 1**: Health vs. Disable Left
- **Gate 2**: Speed vs. Vision  
- **Gate 3**: Health vs. Disable Right

## Audio Feedback
- Door opening: Mechanical sound
- Sacrifice: Impact/loss sound
- Collection: Pickup chime
- UI: Button clicks

## Visual Feedback
- **Health Loss**: Red screen flash + slowmo
- **Vision Loss**: Darkness overlay tightens
- **Door Opening**: Scale animation + transparency
- **Sacrifice**: Brief time slowdown effect

## Development Notes
- Built in Godot 4.2+
- Minimal art style using colored shapes
- Shader-based vision system
- Modular sacrifice system
- Expandable gate/door system

## Troubleshooting
- **Can't move**: Check if movement direction was sacrificed
- **Can't see**: Vision radius reduced - move carefully
- **Stuck**: Use Reset button (R key) to restart
- **No sound**: Audio files not included (placeholder system)

## Expansion Ideas
- Multiple levels with different layouts
- New sacrifice types (jump height, interaction range)
- Puzzle elements requiring specific sacrifices
- Narrative elements and story progression
- Multiplayer cooperative mode

Enjoy the strategic challenge of "Sacrifices Must Be Made"!