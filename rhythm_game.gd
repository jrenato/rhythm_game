extends Node2D

## The track's Beats Per Minute.
@export var bpm: int = 124

# We store the number of beats and half-beats per per second. We'll use that to calculate how many beats elapsed in the song.
var _bps: float = 60.0 / bpm
var _hbps: float = _bps * 0.5
# Stores the index of the last half-beat we passed.
var _last_half_beat: int = 0

@onready var _stream: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	play_audio()


func play_audio() -> void:
	var time_delay: float = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	await get_tree().create_timer(time_delay).timeout

	_stream.play()


func _process(_delta: float) -> void:
	var time: float = (
		_stream.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)

	# Calculate the current half-beat using
	# half-beats-per-second
	var half_beat: int = int(time / _hbps)

	if half_beat > _last_half_beat:
		_last_half_beat = half_beat
