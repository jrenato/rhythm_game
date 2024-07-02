extends Node


## Emitted every time we move a half-beat forward in a song.
signal beat_incremented(msg: Dictionary)

## Emitted when the player made an action that increases the score.
signal scored(msg: Dictionary)

## Emitted when a track is finished
signal track_finished
