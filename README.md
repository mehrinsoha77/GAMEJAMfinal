# Degrees of Freedom: Lost on the Odyssey

Godot 4.3+ project. **Level 1 only, built and playable right now.**
Levels 2-5 are intentionally not started — build them once Level 1's
pattern is validated, reusing the same shared systems.

## What's actually in this repo

- `scripts/autoload/` — the four shared systems every level depends on:
  - `EventBus.gd` — global signals (`puzzle_completed`, `dof_unlocked`, `level_completed`)
  - `DOFManager.gd` — single source of truth for which movement axes are unlocked
  - `AudioManager.gd` — `play_sfx("name")` / `play_music("name")`, safe no-op if the file isn't there yet
  - `UIManager.gd` — `show_banner("text")` for DOF-unlock / level-complete / prompt text
- `scripts/player/PlayerController.gd` — reusable for all 5 levels; it never
  hardcodes level logic, it only reads `DOFManager` flags per axis.
- `scripts/objects/Door.gd`, `scripts/objects/Terminal.gd` — reusable interactables.
  A Terminal just needs a `puzzle_scene` that emits a `puzzle_solved` signal — that's
  the entire contract, so Level 2's color-connect puzzle, Level 3's sliding
  puzzle, etc. plug into the exact same Terminal without touching this code.
- `scripts/levels/Level1Corridor.gd` + `scripts/puzzles/TriviaPuzzle.gd` — Level 1's
  actual content (the BRS question, and wiring "trivia solved" → unlock backward → open door).
- `scenes/` — matching `.tscn` files. Geometry is blockout (plain boxes/capsule),
  no art yet, by design.

## Current Level 1 flow
Spawn → walk forward (only DOF unlocked at start) → reach terminal → answer BRS
trivia → **Backward unlocked** + door opens → walk through exit trigger → "LEVEL 1
COMPLETE".

## Controls
| Action | Key | Gated by |
|---|---|---|
| Move forward | W | always on |
| Move backward | S | unlocked by solving the trivia |
| Turn left/right | A / D | locked until Level 2 (not reachable in this build) |
| Strafe left/right | Q / E | locked until Level 3 |
| Jump | Space | locked until Level 4 |
| Interact | F | always on |

## Where to drop your uploaded assets
Nothing currently references a missing file in a way that will crash the
project — `AudioManager` checks `ResourceLoader.exists()` before loading, so
you can playtest today with silence and swap assets in incrementally.

- 3D models → `assets/models/` (e.g. `player.glb`, `terminal.glb`). To actually
  use one, open the relevant `.tscn` in the Godot editor and swap the
  placeholder `MeshInstance3D`'s mesh for your imported model — this needs the
  Godot editor GUI, it's not something to do by hand-editing the `.tscn` text.
- Audio → `assets/audio/sfx/` and `assets/audio/music/` using **exactly** these
  names (extension can be `.ogg`, `.wav`, or `.mp3`): `dof_unlock`,
  `door_unlock`, `access_denied`, `ui_panel_open`, `puzzle_wrong`,
  `level_complete`, `level1_theme`. Matching filenames start playing
  automatically, no code changes.

## Running it
Open the folder in Godot **4.3 or later** (`project.godot` is at the repo
root) and press Play — `Level1_Corridor.tscn` is already set as the main scene.

## Pushing to GitHub
This folder is already a local git repo with an initial commit (see below).
To push it to a new GitHub repo:

```bash
# on github.com, create a new EMPTY repo (no README/license/gitignore), then:
cd degrees-of-freedom-odyssey
git remote add origin https://github.com/<your-username>/<repo-name>.git
git branch -M main
git push -u origin main
```
