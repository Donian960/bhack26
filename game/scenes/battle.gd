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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
