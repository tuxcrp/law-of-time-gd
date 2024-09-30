extends Node2D

@export var randomness: float = 0.25
@export var is_white: bool = true
var bullet: PackedScene
var player: CharacterBody2D

@onready var Globals = get_parent()

func _ready() -> void:
	if is_white:
		bullet = preload("res://bullet_white.tscn")
		player = get_node("../Player1") 
	else:
		bullet = preload("res://bullet_black.tscn")
		player = get_node("../Player2")  

func _process(delta: float) -> void:
	if not is_time_paused():
		update_rotation()
		shoot_projectile()
			

func update_rotation() -> void:
	look_at(player.position)

func shoot_projectile() -> void:
	if randf() < randomness:
		var new_bullet = bullet.instantiate()
		new_bullet.position = global_position
		new_bullet.rotation = rotation
		get_parent().add_child(new_bullet)
		new_bullet.set_as_top_level(true)

func is_time_paused() -> bool:
	return (is_white and Globals.time_paused_a) or (not is_white and Globals.time_paused_b)
