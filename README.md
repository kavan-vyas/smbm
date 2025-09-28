# Sacrifices must be made...

A tiny, decision-driven puzzle-exploration game you can build in ~5 hours.

## Elevator pitch
Navigate a small maze where every locked gate demands a sacrifice. To pass, you must permanently give up something: a bit of health, speed, vision, or even a movement direction. Reach the exit before your choices trap you.

## Scope and constraints
- Single short level (5–8 rooms or a small grid).
- 3–5 gates total, each requiring one of two sacrifices.
- Minimal art: simple colored shapes, text, and a dark overlay for vision.
- No save system; restart on fail. Timer optional.

## Core loop
- Explore → encounter a gate → choose 1 of 2 sacrifices → path opens → repeat → reach exit or get stuck.
- Losing conditions: HP ≤ 0, timer expires (if using timer), or you soft-lock by sacrificing a critical control and can’t reach the exit.

## Sacrifice types (pick 3–4 to keep scope tight)
- Health: lose 1 heart (start with 3).
- Vision: reduce light radius by 20–30% (darkness outside a circle).
- Speed: reduce movement speed by 20% (stacking).
- Movement direction: permanently disable one direction (e.g., no left).
- Optional (stretch): -10s from a countdown timer.

Tip: Movement-direction sacrifice makes interesting spatial puzzles; pair it with at least one non-direction sacrifice for variety.

## Gates
- Each gate presents 2 choices, e.g.:
  - “Sacrifice: -1 Heart” OR “Sacrifice: Disable Left”
  - “Sacrifice: -20% Vision” OR “Sacrifice: -20% Speed”
- After choice, door opens permanently.

## Win/Lose
- Win: reach exit tile/door.
- Lose: die (0 HP), time out (if timer enabled), or press Reset if trapped.

## Minimal content
- Small map (e.g., 7x7 tiles or 3x3 rooms).
- 3–5 gates spaced so that each choice meaningfully affects future traversal.
- 1 exit, 1 start, optional pickups (1 extra heart as forgiveness).

## UI
- Top-left: Hearts (❤❤❤).
- Top-right: Icons for active sacrifices (e.g., “L✖” for Left disabled, “SPD-20%”, “VIS-20%”).
- Center-top (optional): countdown timer.
- Interact prompt at gates: “Choose a sacrifice: [Option A] [Option B]”.

## Juice (quick feedback)
- Door opens with a short sound and scale “pop”.
- Screen vignette tightens for vision loss.
- Brief red blink for HP loss; slight slow-mo for dramatic effect (0.3s).

## Level design tips
- Ensure at least one valid path: simulate a “safe” set of choices while building.
- Use forced detours for direction sacrifices (e.g., needing Right later).
- Place vision-reduction gates before a small maze to make it meaningful.

## Implementation notes (engine-agnostic)
- Player state:
  - hp = 3
  - speed = 200 (pixels/s), speedMultiplier = 1.0
  - canMove = { left: true, right: true, up: true, down: true }
  - visionRadius = 200 (pixels)
- Sacrifice application:
  - Health: hp -= 1
  - Speed: speedMultiplier *= 0.8
  - Vision: visionRadius *= 0.75
  - Direction: canMove.left = false (example)
- Vision effect: draw a dark full-screen rectangle with a circular hole around player (mask or shader).
- Gate: trigger area + simple UI panel with two buttons; applying a choice sets door.open = true and disables gate UI thereafter.

## Quick engine choices
- Godot 4: simplest 2D pipeline, Light2D or canvas shader for vision, Input booleans for direction locks.
- Phaser 3 or HTML5/Canvas: easy web deploy, use a graphics mask for vision, booleans for movement.
- Unity 2D URP: use SpriteMask or shader for vision; more setup overhead.

Pick one you’re fastest in.

## 5-hour build plan
1) Project setup (30m)
- Create project, basic scene, player with movement and collision.
- Tilemap or simple rectangles for walls.

2) Gate + UI prototype (60–75m)
- Create a gate object that pauses player input and shows two buttons.
- Implement applySacrifice() and door opening.
- Add simple SFX placeholders (optional).

3) Vision + UI indicators (45m)
- Implement visionRadius overlay.
- Display hearts and active sacrifice icons.

4) Level build (45–60m)
- Lay out 1 small level with 3–5 gates.
- Place start and exit. Test for solvable path.

5) Polish and fail states (30–45m)
- Lose when hp ≤ 0; add Reset button.
- Add minimal feedback: flashes, door animation, screen vignette.

6) Playtest and tune (15–30m)
- Ensure at least two different sacrifice paths lead to success.
- Adjust sacrifice severity so choices are meaningful but not unwinnable.

## Stretch goals (only if ahead of schedule)
- Add a single collectible that negates one sacrifice.
- Add a very simple enemy that pushes you (no damage).
- Timer mode with scoreboard.
- Post-processing vignette and screen shake.

## Content you can cut first if behind
- Timer and related UI.
- Any enemy or collectible.
- Reduce gates from 5 to 3.

