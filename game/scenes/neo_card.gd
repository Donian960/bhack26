extends Node2D

var card_name
var image
var article

var stats = {"Views": 0,
"Scrabble": 0,
"Links": 0,
"Images": 0}

#======
var view_data
var image_data
var thumbnail
var external_links

var image_type

var scrabbler = {1: "aeilnorstu",
	2: "dg",
	3: "bcmp",
	4: "fhvwy",
	5: "k",
	8: "jx",
	10: "qz"}

#==========
var TextPositionWithImage = Vector2(24,313)
var TextHeightWithImage = Vector2(296,69)
var TextPositionWithoutImage = Vector2(27,107)
var TextHeightWithoutImage = Vector2(296, 278)

func _ready():
	get_random_article_sam()
	

func get_random_article_sam():
	
	$HTTPRequest4.request_completed.connect(data_returned_sam)
	$HTTPRequest4.request("https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnfilterredir=nonredirects&prop=revisions|pageviews|extlinks|pageimages|images|extracts&piprop=original&exsentences=1&rvprop=timestamp&explaintext&format=json")

func data_returned_sam(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	##print(json)
	var query = json["query"]
	var pages = query["pages"]
	
	for k in pages:
		var page = pages[k]
		if "title" in page.keys():
			card_name = page["title"]
		if "extract" in page.keys():
			article = page["extract"]
			
		if "pageviews" in page.keys():
			view_data = page["pageviews"]
		if "extlinks" in page.keys():
			external_links = len(page["extlinks"])
		
		var image_source = ""
		var hasimg = false
		if "images" in page.keys():
			image_data = page["images"]
			
		if "original" in page.keys():
			hasimg = true
			image_source = page["original"]["source"]
			$HTTPRequest6.request_completed.connect(image_returned_sam)
			$HTTPRequest6.request(image_source)
		else:
			hasimg = true
			image_source = "https://pixabay.com/api/?key=55028260-b7c632806cd0f9116fd53cc1c&q="+sanitise(card_name)+"&image_type=photo"
			$HTTPRequest.request_completed.connect(image_links_returned_pixabay_sam)
			$HTTPRequest.request(image_source)

func image_returned_sam(result, response_code, headers, body):
	#if result != HTTPRequest.RESULT_SUCCESS:
	#	push_error("Image couldn't be downloaded. Try a different image.")
	var failed = false
	if response_code == 400:
		failed = true
	if response_code == 301:
		for header in headers:
			if header.contains("Location"):
				print("REDIRECTING to " + header.lstrip("Location:"))
				$HTTPRequest6.request(header.lstrip("Location:"))
				failed = true
	if failed:
		set_card()
		return
	
	image = Image.new()
	
	var error = null

	if image_type in ["jpg", "jpeg", "JPG", "JPEG"]:
		error = image.load_jpg_from_buffer(body)
	elif image_type in ["png"]:
		error = image.load_png_from_buffer(body)
	elif image_type in ["svg"]:
		error = image.load_svg_from_buffer(body)
	else:
		print("unknown file type recieved")
		print(image_type)
	if error != OK:
		image = null
	set_card()

func image_links_returned_pixabay_sam(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var hits = json["hits"]
	if len(hits) > 0:
		var source = hits[0]["webformatURL"]
		$HTTPRequest2.request_completed.connect(image_returned_pixabay_sam)
		$HTTPRequest2.request(source)
	else:
		set_card()

func image_returned_pixabay_sam(result, response_code, headers, body):
	image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		print("fuckedUP")
	set_card()

func set_card():
	
	if image != null:
		var image_texture = ImageTexture.create_from_image(image)
		$ArticleImage/TextureRect.texture = image_texture

	$Title.text = card_name
	
	var avg = 0
	var sum = 0
	
	for date in view_data:
		if view_data[date] != null:
			avg += view_data[date]
		sum += 1
	
	stats["Views"] = int(avg / sum)
	
	for i in range(len(card_name)):
		for score in scrabbler:
			if card_name[i].to_lower() in scrabbler[score]:
				stats["Scrabble"] += score
				
	if image_data != null:
		stats["Images"] = len(image_data)
		
	if external_links == null:
		external_links = 0
	
	stats["Links"] = external_links
	
	var stattext = ""
	
	for stat in stats:
		stattext += stat
		stattext += ": "
		stattext += str(stats[stat])
		stattext += "\n"
	
	$Stats1.text = "Views: " + str(stats["Views"]) + "\nScrabble: " + str(stats["Scrabble"])
	$Stats2.text = "Links: " + str(stats["Links"]) + "\nImages: " + str(stats["Images"])
	$Article.text = article

func remove_markings(text: String):
	
	text.remove_chars("\n")
	text.remove_chars("\r")
	
	var openings = []
	var closings = []
	
	for i in range(len(text)):
		if text[i] == "<":
			openings.append(i)
		elif text[i] == ">":
			closings.append(i)
			
	var removed = 0
			
	for k in range(len(openings)):
		for i in range(openings[k], closings[k] + 1):
			text = text.erase(i - removed)
			removed += 1
	
	for i in range(len(text)):
		if text[0] not in "abcdefghijklmnopqrstuvwxuzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890":
			text.erase(0, 1)
		else:
			break
			
	return text
	
func sanitise(name):
	var cleaned = name.replace(" ","+")
	for char in name:
		if char not in "abcdefghijklmnopqrstuvwxuzABCDEFGHIJKLMNOPQRSTUVWXYZ":
			cleaned = cleaned.replace(char,"")
	return cleaned
	
