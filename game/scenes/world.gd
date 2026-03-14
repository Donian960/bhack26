extends Node2D


func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://en.wikipedia.org/w/index.php?title=Pet_door&action=raw&format=json")

func _on_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
