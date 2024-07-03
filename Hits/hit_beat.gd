extends Node2D

## A number representing the order the HitBeat appears.
var order_number := 0: set = _set_order_number

# If `true`, the player already tapped this HitBeat.
var _beat_hit := false

# Score awarded for each area.
var _score_perfect := 10
var _score_great := 5
var _score_ok := 3

# The animated ring will have a radius starting at `_radius_start` and shrinking every frame.
var _radius_start := 150.0
# The radius at which the player gets a perfect score if they tap.
var _radius_perfect := 70.0
# The current radius will shrink every frame.
var _radius := _radius_start

# Defines the scoring areas. For a perfect score, the player has to tap at plus
# or minus this radius in pixels. In this case, the radius range to get a perfect 
# is from 66 to 74 pixels.
var _offset_perfect := 4
# For great and ok, we define the timing windows by adding the offset value to
# `_radius_perfect`. For example, for a "great", you need to tap the HitBeat
# when the `_radius` is between 78 and 74 pixels.
var _offset_great := 8
var _offset_ok := 16

# Duration in beats for the target circle to shrink down to `_radius_perfect`.
var _beat_delay := 4.0
# The speed at which the target circle shrinks in pixels per second.
# Calculated based on the track's beats per second in setup()
var _speed := 0.0

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _touch_area: Area2D = %Area2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _label: Label = %Label
@onready var _target_circle: ColorRect = %TargetCircle


# We play the show animation when adding HitBeat instances to the scene tree, so they automatically fade in.
func _ready() -> void:
	_touch_area.input_event.connect(_on_touch_area_input_event)
	_animation_player.play("show")


func _process(delta: float) -> void:
	# If the HitBeat has been interacted with, we don't update it anymore.
	if _beat_hit:
		return

	# Decrease the radius by a fraction. We'll explain this in more detail
	# below. _speed is calculated in setup()
	_radius -= delta * (_radius_start - _radius_perfect) * _speed

	# The radius is past the perfect radius; the player has missed their chance
	# for points!
	if _radius <= _radius_perfect - _offset_perfect:
		# Stop taking input.
		_touch_area.collision_layer = 0

		# Score 0 points. Also, pass the position of the HitBeat to spawn any
		# visual effects at that position.
		Events.scored.emit({"score": 0, "position": global_position})
		_animation_player.play("destroy")
		 # Flag the HitBeat as interacted with
		_beat_hit = true


# This function initializes the HitBeat's properties.
# A separate object will spawn HitBeat instances and call this function, as
# we'll see in the next lesson.
# The function expects a dictionary with three keys: `half_beat`, a number,
# `global_position`, the position to place this instance, and `color`, a number
# representing the sprite's frame.
func setup(data: Dictionary) -> void:
	# We write `self.order_number` to run through the property's setter
	# function.
	self.order_number = data.order_number
	global_position = data.global_position
	_sprite.frame = data.color

	# Set the speed coefficient, which converts the shrinking speed
	# to beats per second instead of seconds.
	# Then slows the time further by how many beats we want to delay
	_speed = 1.0 / data.bps / _beat_delay
	_target_circle.setup(_radius_start, _radius_perfect, data.bps, _beat_delay)


func _get_score() -> int:
	if abs(_radius_perfect - _radius) < _offset_perfect:
		return _score_perfect
	elif abs(_radius_perfect - _radius) < _offset_great:
		return _score_great
	elif abs(_radius_perfect - _radius) < _offset_ok:
		return _score_ok
	return 0


# Finally, here's the setter for the `order_number` property.
func _set_order_number(number: int) -> void:
	order_number = number
	_label.text = str(order_number)


func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("touch") and not _beat_hit:
		_beat_hit = true
		# We disable any further events by removing any physics layers.
		_touch_area.collision_layer = 0
		# Run the destroy animation to hide and free the node.
		_animation_player.play("destroy")
		Events.scored.emit({"score": _get_score(), "position": global_position})
