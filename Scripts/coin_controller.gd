class_name Coin
extends AnimatedSprite2D

@export var is_white: bool

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	audio_stream_player_2d.play()
	if is_white:
		if body.is_player_a:
			Globals.white_coins += 1
			queue_free()
	else:
		if !body.is_player_a:
			Globals.black_coins += 1
			queue_free()
