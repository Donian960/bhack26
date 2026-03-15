extends Node2D

var precard = preload("res://scenes/card.tscn")

var enemy_hand = []
var player_hand = []

var pscore = 0
var escore = 0

var phase = "TIMER"

var category

var player_card
var enemy_card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$TextureRect2.visible = true
	
	if Global.uses_random_hand == true:
	
		for i in range(9):
			var ncard = precard.instantiate()
			var ocard = precard.instantiate()
			
			enemy_hand.append(ncard)
			player_hand.append(ocard)
			
			add_child(ncard)
			add_child(ocard)
			
		for card in enemy_hand:
			card.visible = false
			
	else:
	
		for i in range(9):
			var ncard = precard.instantiate()
			
			enemy_hand.append(ncard)
			
			add_child(ncard)
			
		for card in enemy_hand:
			card.visible = false
			
		for card in Global.player_chosen_hand:
			Global.remove_child(card)
			add_child(card)
			player_hand.append(card)
			
		while len(player_hand) < 9:
			var ocard = precard.instantiate()
			player_hand.append(ocard)
			add_child(ocard)
		
	reposition_hand()
		
	$Timer.start()
	
func reposition_hand():
		
	for i in range(len(player_hand)):
		player_hand[i].position.y = 700
		player_hand[i].position.x = 800 + (i - float(len(player_hand)) / 2) * 150 - 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phase == "TIMER":
		
		if $Timer.time_left > 1:
			$TextureRect2/IntroLabel1.modulate.a = 3 - $Timer.time_left
			
		if $Timer.time_left < 1:
			$TextureRect2/IntroLabel1.visible = false
			$TextureRect2/IntroLabel2.visible = true
		
	elif phase == "HAND":
		
		var highlighted = null
		
		var ml = get_viewport().get_mouse_position()
		
		if ml.y > 400:
			if ml.x > 75 and ml.x < 1600 - 75:
				for i in range(len(player_hand)):
					if ml.x > player_hand[i].position.x and ml.x < player_hand[i].position.x + 350:
						highlighted = i
						
		for i in range(len(player_hand)):
			player_hand[i].position.y = 700
			player_hand[i].z_index = 0
			if i == highlighted:
				player_hand[i].position.y = 350
				player_hand[i].z_index = 1
				
		if highlighted != null and Input.is_action_just_pressed("click"):
			player_card = player_hand[highlighted]
			
			var best_score = 0
			for card in enemy_hand:
				if card.stats[category] >= best_score and randi_range(1, 5) != 1:
					best_score = card.stats[category]
					enemy_card = card
					
			if enemy_card == null:
				enemy_card = enemy_hand[randi_range(0, len(enemy_hand))]
			
			phase = "VERSUS"
			
			for card in player_hand:
				card.visible = false
				
			for card in enemy_hand:
				card.visible = false
				
			player_hand.erase(player_card)
			
			enemy_hand.erase(enemy_card)
			
			player_card.visible = true
			enemy_card.visible = true
			
			player_card.position.x = 400 - (350 / 2)
			enemy_card.position.x = 1200 - (350 / 2)
			
			player_card.position.y = 300
			enemy_card.position.y = 300
			
			$VS.visible = true
			
	elif phase == "VERSUS":
		
		if Input.is_action_just_pressed("click"):
			
			var side = "DRAW!"
			
			phase = "WINNER"
			
			var wincard = null
			
			if player_card.stats[category] > enemy_card.stats[category]:
				pscore += 1
				side = "WIN!"
				
				$Score1.text = str(pscore)
				
				wincard = player_card
				enemy_card.visible = false
				
			elif player_card.stats[category] < enemy_card.stats[category]:
				escore += 1
				side = "LOSE!"
				
				$Score2.text = str(escore)
				
				wincard = enemy_card
				player_card.visible = false
				
			$Category.text = side
			$VS.visible = false
			
			if wincard != null:
				wincard.position.x = 800 - (350 / 2)
				
	elif phase == "WINNER":
		
		if Input.is_action_just_pressed("click"):
			
			if player_card in Global.player_owned_cards:
				remove_child(player_card)
				Global.add_child(player_card)
				
			else:
			
				player_card.queue_free()
				
			enemy_card.queue_free()
			
			player_card = null
			enemy_card = null
			
			if len(player_hand) != 0:
			
				newcat()
				
				reposition_hand()
				
				phase = "HAND"
				
			else:
				phase = "GAME END"
				
	elif phase == "GAME END":
		
		$Category.text = "GAME OVER"
		
		$"GAME END".visible = true
		
		if pscore > escore:
			$"GAME END".text = "YOU WIN!"
		elif escore > pscore:
			$"GAME END".text = "YOU LOSE!"
		else:
			$"GAME END".text = "DRAW!"
			
		if Input.is_action_just_pressed("click"):
			Global.money += pscore
			get_tree().change_scene_to_file("res://scenes/world_2.tscn")
				
func newcat():
	var randnum = randi_range(1, 4)
	if randnum == 1:
		category = "Links"
	if randnum == 2:
		category = "Images"
	if randnum == 3:
		category = "Scrabble"
	if randnum == 4:
		category = "Views"
		
	$Category.text = "- CATEGORY -\n" + category
	
	for card in player_hand:
		card.visible = true

func _on_timer_timeout() -> void:
	$TextureRect2.visible = false
	phase = "HAND"
	newcat()
