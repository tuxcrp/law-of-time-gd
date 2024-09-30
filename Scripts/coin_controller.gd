class_name Coin
extends AnimatedSprite2D

@export var is_white: bool

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_white:
		if body.is_player_a:
			Globals.white_coins += 1
			queue_free()
	else:
		if !body.is_player_a:
			Globals.black_coins += 1
			queue_free()
