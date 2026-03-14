extends Node2D

var precard = preload("res://scenes/card.tscn")

var enemy_hand = []
var player_hand = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
	if $TextureRect2.visible == true:
		
		if $Timer.time_left > 1:
			$TextureRect2/IntroLabel1.modulate.a = 3 - $Timer.time_left
			
		if $Timer.time_left < 1:
			$TextureRect2/IntroLabel1.visible = false
			$TextureRect2/IntroLabel2.visible = true
		
	else:
		
		pass

func _on_timer_timeout() -> void:
	$TextureRect2.visible = false
