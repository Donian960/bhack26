extends Node2D

func _ready():
	get_random_article()

func get_random_article():
	$HTTPRequest.request_completed.connect(random_article_returned)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnfilterredir=nonredirects&prop=pageviews&prop=images&format=json")

func random_article_returned(result, response_code, headers, body):
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	var id = int(json["query"]["random"][0]["id"])
	
	$HTTPRequest2.request_completed.connect(page_data_returned)
	$HTTPRequest2.request("https://en.wikipedia.org/w/api.php?action=query&pageids="+str(id)+"&prop=pageviews|images&format=json")

func page_data_returned(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
