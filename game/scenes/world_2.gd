extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(Global.player_owned_cards) == 0:
		$VBoxContainer/Button2.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.uses_random_hand = true
	get_tree().change_scene_to_file("res://scenes/battle.tscn")

func _on_gambling_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gambling.tscn")

func _on_button_2_pressed() -> void:
	Global.uses_random_hand = false
	get_tree().change_scene_to_file("res://scenes/choose_hand.tscn")
