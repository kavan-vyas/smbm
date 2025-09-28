# Sacrifices Must Be Made - Requirements & Assets

## Required Assets

### Visual Assets
- **Player sprite**: Simple colored square/circle (32x32px)
- **Wall tiles**: Dark gray/black rectangles for maze walls
- **Door sprite**: Vertical rectangle, different color from walls (e.g., brown/red)
- **Gate trigger**: Invisible or subtle outline to show interaction area
- **Exit sprite**: Bright colored square/door (e.g., golden/green)
- **Heart icon**: Red heart symbol for health display (32x32px)
- **Background**: Dark texture or solid color for atmosphere

### Audio Assets
- **Door open sound**: Short mechanical/magical sound effect
- **Sacrifice sound**: Brief impact/loss sound for feedback
- **Ambient background**: Optional dark atmospheric loop
- **UI sounds**: Button click, modal open/close sounds

### Shader Assets
- **Vision overlay shader**: Circular mask shader for darkness/light radius effect
- **Flash effect**: Red screen flash for damage feedback

## Scene Structure Required

### Main Scenes
1. **Game.tscn** - Main game scene containing all components
2. **Player.tscn** - Player character with movement and collision
3. **Gate.tscn** - Gate trigger with door reference
4. **Door.tscn** - Door with collision and animation
5. **Exit.tscn** - Exit trigger area
6. **VisionOverlay.tscn** - Darkness overlay with circular cutout

### UI Scenes
1. **UIHud.tscn** - Main HUD with hearts, sacrifices, timer
2. **GateModal.tscn** - Modal dialog for sacrifice choices
3. **WinScreen.tscn** - Victory screen with time and restart
4. **LoseScreen.tscn** - Game over screen with restart

## Level Design Requirements

### Map Layout
- **Size**: 7x7 grid or equivalent small maze
- **Rooms**: 5-8 connected rooms/areas
- **Gates**: 3-5 gates strategically placed
- **Paths**: Multiple routes with different sacrifice requirements
- **Start**: Clear starting position
- **Exit**: Single exit point

### Gate Placement Strategy
1. **Early gates**: Mix of health vs. movement direction
2. **Mid gates**: Speed vs. vision sacrifices
3. **Late gates**: Critical path decisions
4. **Ensure solvability**: At least 2 different winning paths

## Technical Requirements

### Core Systems
- [x] Player movement with directional restrictions
- [x] Health system (3 hearts)
- [x] Speed modification system
- [x] Vision radius system
- [ ] Vision overlay rendering
- [x] Gate interaction system
- [x] Door opening/closing
- [x] UI HUD with all indicators
- [x] Game state management
- [x] Timer system (120 seconds)
- [x] Win/lose conditions
- [x] Reset/restart functionality

### Sacrifice Types Implemented
- [x] Health: -1 heart
- [x] Speed: -20% movement speed (stacking)
- [x] Vision: -25% vision radius (stacking)
- [x] Movement directions: Disable left/right/up/down
- [x] Timer: -10 seconds from countdown

### Stretch Features (Optional)
- [ ] Purge collectible (negate one sacrifice)
- [ ] Push-only enemy patrol
- [ ] Screen shake and post-processing effects
- [ ] Additional sound effects and polish
- [ ] Multiple levels or level variations

## File Structure

```
/assets/
  /sprites/
    - player.png
    - wall.png
    - door.png
    - exit.png
    - heart.png
  /audio/
    - door_open.ogg
    - sacrifice.ogg
    - ambient.ogg
  /shaders/
    - vision_overlay.gdshader

/scenes/
  - Game.tscn
  - Player.tscn
  - Gate.tscn
  - Door.tscn
  - Exit.tscn
  - VisionOverlay.tscn
  - UIHud.tscn

/scripts/
  - Player.gd ✓
  - GameManager.gd ✓
  - Gate.gd ✓
  - Door.gd ✓
  - Exit.gd ✓
  - UIHud.gd ✓
  - VisionOverlay.gd (needed)

/ui/
  - GateModal.tscn (needed)
  - WinScreen.tscn (needed)
  - LoseScreen.tscn (needed)
```

## Immediate Next Steps

1. **Create missing scenes and assets**
2. **Implement VisionOverlay system with shader**
3. **Build the main Game.tscn scene**
4. **Create level layout with TileMap**
5. **Add basic sprites and visual feedback**
6. **Test core gameplay loop**
7. **Balance sacrifice severity and paths**
8. **Add audio and polish effects**

## Testing Checklist

- [ ] Player can move in all directions initially
- [ ] Gates present sacrifice choices correctly
- [ ] Doors open after sacrifice selection
- [ ] Health decreases and updates UI
- [ ] Movement restrictions work properly
- [ ] Speed reduction is noticeable
- [ ] Vision radius decreases with overlay
- [ ] Timer counts down and triggers loss
- [ ] Exit triggers win condition
- [ ] Reset button restarts everything
- [ ] Multiple winning paths exist
- [ ] No soft-lock scenarios possible

## Performance Targets

- **Target FPS**: 60 FPS
- **Load time**: < 3 seconds
- **Memory usage**: < 100MB
- **Build size**: < 50MB
- **Platform**: Desktop and Web (HTML5)