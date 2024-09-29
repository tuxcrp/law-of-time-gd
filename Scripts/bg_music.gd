extends Node

var audio_player: AudioStreamPlayer

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

	# Load and play the music
	audio_player.stream = load("res://assets/sounds/medieval-ambient-236809.mp3")
	audio_player.play()
