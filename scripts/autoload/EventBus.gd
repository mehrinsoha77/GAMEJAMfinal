extends Node
## Global signal bus. Every system (puzzles, doors, DOF manager, level
## managers) talks through this instead of holding direct references to
## each other. This is what keeps Level2+ pluggable without rewiring
## Level 1's scripts.

signal puzzle_completed(puzzle_id: String)
signal dof_unlocked(dof_name: String)
signal level_completed(level_id: String)
signal player_died()
