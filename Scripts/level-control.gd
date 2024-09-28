extends Node2D

@onready var fade = $Fade/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
