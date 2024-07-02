extends Node2D

# Using the Inspector, we provide our source scene to instantiate it when the
# player taps a button.
@export var sprite_fx: PackedScene


# We connect to the `Events.scored` signal.
func _ready() -> void:
	Events.scored.connect(_create_score_fx)


# The `scored` signal comes with a `msg` dictionary which gives us the global
# position of the button the player touched and how many points they gained.
# We create a new instance of our VFX sprite, position it, add it as a child.
# We change its sprite by calling its `setup()` function.
func _create_score_fx(msg: Dictionary) -> void:
	var new_sprite_fx := sprite_fx.instantiate()
	# We need to the instance to the tree first, otherwise, we'll get an error.
	# This is because the call to `setup()` accesses child nodes.
	add_child(new_sprite_fx)
	new_sprite_fx.setup(msg.position, msg.score)
