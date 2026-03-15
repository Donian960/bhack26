extends Node2D

var all_cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_chosen_hand = []
	
	for card in Global.player_owned_cards:
		Global.remove_child(card)
		add_child(card)
		all_cards.append(card)
		
		card.visible = true
		
	for i in range(len(all_cards)):
		all_cards[i].position.x = i * 400 + 20
		all_cards[i].position.y = 50
		
	$HScrollBar.max_value = len(all_cards)
	
func reposition_hand():
		
	for i in range(len(Global.player_chosen_hand)):
		Global.player_chosen_hand[i].zindex = i
		Global.player_chosen_hand[i].position.y = 700
		Global.player_chosen_hand[i].position.x = 800 + (i - float(len(Global.player_chosen_hand)) / 2) * 150 - 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if len(Global.player_chosen_hand) > 0:
		$Button.disabled = false
		$Button.visible = true
		
	else:
		$Button.disabled = true
	
	if Input.is_action_just_pressed("click"):
		
		var ml = get_viewport().get_mouse_position()
		
		for card in all_cards:
			if ml.x > card.position.x and ml.x < card.position.x + 350 and ml.y > card.position.y and ml.y < card.position.y + 500:
				
				if card not in Global.player_chosen_hand:
					if len(Global.player_chosen_hand) < 9:
						Global.player_chosen_hand.append(card)
				
				else:
					Global.player_chosen_hand.erase(card)
					
		reposition_hand()
		_on_h_scroll_bar_value_changed($HScrollBar.value)

func _on_h_scroll_bar_value_changed(value: float) -> void:
	for i in range(len(all_cards)):
		if all_cards[i] not in Global.player_chosen_hand:
			all_cards[i].position.x = (i - value) * 400 + 20
			all_cards[i].position.y = 50

func _on_button_pressed() -> void:
	for card in all_cards:
		remove_child(card)
		Global.add_child(card)
		card.zindex = 0
		
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
