@tool
@icon("res://Editor/placer_hit_beat_icon.svg")
class_name PlacerHitBeat extends Node2D

## The scene to instance instead of the placeholder
# For the PlacerHitBeat, this will be the HitBeat scene.
# You could make this a constant instead.
# I went with an exported variable to avoid hard-coding the path.
@export var scene: PackedScene
## The note's duration in half-beats.
# Any number greater than 1 will add rests to
# the stack to delay the next instruction.
@export_range(1, 4) var duration: int = 2: set = _set_duration

# The number to display in the editor and on the instanced HitBeat at runtime.
var _order_number: int = 1

@onready var order_number_label: Label = %OrderNumber
@onready var sprite: Sprite2D = %Sprite2D


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# We set the node's order and update the label's text.
		# The `Node.get_index()` tells us a node's position in the scene tree
		# relative to other siblings.
		# It starts at `0`, which is why we add `1` to the value.
		_order_number = get_index() + 1
		order_number_label.text = str(_order_number)


## Gets a dictionary to add to the stack.
# All placer scenes will have this function. The HitSpawner will call it.
func get_data() -> Dictionary:
	return {
		scene = scene,
		order_number = _order_number,
		global_position = global_position,
		duration = duration
	}


# Whenever we set the duration, we also want to update the sprite's frame.
func _set_duration(amount: int) -> void:
	duration = amount
	sprite.frame = duration - 1
