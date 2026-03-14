extends Node2D


func _ready():
	get_random_article()
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)

func get_random_article():
	$HTTPRequest.request_completed.connect(random_article_completed)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&rnfilterredir=nonredirects&format=json")

func random_article_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
