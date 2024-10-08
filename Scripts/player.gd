extends CharacterBody2D

var speed = 1000
@export var target_position: Vector2 

@export var grid_size: int = 32

@export var left: String = "left"
@export var right: String = "right"
@export var up: String = "up"
@export var down: String = "down"
@export var other: CharacterBody2D
@export var is_player_a: bool = true

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var eyes: Sprite2D = $eyes
@onready var tile_map_layer: TileMapLayer = $"../Base"

@onready var Globals = get_parent()

func is_wall(direction, pos):
	pos = snap_to_grid(pos)
	pos /= grid_size
	var out = tile_map_layer.get_cell_atlas_coords(Vector2i(pos) + direction)
	return (out == Vector2i(9, 0) or out == Vector2i(10, 0))

func snap_to_grid(pos) -> Vector2:
	var snapped_x = round(pos.x / grid_size) * grid_size
	var snapped_y = round(pos.y / grid_size) * grid_size
	return Vector2(snapped_x, snapped_y)

func _process(_delta: float) -> void:
	var target = other.position - position
	eyes.position = target.normalized() * 5

func _physics_process(delta):
	if (target_position - position).length() > 10:
		if is_player_a:
			Globals.time_paused_a = false
		else:
			Globals.time_paused_b = false
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
	else:
		if is_player_a:
			Globals.time_paused_a = true
		else:
			Globals.time_paused_b = true
		position = target_position
		var movement_vector = Vector2.ZERO
		if Input.is_action_just_pressed(left) and not is_wall(Vector2i(-1, 0), position):
			movement_vector.x -= 1
		if Input.is_action_just_pressed(right) and not is_wall(Vector2i(1, 0), position):
			movement_vector.x += 1
		if Input.is_action_just_pressed(up) and not is_wall(Vector2i(0, -1), position):
			movement_vector.y -= 1
		if Input.is_action_just_pressed(down) and not is_wall(Vector2i(0, 1), position):
			movement_vector.y += 1

		movement_vector = movement_vector.normalized()

		if movement_vector != Vector2.ZERO:
			target_position = snap_to_grid(position + movement_vector * grid_size)
			audio_stream_player_2d.play()
