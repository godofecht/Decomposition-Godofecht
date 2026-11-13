# Decomposition-Godofecht

A top-down 2D dungeon shooter, built for the UoP game jam.

## What this is

Decomposition (a temporary name) is a game made in four days for the UOP Game Jam in 2020. You play a small creature in a dungeon full of bacteria and turrets. You fire bullets at enemies, but you start with only a few. To get more, you hold a suction ray that pulls in the green pieces enemies break into when they die. Clear all the enemies in a room and its door opens. There are three levels, and the last one ends with a boss called Cereus. It was made with Godot, a free game engine.

## What you can learn from it

Computer Science and game design:

- How a game engine organises a game into scenes (levels, menus, characters) and scripts attached to them.
- A game loop: code that runs every frame to read input, move things and check for collisions.
- Simple physics: acceleration, friction and a maximum speed for the player.
- Collision layers, which decide what can hit what (player, walls, bacteria, bullets).
- Global state that survives a change of level, such as health and ammo.
- A resource loop as a game mechanic: ammo is scarce, and you earn it back from what you destroy.

## Run it

### On your own computer

**You will need:**

- [Godot 3](https://godotengine.org/download/3.x/), the standard version. The project uses the Godot 3 file format, so Godot 4 will try to convert it and may break it.
- [Git](https://git-scm.com/downloads), to download the code. You can also use **Code**, then **Download ZIP**, on the GitHub page.

The game has not been tested for this guide on a particular operating system or Godot 3 version.

1. Download the code:

   ```sh
   git clone https://github.com/godofecht/Decomposition-Godofecht.git
   ```

2. Open Godot. In the Project Manager, choose **Import**, then pick the `project.godot` file inside the `Decomposition-Godofecht` folder.

3. Press F5, or the play button in the top right, to run the game. It opens full screen on the title screen.

### Controls

| Input | Does |
| --- | --- |
| W, A, S, D or arrow keys | move |
| Mouse | aim |
| Left mouse button | shoot (uses one bullet) |
| Right mouse button, held | suction ray: pulls in green pieces for ammo, and crystals |
| Space | dash |

The menus have no buttons to click. You walk your character into a zone. On the difficulty screen, walk into **Easy** (100 health, 10 bullets), **Hard** (25 health, 3 bullets) or **Insane** (5 health, 1 bullet). If you die, walk into **Continue?** to restart the level, or **Give Up** to quit the game.

The game starts full screen. Press Alt+F4 on Windows or Cmd+Q on macOS to close it.

## How it works

Each level is a Godot scene. The player is a `KinematicBody2D` (a body that the code moves directly) and the enemies and bullets are `RigidBody2D` (bodies that the physics engine moves). When a bacterium runs out of health, it plays a death animation, then drops a crystal and two green bullets. Your suction ray is an area that turns on while you hold the right mouse button. Anything green it touches becomes one more bullet. Each level script checks every frame whether a room's enemies are all gone, and opens that room's door if so.

| File or folder | What is in it |
|---|---|
| `project.godot` | Project settings: the first scene, the input map, the collision layer names, and zero gravity. |
| `global.gd` | Values kept between levels: health, bullets, crystals and the current level. |
| `Player/Player.gd` | Movement, aiming, shooting, suction, dash and taking damage. |
| `Bacteria/Bacteria.gd` | The bacteria: follow the player, take hits, break apart into pieces. |
| `Turret/Turret.gd` | Turrets that shoot blue bullets at the player. |
| `Bosses/BigBoi/BigBoi.gd` | The boss. |
| `Bullet/Bullet.gd` | Bullets. Green ones hurt enemies, blue ones hurt you. |
| `World/Levels/` | The three levels and a sample level. |
| `DificultySelectionScreen/DificultyScreen.gd` | Sets health and bullets for each difficulty. |
| `ProceduralMapGenerator/ProceduralMap.gd` | A procedural level generator. The game does not use it at the moment. |

## Ideas to try

1. Change how the player feels. Edit `ACCELERATION`, `MAX_SPEED`, `FRICTION` and `BULLET_SPEED` at the top of `Player/Player.gd`.
2. Add a difficulty level. Copy one of the functions in `DificultySelectionScreen/DificultyScreen.gd` and give it new numbers. You will also need a new zone in the scene.
3. Make enemies tougher or kinder. In `Bacteria/Bacteria.gd`, `Health` sets how many hits a bacterium takes and `AmoutOfComponentsGeneratedAtDeath` sets how many green pieces it drops.
4. Let the bacteria shoot back. The call to `shoot()` in `_process` in `Bacteria/Bacteria.gd` is commented out.
5. Try the procedural map. `DificultySelectionScreen/DificultyScreen.gd` has a commented-out line that sends the game to `ProceduralMapGenerator/ProceduralMap.tscn` instead of Level 1.

## Technical details

- Engine: Godot 3 (`config_version=4` in `project.godot`), using the GLES2 renderer.
- First scene: `res://MainScreen/MainScreen.tscn`. The order is title screen, difficulty screen, `Level1`, `Level2`, `Level3 - Boss`, then back to the title screen.
- Autoload: `Global` from `global.gd`.
- Collision layers: 1 Player, 2 World, 3 Bacteria, 4 Bullets, 5 AbsorbRay, 6 Absorbable.
- Input actions: `KEY_UP`, `KEY_DOWN`, `KEY_LEFT`, `KEY_RIGHT` (WASD and arrows), `PRIMARY` (left mouse), `SECONDARY` (right mouse). Dash reads the Space key directly.

## Project status

Game still in development. It was made during a four-day jam and has had no changes to the game since June 2020. Known problems, found by reading the code:

- There is no screenshot in the repo.
- The bacteria's own shooting is switched off in the code.
- `ProceduralMapGenerator/` is unfinished and not used.
- Folder names keep the jam spelling (`DificultySelectionScreen`).

## Licence

The repo's licence lets you use, copy and change this code for any purpose, as long as you keep the copyright notice. See [LICENSE](LICENSE) (MIT). The art, sound and music were made by the team listed below.

## Credits

A game developed for the UOP 4 day Game Jam.

- Sound Designer: Camiel Povel
- Gameplay and Character Developer: Abhishek Shivakumar
- Developer and 2D Artist: Kevin D Fitch (KevinDNF)

Built with [Godot](https://godotengine.org/). The `World/Fonts/Pixeled.ttf` font is included in the repo.
