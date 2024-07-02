extends TextureRect

# To animate the sprite pulsating, we have it start at a large scale and scale
# up and down.
# The following properties define the animation's range.
var _start_scale := Vector2.ONE * 1.5
var _end_scale := Vector2.ONE
var _tween: Tween


func _ready():
	# We connect to `beat_incremented` to trigger the animation every beat.
	Events.beat_incremented.connect(_pulse)


func _pulse(msg: Dictionary):
	# We want to only pulse every beat (every two half-beats), so we return if
	# we're not on a beat.
	if msg.half_beat % 2 == 1:
		return

	var _beats_per_second: float = msg.bps

	if _tween:
		_tween.kill()
	_tween = create_tween()

	scale = _start_scale

	# We animate the scale going down. This way, the metronome pops up every
	# beat and shrinks gradually, giving it some visual impact.
	# We calculate a duration that makes the pulse faster in faster songs,
	# typically a fraction of a beat.
	_tween.tween_property(self, "scale", _end_scale, _beats_per_second / 4)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
