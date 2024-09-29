extends Node2D

@onready var fade = $Fade/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coins: Node = $Coins

var time_paused_a = true
var time_paused_b = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
				
				
	print(time_paused_a, " | ", time_paused_b)
