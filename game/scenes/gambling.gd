extends Node2D

var neocard

var precard = preload("res://scenes/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for card in Global.player_owned_cards:
		card.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "MONEY: " + str(Global.money)
	
	if Global.money == 0:
		$VBoxContainer/Button.disabled = true


func _on_button_2_pressed() -> void:
		
	if neocard != null:
		remove_child(neocard)
		Global.add_child(neocard)
			
	get_tree().change_scene_to_file("res://scenes/world_2.tscn")


func _on_button_pressed() -> void:
	if Global.money > 0:
		Global.money -= 1
		
		if neocard != null:
			remove_child(neocard)
			Global.add_child(neocard)

		neocard = precard.instantiate()
		
		for card in Global.player_owned_cards:
			card.visible = false
			
		neocard.visible = true
		neocard.position = Vector2(800 - 350/2, 50)
		
		Global.player_owned_cards.append(neocard)
		add_child(neocard)
