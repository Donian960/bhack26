extends Node2D

var card_name
var card_img

var stats = {"Views": 0,
"Scrabble": 0,
"Words": 0,
"Images": 0}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_info(name, img, nstats):
	stats = nstats
	card_name = name
	card_img = img
	
	$RichTextLabel.text = name
	
	var stattext = ""
	
	for stat in stats:
		stattext += stat
		stattext += ": "
		stattext += stats[stat]
		stattext += "\n"
	
	$Label.text = stattext
	
	
