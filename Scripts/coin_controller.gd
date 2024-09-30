class_name Coin
extends AnimatedSprite2D

@export var is_white: bool

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_white:
		if body.is_player_a:
			audio_stream_player_2d.play()
			Globals.white_coins += 1
			queue_free()
	else:
		if !body.is_player_a:
			audio_stream_player_2d.play()
			Globals.black_coins += 1
			queue_free()
