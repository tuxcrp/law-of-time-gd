extends Node2D

var speed: float = 200.0
@export var is_white: bool = true

@onready var fade: AnimationPlayer = $"../AnimationPlayer"

func _process(delta: float) -> void:
	position += transform.x * (speed if !is_white else speed / 3) * delta

	if is_colliding_with_player():
		remove_all_bullets()
		$"../Label".show()
		$"../ColorRect2".show()
		fade.play("fade")
		await get_tree().create_timer(2).timeout
		get_tree().reload_current_scene()

func is_colliding_with_player() -> bool:
	if is_white:
		var player_a = get_parent().get_node("Player1")
		if player_a and position.distance_to(player_a.position) < 6: 
			return true
	else:
		var player_b = get_parent().get_node("Player2")
		if player_b and position.distance_to(player_b.position) < 10: 
			return true
	return false

func remove_all_bullets() -> void:
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()
