extends Node2D

## A number representing the order the HitBeat appears.
var order_number := 0: set = _set_order_number

# If `true`, the player already tapped this HitBeat.
var _beat_hit := false

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _touch_area: Area2D = %Area2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _label: MarginContainer = %CustomLabel


# We play the show animation when adding HitBeat instances to the scene tree, so they automatically fade in.
func _ready() -> void:
	_touch_area.input_event.connect(_on_touch_area_input_event)
	_animation_player.play("show")


# This function initializes the HitBeat's properties.
# A separate object will spawn HitBeat instances and call this function, as
# we'll see in the next lesson.
# The function expects a dictionary with three keys: `half_beat`, a number,
# `global_position`, the position to place this instance, and `color`, a number
# representing the sprite's frame.
func setup(data: Dictionary) -> void:
	# We write `self.order_number` to run through the property's setter
	# function.
	self.order_number = data.half_beat
	global_position = data.global_position
	_sprite.frame = data.color


# Finally, here's the setter for the `order_number` property.
func _set_order_number(number: int) -> void:
	order_number = number
	_label.text = str(order_number)


func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("touch"):
		_beat_hit = true
		# We disable any further events by removing any physics layers.
		_touch_area.collision_layer = 0
		# Run the destroy animation to hide and free the node.
		_animation_player.play("destroy")
