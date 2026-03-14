extends Node2D

var precard = preload("res://scenes/card.tscn")

var view_data
var image_data
var thumbnail

var title

func _ready():
	get_random_article_sam()

func get_random_article():
	$HTTPRequest.request_completed.connect(random_article_returned)
	$HTTPRequest.request("https://en.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&rnfilterredir=nonredirects&format=json")

func random_article_returned(result, response_code, headers, body):
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	var id = int(json["query"]["random"][0]["id"])
	
	$HTTPRequest2.request_completed.connect(page_data_returned)
	$HTTPRequest2.request("https://en.wikipedia.org/w/api.php?action=query&pageids="+str(id)+"&prop=pageviews|images|pageimages&imlimit=1&format=json")

func page_data_returned(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	print(json)
	
	var has_img = false
	
	for id in json["query"]["pages"]:
		title = json["query"]["pages"][id]["title"]
		if json["query"]["pages"][id].has("pageviews"):
			view_data = json["query"]["pages"][id]["pageviews"]
		if json["query"]["pages"][id].has("images"):
			image_data = json["query"]["pages"][id]["images"]
		if json["query"]["pages"][id].has("pageimage"):
			has_img = true
			thumbnail = json["query"]["pages"][id]["pageimage"]
			$HTTPRequest3.request_completed.connect(image_returned)
			$HTTPRequest3.request(thumbnail["source"])
		
	print(image_data)
	print(thumbnail)
	
	if has_img == false:
		new_card(null)

func image_returned(result, response_code, headers, body):
	
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
		
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
<<<<<<< HEAD

	# Display the image in a TextureRect node.
	var texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.texture = texture
	

func get_random_article_sam():
	$HTTPRequest4.request_completed.connect(data_returned_sam)
	$HTTPRequest4.request("https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnfilterredir=nonredirects&prop=pageviews|pageimages&piprop=original&format=json")

func data_returned_sam(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	var query = json["query"]
	var pages = query["pages"]
	
	for k in pages:
		var page = pages[k]
		if "title" in page.keys():
			var title = page["title"]
			print(title)
		if "pageviews" in page.keys():
			var pageviews = page["pageviews"]
		if "original" in page.keys():
			var image_source = page["original"]["source"]
			print(image_source)
			$HTTPRequest6.request_completed.connect(image_returned_sam)
			$HTTPRequest6.request(image_source)


func image_returned_sam(result, response_code, headers, body):
	print(headers)
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
		
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	# Display the image in a TextureRect node.
	var texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.texture = texture
=======
	
	new_card(texture)
	
func new_card(texture=null):
	
	var obj = precard.instantiate()
	
	var nstats = {"Views": 0,
		"Scrabble": 0,
		"Words": 0,
		"Images": 0}
	
	obj.receive_info(title, nstats, texture)
	
	add_child(obj)
>>>>>>> be4a4c3cccff89a821b2089d63baa3f82fc5226d
