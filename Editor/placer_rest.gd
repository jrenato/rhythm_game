@tool
@icon("res://Editor/placer_rest_icon.svg")
class_name PlacerRest extends Node2D

@export_range(1, 4) var duration: int = 2: set = _set_duration

var _order_number := 1

@onready var sprite: Sprite2D = %Sprite2D
@onready var order_number_label: Label = %OrderNumber


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_order_number = get_index() + 1
		order_number_label.text = str(_order_number)


func get_data() -> Dictionary:
	return {duration = duration}


func _set_duration(amount : int) -> void:
	duration = amount
	await ready
	sprite.frame = duration - 1
