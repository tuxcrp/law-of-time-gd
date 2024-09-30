extends Node2D

@export var is_white:bool = true
var bullet: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_white:
		bullet = preload("res://bullet_white.tscn")
	else:
		bullet = preload("res://bullet_black.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