## Example gate option sets
- Gate A: -1 Heart OR Disable Left
- Gate B: -20% Speed OR -20% Vision
- Gate C: -1 Heart OR Disable Down
- Gate D (optional): -10s Timer OR -20% Vision
- Gate E (optional): -20% Speed OR Disable Right

## Naming and theming
- Light narrative wrapper: you’re carrying a fragile flame; every door takes a toll.
- Gate text: “The door demands a price. What will you give?”

You now have a tight, finishable concept with clear mechanics, a manageable level, and a 5-hour plan. If you tell me your engine, I’ll hand you a small starter snippet for movement, gates, and the vision overlay.

---

# Full step-by-step build guide (max scope)

This guide expands the plan into a complete, end-to-end implementation that includes all baseline features plus stretch items listed above (collectible to negate one sacrifice, simple push-only enemy, optional timer + scoreboard, and basic juice). Follow the numbered steps; each step has engine-agnostic instructions plus per-engine notes.

Notes
- Keep everything in one short level to stay scoped.
- Treat “sacrifices” as permanent modifiers in a single run. No saves.

## 0) Prerequisites
- Pick an engine you can ship quickly:
  - Godot 4.2+: 2D, Light2D/shader masks, export to desktop/web.
  - Phaser 3 (with Vite): web-first, canvas/WebGL, easy masks.
  - Unity 2022 LTS 2D URP: SpriteMask/URP 2D lights; more setup.
- Prepare basic assets: simple square for player, door rectangle, wall tiles, a heart icon, 2–3 simple SFX.

## 1) Create project
- Create a new 2D project.
- Set resolution to something like 1280x720.
- Turn on pixel snap if using pixel art.
- Create a scene/hierarchy with:
  - Root: Game
  - Children: Level (tilemap or walls), Player, Camera, UI (Canvas), Systems (GameManager), Audio.

Per-engine notes
- Godot: Scene Game.tscn with Node2D root. Add TileMap, Kinematic/CharacterBody2D Player, Camera2D, CanvasLayer UI.
- Phaser: Boot a single Scene; add Matter/Arcade physics. Use a Container for UI overlay.
- Unity: Create Scene Main. Add Grid/Tilemap, Player (Rigidbody2D + Collider2D), Cinemachine camera if desired, Canvas for UI.

## 2) Project structure
- folders: assets/, scenes/, scripts/, ui/, audio/.
- Naming: Player, Gate, Door, Exit, Collectible, Enemy, GameManager, UIHud.

## 3) Player controller + state
Goal: Movement with modifiable speed, directional locks, and HP.

Implementation
1. Player state variables:
   - hp = 3
   - baseSpeed = 200; speedMul = 1.0
   - canMove = { left: true, right: true, up: true, down: true }
   - visionRadius = 200
2. Read input and compute intent (x, y). Zero components if that direction is disabled.
3. Multiply by baseSpeed * speedMul. Move with physics.
4. Add a method applySacrifice(type) that mutates state:
   - health: hp -= 1
   - speed: speedMul *= 0.8
   - vision: visionRadius *= 0.75
   - dir_left/right/up/down: set respective canMove flag to false
   - timer: GameManager.timeRemaining -= 10
5. Expose a resetToDefaults() for restarts.

Per-engine notes
- Godot: CharacterBody2D with velocity. Use Input.get_vector; before applying, gate axes based on canMove.
- Phaser: Arcade body.setVelocity with normalized vector; gate components via canMove.
- Unity: Read input axes, build Vector2, zero components if disabled; Rigidbody2D.MovePosition in FixedUpdate.

## 4) Level collision + layout
Goal: One short map with clear rooms and corridors.

Implementation
1. Choose either Tilemap (recommended) or static rectangles.
2. Build 5–8 rooms or a 7x7 grid chunk. Place Start and Exit.
3. Place 3–5 Gates positioned so choices matter later.
4. Add colliders to walls and doors. Doors start closed (colliding/solid).

Per-engine notes
- Godot: TileMap with collision layer; Doors as StaticBody2D.
- Phaser: Static physics groups or tilemap collision layer.
- Unity: Grid/TilemapCollider2D; composite collider for performance.

## 5) Camera + vision system
Goal: Darkness everywhere except a circular area around the player; adjustable radius.

Implementation
1. Add a full-screen dark overlay.
2. Cut a circular hole centered on the player whose radius = player.visionRadius.
3. Animate radius changes on sacrifice (brief tween/lerp) for feedback.

Per-engine notes
- Godot: CanvasLayer with a ColorRect; use a shader that draws a masked circle around player position; pass radius via uniform.
- Phaser: Draw a black Graphics rectangle, then beginPath/arc to punch a hole; set as a mask or use destination-out blend.
- Unity URP: Use a full-screen UI Image with a custom shader for a circular cutout, or a SpriteMask with a black overlay sprite.

## 6) UI HUD
Goal: Display HP hearts, active sacrifices, and optional timer.

Implementation
1. Hearts: draw N filled hearts based on hp.
2. Active sacrifices: small text/icon badges like L✖, R✖, U✖, D✖, SPD-20%, VIS-20%.
3. Timer (optional): top-center countdown; hidden if not used.
4. Reset prompt on death or soft-lock.

