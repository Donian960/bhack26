extends Node2D

var precard = preload("res://scenes/card.tscn")

var enemy_hand = []
var player_hand = []

var pscore = 0
var escore = 0

var phase = "TIMER"

var category

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$TextureRect2.visible = true
	
	for i in range(5):
		var ncard = precard.instantiate()
		var ocard = precard.instantiate()
		
		enemy_hand.append(ncard)
		player_hand.append(ocard)
		
		add_child(ncard)
		add_child(ocard)
		
	for card in enemy_hand:
		card.visible = false
		
	for i in range(5):
		player_hand[i].position.y = 700
		player_hand[i].position.x = 75 + i*275
		
	$Timer.start()

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
		
		if ml.y > 600:
			if ml.x > 75 and ml.x < 1600 - 75:
				for i in range(5):
					if ml.x > 75 + i*275 and (ml.x < 75+(i)*275 + 350 or i == 4):
						highlighted = i
						
		for i in range(5):
			player_hand[i].position.y = 700
			player_hand[i].z_index = 0
			if i == highlighted:
				player_hand[i].position.y = 350
				player_hand[i].z_index = 1
				
func newcat():
	var randnum = randi_range(1, 4)
	if randnum == 1:
		category = "Words"
	if randnum == 2:
		category = "Images"
	if randnum == 3:
		category = "Scrabble"
	if randnum == 4:
		category = "Views"
		
	$Category.text = "CATEGORY: \n" + category

func _on_timer_timeout() -> void:
	$TextureRect2.visible = false
	phase = "HAND"
	newcat()
