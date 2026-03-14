extends Node2D

var precard = preload("res://scenes/card.tscn")

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

	var id = int(json["query"]["random"][0]["id"])
	
	$HTTPRequest2.request_completed.connect(random_data_completed)
	$HTTPRequest2.request("https://en.wikipedia.org/w/api.php?action=query&pageids="+str(id)+"&prop=pageviews|images|pageimages&format=json")

func random_data_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var view_data
	var image_data
	var thumbnail
	
	print(json)
	
	for id in json["query"]["pages"]:
		if json["query"]["pages"][id].has("pageviews"):
			view_data = json["query"]["pages"][id]["pageviews"]
		if json["query"]["pages"][id].has("images"):
			image_data = json["query"]["pages"][id]["images"]
		if json["query"]["pages"][id].has("thumbnail"):
			thumbnail = json["query"]["pages"][id]["thumbnail"]
		
	print(view_data)
	print(image_data)
