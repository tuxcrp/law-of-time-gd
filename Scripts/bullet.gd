extends Node2D

var speed: float = 250.0
@export var is_white: bool = true

@onready var fade: AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	# Set up the bullet's appearance based on its color
	if is_white:
		$Sprite2D.modulate = Color.WHITE  # Assuming there's a Sprite2D child node
	else:
		$Sprite2D.modulate = Color.BLACK

func _process(delta: float) -> void:
	position += transform.x * speed * delta

	if is_colliding_with_player():
		
		$"../Label".show()
		$"../ColorRect2".show()
		fade.play("fade")
		await get_tree().create_timer(2).timeout
		get_tree().reload_current_scene()

func is_colliding_with_player() -> bool:
	if is_white:
		var player_a = get_parent().get_node("Player1")
		if player_a and position.distance_to(player_a.position) < 10: 
			return true
	else:
		var player_b = get_parent().get_node("Player2")
		if player_b and position.distance_to(player_b.position) < 10: 
			return true
	return false
