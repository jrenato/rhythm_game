extends ColorRect


# Corresponds to the `torus_thickness` property in the shader.
const THICKNESS := 0.015

# The speed at which the `_radius` property below goes down, in pixels per
# second.
var shrink_speed := 0.0

# These 3 values allow us to update and animate the ring's radius every frame.
var _radius := 0.0
var _end_radius := 0.0
var _start_radius := 0.0


# Initialises the node's properties to properly draw the ring and calculate its
# radius.
func setup(radius_start: float, radius_end: float, bps: float, beat_delay: float) -> void:
	_radius = radius_start
	_end_radius = radius_end
	_start_radius = _radius
	# The calculation below allows us to make the animation faster for faster
	# songs, and faster if the starting radius is bigger.
	shrink_speed = 1.0 / bps / beat_delay * (_radius - _end_radius)

	# We set the margins and position via code, based on the `_radius`.
	# This way, the node will be the exact size we need to encompass the ring.
	#pivot_offset = Vector2.ONE * _radius
	position = Vector2.ONE * _radius * -1
	size = Vector2.ONE * _radius * 2


func _process(delta: float) -> void:
	# Every frame, we lower the radius and forward the property to the shader.
	_radius -= delta * shrink_speed
	# The shader expects a radius in UV space, with a value between zero and
	# one, so we divide our value by the node's start radius.
	material.set_shader_parameter("torus_radius", _radius / _start_radius / 2)

	# When the node reached the and or target radius, we stop the animation.
	if _radius <= _end_radius:
		_radius = _end_radius
		set_process(false)
