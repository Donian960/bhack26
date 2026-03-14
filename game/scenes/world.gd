extends Node2D


func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnnamespace=0")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