Per-engine notes
- Godot: Control/CanvasLayer; Hearts via TextureRects or draw strings; use HBoxContainer for layout.
- Phaser: Add BitmapText/images fixedToCamera.
- Unity: Canvas/HorizontalLayoutGroup for hearts; TextMeshPro for labels.

## 7) Gate + Door system
Goal: Gate presents two sacrifice options. After a choice, open the door permanently.

Implementation
1. Create a Gate prefab with:
   - Trigger area (no collision with player movement).
   - Reference to a Door object (collider + visual).
   - Data: optionA, optionB (enum or string id).
2. On player enter, pause movement and show a modal UI with two buttons labeled by the two options.
3. On selection:
   - Call player.applySacrifice(optionX).
   - Open door: disable collider, play SFX, play animation.
   - Disable the gate trigger and close the modal forever.

Per-engine notes
- Godot: Area2D for gate trigger; Door as StaticBody2D with CollisionShape2D toggled off; modal via Control node.
- Phaser: Overlap callback; open door by disabling body/setting visible=false.
- Unity: Trigger Collider2D; door collider.enabled=false; modal via Canvas + EventSystem.

## 8) GameManager (state + reset)
Goal: Centralize run state and restarts.

Implementation
1. Store references to player, gates, doors, UI.
2. Optional countdown timer: timeRemaining starts at e.g. 120s; tick down each frame; lose if <= 0.
3. Provide restartRun(): resets player state, closes all doors, re-enables gates, resets timer.
4. Provide win(): show win screen; lose(): show lose screen.

Per-engine notes
- Godot: Autoload a GameManager singleton.
- Phaser: Keep on scene; restart by scene.restart with seed/state.
- Unity: GameObject with DontDestroyOnLoad if multi-scene; otherwise in-scene manager.

## 9) Feedback/Juice
Goal: Immediate, legible responses to actions.

Implementation
1. HP loss: screen red flash and short hit SFX.
2. Vision loss: vignette tighten + whoosh.
3. Door open: scale pop on door sprite + clunk SFX.
4. Short 0.25–0.3s timescale slowdown on sacrifice, then recover.

Per-engine notes
- Godot/Unity: Tween scale/timeScale; overlay flash via UI. Phaser: scene.time.timeScale or tween-based fake slow-mo.

## 10) Level design and solvability
Goal: Ensure at least two valid sacrifice paths to the exit.

Implementation
1. Plan 3–5 gates. Mix direction sacrifices with one or two non-direction ones.
2. Simulate paths:
   - Path A: keep critical direction until late.
   - Path B: trade HP to preserve movement options.
3. Place one optional heart pickup as forgiveness.
4. Playtest for 10 minutes and adjust severity (e.g., speed penalty 0.85 if 0.8 is too harsh).

## 11) Stretch features
Implement only after the core loop works.

A) Purge collectible (negate one sacrifice)
1. Add a pickup that grants purgeToken += 1.
2. When a gate opens, if purgeToken > 0, offer a third choice: “Negate one existing sacrifice”.
3. Implement negate logic:
   - If direction disabled, re-enable the chosen direction.
   - If speed reduced, divide by 0.8 once.
   - If vision reduced, divide by 0.75 once.
   - If HP lost, grant +1 hp (cap at start hp).
4. Consume purgeToken.

B) Simple enemy (push-only)
1. Add an Enemy that patrols between two points.
2. On contact, apply a short impulse to the player but no damage.
3. Ensure it can’t soft-lock the player in walls.

C) Timer mode + scoreboard
1. Enable countdown timer by default (e.g., 120s). Lose at 0.
2. Track completion time or remaining time.
3. Save best time:
   - Godot: FileAccess or ConfigFile; Unity: PlayerPrefs; Phaser: localStorage.
4. Show best score on win screen.

## 12) Win/Lose flow
- Win: touching Exit triggers win screen; stop input; offer Restart.
- Lose: hp <= 0 or timer <= 0 triggers lose screen; offer Restart.
- Provide a Pause/Reset button in UI at all times.

## 13) Balancing checklist
- HP starts at 3; at most two mandatory HP sacrifices.
- Direction locks should force reroutes but not make the exit unreachable in all cases.
- Speed and vision penalties should remain playable after 2–3 stacks.
- Timer generous enough to allow one or two detours.

## 14) Shipping
- Godot: Project > Export (HTML5/Desktop). Test WebGL performance with the vision shader.
- Phaser: Build with Vite/Parcel, deploy to static hosting (GitHub Pages, itch.io).
- Unity: Build for WebGL or desktop. For WebGL, keep assets minimal for load time.

## 15) Test pass (10 minutes)
- Start-to-finish run with two different sacrifice paths both winning.
- Intentionally soft-lock by removing a direction—verify Reset works.
- Take HP to 0—verify lose state.
- If timer enabled, verify timeout lose.
- Collect purge token—use it—verify reversal.
- Doors remain open after choice; gates don’t re-prompt.

With this guide you can build the full feature set described above in a small, controlled scope and ship it in a day. Keep the art minimal and focus on clarity of feedback and meaningful choices.