extends Node

## An array of dictionaries representing instructions on what to spawn.
var _stack_current = []

## If `true`, the spawner is actively spawning beats.
# We use it in `_spawn_beat()` below.
@export var enabled: bool = true

## The hit_beat PackedScene
# Allows us to store the preloaded hit_beat scene
# to instance it.
@export var hit_beat: PackedScene


func _ready() -> void:
	Events.beat_incremented.connect(_spawn_beat)
		# Add a temporary call to `_generate_stack()`


## Spawns a button the player can tap.
# Expects a dictionary with the form
# {half_beat = int, bps = float}.
# This gives us all the information we need to selectively spawn buttons at
# specific rhythmic moments in the music.
func _spawn_beat(msg: Dictionary) -> void:
	# If the spawner is not enabled, we just return from the function and spawn
	# nothing.
	if not enabled:
		return

	# After we've processed everything in the stack, we disable the HitSpawner
	# We also emit a signal which we can use later to show an end screen
	if _stack_current.is_empty():
		enabled = false
		Events.track_finished.emit()
		return

	# pop_front() grabs the front dictionary from the stack and also removes it
	var hit_beat_data: Dictionary = _stack_current.pop_front()

	# If the dictionary has no global_position, we skip instancing
	if not hit_beat_data.has("global_position"):
		return

	# Otherwise we add extra information as we did before and instance a HitBeat
	hit_beat_data.bps = msg.bps
	hit_beat_data.half_beat = msg.half_beat

	var new_beat: Node = hit_beat.instantiate()
	add_child(new_beat)
	new_beat.setup(hit_beat_data)
