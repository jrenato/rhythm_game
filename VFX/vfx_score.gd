extends Marker2D

# We define three constants to name the other three available frames in our
# sprite sheet.
# We don't include the "miss" image as it's the one displayed by default and we
# don't need to set it from the script.
const FRAME_OK := 1
const FRAME_GREAT := 2

const FRAME_PERFECT := 3_

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: GPUParticles2D = %GPUParticles2D


# Setting the node as top-level makes its transform independent from its parent
# node. This means we can place it anywhere in the scene tree, and its position
# will always be global, that is, relative to the world's origin.
func _ready() -> void:
	set_as_top_level(true)


# This function positions the node and maps a given score to the corresponding
# sprite.
func setup(global_pos: Vector2, score: int) -> void:
	global_position = global_pos
	if score >= 10:
		_sprite.frame = FRAME_PERFECT
		# When the player makes a perfect score, we also emit particles.
		_particles.emitting = true
	elif score >= 5:
		_sprite.frame = FRAME_GREAT
	elif score >= 3:
		_sprite.frame = FRAME_OK
