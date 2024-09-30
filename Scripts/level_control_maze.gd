extends Node2D

@export var splashy:String = ""

@onready var fade = $Fade/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_1: CharacterBody2D = $Player1
@onready var player_2: CharacterBody2D = $Player2
@onready var timer: Timer = $Timer

@onready var tile_map_layer: TileMapLayer = $"Base"
var black_coin_scene: PackedScene
var white_coin_scene: PackedScene
var tilemap_rect: Rect2
var coins_spawned: bool = false

var game_started = false

var time_paused_a = true
var time_paused_b = true

var target_pos_a = Vector2(0, 0)
var target_pos_b = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if coins_spawned:
		var coins = get_tree().get_nodes_in_group("Coins");
		var time_paused = time_paused_a and time_paused_b
		for coin in coins:
			if time_paused:
				if coin.is_playing():
					coin.pause()
			else:
				if !coin.is_playing():
					coin.play()
					
		if len(coins) == 0:
			fade.play("fade_in")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://tut_2.tscn")
			
					
		if Input.is_action_just_pressed("p1_switch") \
			and Input.is_action_pressed("p2_switch") \
			or Input.is_action_just_pressed("p2_switch") \
			and Input.is_action_pressed("p1_switch"):
				if timer.is_stopped():
					player_2.target_position = player_1.position
					player_1.target_position = player_2.position
					
					timer.start(5)
	elif game_started:
		spawn_coins()
				
func _on_timer_timeout() -> void:
	player_2.target_position = player_1.position
	player_1.target_position = player_2.position


func _ready() -> void:
	var splash = splashy.replace("|", "\n")
	print(splashy)
	fade.get_parent().get_node("ColorRect").color.a = 255
	$Fade/Label.text = splash
	await get_tree().create_timer(5).timeout
	#$Fade/Label.text = ""
	fade.play("fade_out")
	animation_player.play("camera_zoom")
	
	black_coin_scene = preload("res://black_coin.tscn")
	white_coin_scene = preload("res://white_coin.tscn")
	
	tilemap_rect = tile_map_layer.get_used_rect()
	game_started = true
	
func get_empty_tiles() -> Array:
	var empty_tiles = []
	for x in range(tilemap_rect.position.x, tilemap_rect.end.x):
		for y in range(tilemap_rect.position.y, tilemap_rect.end.y):
			if tile_map_layer.get_cell_source_id(Vector2i(x, y)) == -1:
				empty_tiles.append(Vector2(x, y))
	return empty_tiles


func spawn_coins():
	var time_paused = time_paused_a and time_paused_b
	
	var empty_tiles = get_empty_tiles()
	var mid_x = tilemap_rect.position.x + tilemap_rect.size.x / 2
	var left_tiles = empty_tiles.filter(func(pos): return pos.x < mid_x)
	var right_tiles = empty_tiles.filter(func(pos): return pos.x >= mid_x)
	
	var spawned_coins = []
	
	for side_tiles in [left_tiles, right_tiles]:
		for coin_type in [black_coin_scene, white_coin_scene]:
			for i in range(5):  # 5 of each coin type per side
				var valid_position = false
				var attempts = 0
				while not valid_position and attempts < 100:
					var random_tile = side_tiles[randi() % side_tiles.size()]
					if is_valid_spawn_position(random_tile, spawned_coins):
						var coin: Coin = coin_type.instantiate()
						print(random_tile)
						
						var tile_position = tile_map_layer.map_to_local(random_tile)
						var center_offset = Vector2(-16, -16)
						coin.position = tile_position + center_offset
						
						add_child(coin)
						coin.add_to_group("Coins") 
						spawned_coins.append(random_tile)
						valid_position = true
						if time_paused:
							if coin.is_playing():
								coin.pause()
					attempts += 1
				
				if attempts >= 100:
					print("Warning: Could not find a valid position for all coins")

	coins_spawned = true


func is_valid_spawn_position(pos: Vector2, spawned_coins: Array) -> bool:
	for coin in spawned_coins:
		if pos.distance_to(coin) < 2:
			return false
	return true
