extends CharacterBody2D

var speed = 1000
var target_position = position

@export var grid_size:int = 50
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func snap_to_grid(position) -> Vector2:
	var snapped_x = round(position.x / grid_size) * grid_size
	var snapped_y = round(position.y / grid_size) * grid_size
	return Vector2(snapped_x, snapped_y)
	
func within_limits(position) -> bool:
	var gx = round(position.x / grid_size) 
	var gy = round(position.y / grid_size)
	print(gx,"|", gy)
	if (-14 < gx and gx < 13) and (-9 < gy and gy < 8):
		return true
	else:
		return false
			
func _physics_process(delta):
	if (target_position - position).length() > 10:
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
		
	else:
		position = target_position
		var movement_vector = Vector2.ZERO
		if Input.is_action_just_pressed("left"):
			movement_vector.x -= 1
		if Input.is_action_just_pressed("right"):
			movement_vector.x += 1
		if Input.is_action_just_pressed("up"):
			movement_vector.y -= 1
		if Input.is_action_just_pressed("down"):
			movement_vector.y += 1

		movement_vector = movement_vector.normalized()

		if movement_vector != Vector2.ZERO and within_limits(position + movement_vector * grid_size):
			target_position = snap_to_grid(position + movement_vector * grid_size)
			audio_stream_player_2d.play()
