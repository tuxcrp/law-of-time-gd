extends AnimatedSprite2D
@export var is_white:bool


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_white:
		Globals.white_coins += 1
	else:
		Globals.black_coins += 1
		
	queue_free()
