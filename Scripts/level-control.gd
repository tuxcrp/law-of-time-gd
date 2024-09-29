extends Node2D

@onready var fade = $Fade/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coins: Node = $Coins
@onready var player_1: CharacterBody2D = $Player1
@onready var player_2: CharacterBody2D = $Player2
@onready var timer: Timer = $Timer
@export var splashy:String = ""


var time_paused_a = true
var time_paused_b = true

var target_pos_a = Vector2(0, 0)
var target_pos_b = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var splash = splashy.replace("|", "\n")
	fade.get_parent().get_node("ColorRect").color.a = 255
	$Fade/Label.text = splash
	await get_tree().create_timer(5).timeout
	$Fade/Label.text = ""
	fade.play("fade_out")
	animation_player.play("camera_zoom")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_paused = time_paused_a and time_paused_b
	for coin in coins.get_children():
		if time_paused:
			if coin.is_playing():
				coin.pause()
		else:
			if !coin.is_playing():
				coin.play()
				
	if len(coins.get_children()) == 0:
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
				
func _on_timer_timeout() -> void:
	player_2.target_position = player_1.position
	player_1.target_position = player_2.position
