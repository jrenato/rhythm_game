extends Label

# Keeps track of the current score as a number.
var _total_score: int = 0


func _ready() -> void:
	# We connect to our new signal to know when to increase the score.
	Events.scored.connect(_add_score)


func _add_score(msg: Dictionary) -> void:
	# When the player scores, we increase the score and update the Label to show
	# it. You could play an animation here too.
	_total_score += msg.score
	text = str(_total_score)
