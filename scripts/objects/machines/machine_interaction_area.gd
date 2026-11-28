extends Area2D

signal player_entered
signal player_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_entered.connect(_on_body_entered)
	player_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_exited.emit()
