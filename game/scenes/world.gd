extends Node2D

<<<<<<< HEAD
var precard = preload("res://scenes/card.tscn")

=======
>>>>>>> 96e0ee9ecc74ebd9ea5722d6bd041f460a153a36
func _ready():
	get_random_article()

func get_random_article():
	$HTTPRequest.request_completed.connect(random_article_returned)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnfilterredir=nonredirects&prop=pageviews&prop=images&format=json")

func random_article_returned(result, response_code, headers, body):
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	var id = int(json["query"]["random"][0]["id"])
	
	$HTTPRequest2.request_completed.connect(page_data_returned)
	$HTTPRequest2.request("https://en.wikipedia.org/w/api.php?action=query&pageids="+str(id)+"&prop=pageviews|images|pageimages&format=json")

func page_data_returned(result, response_code, headers, body):
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
