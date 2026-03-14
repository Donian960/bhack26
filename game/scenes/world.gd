extends Node2D


func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&pageids=23795530&prop=categories&format=json")

func _on_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
