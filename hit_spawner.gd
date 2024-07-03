extends Node

## If `true`, the spawner is actively spawning beats.
# We use it in `_spawn_beat()` below.
@export var enabled: bool = true

## The hit_beat PackedScene
# Allows us to store the preloaded hit_beat scene
# to instance it.
@export var hit_beat: PackedScene

## An array of dictionaries representing instructions on what to spawn.
var _stack_current = []

## Dictionary that stores each stack of instructions.
# Doing so allows us to pair the stack with the name of the track, which is a
# string.
var _stacks = {}

@onready var patterns: Node2D = %Patterns


func _ready() -> void:
	Events.beat_incremented.connect(_spawn_beat)
	_generate_stacks()
	_select_stack({"name": "Cephalopod"})


## Select the track to play
func _select_stack(msg: Dictionary) -> void:
	_stack_current = _stacks[msg.name]


## Reads each child of the Pattern node and gets an array of data from them.
func _generate_stacks() -> void:
	for pattern in patterns.get_children():
		# Create a new key pair in the _stacks dictionary.
		_stacks[pattern.name] = []
		for chunk in pattern.get_children():
			# We assign a random color to each section of the track.
			var sprite_frame: int = randi_range(0, 5)
			# We get data from each placer instance and append it to the stack.
			for placer in chunk.get_children():
				var hit_beat_data: Dictionary = placer.get_data()
				hit_beat_data.color = sprite_frame
				_stacks[pattern.name].append(hit_beat_data)

				# Add additional rests if needed.
				for _i in range(hit_beat_data.duration - 1):
					_stacks[pattern.name].append({})

	# Free the patterns scene as it's not needed in-game.
	patterns.queue_free()


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
