extends Node

var music_player: AudioStreamPlayer2D

func _ready():
	# Wait for the main scene to be ready
	await get_tree().root.ready
	
	# Get the AudioStreamPlayer2D from the main scene
	music_player = get_node("/root/Root/AudioStreamPlayer2D")
	
	if music_player:
		ensure_music_playing()
	else:
		print("AudioStreamPlayer2D not found in the main scene")

func ensure_music_playing():
	if not music_player.playing:
		music_player.play()

# Call this function when changing scenes
func prepare_for_scene_change():
	if music_player:
		# Remove the AudioStreamPlayer2D from its current parent
		music_player.get_parent().remove_child(music_player)
		# Add it to this autoload node to persist across scene changes
		add_child(music_player)

# Call this function after changing scenes
func restore_music_player():
	if music_player and music_player.get_parent() == self:
		# Remove the AudioStreamPlayer2D from this autoload node
		remove_child(music_player)
		# Add it back to the root node of the new scene
		get_tree().root.add_child(music_player)
	ensure_music_playing()
