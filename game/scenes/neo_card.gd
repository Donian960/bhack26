extends Node2D

var card_name
var card_img

var stats = {"Views": 0,
"Scrabble": 0,
"Words": 0,
"Images": 0}

var view_data
var image_data
var thumbnail

var title

func _ready():
	get_random_article_sam()
	

func get_random_article_sam():
	
	$HTTPRequest4.request_completed.connect(data_returned_sam)
	$HTTPRequest4.request("https://en.wikipedia.org/w/api.php?action=query&generator=random&grnnamespace=0&grnfilterredir=nonredirects&prop=pageviews|images|pageimages&piprop=original&format=json")

func data_returned_sam(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	#print(json)
	var query = json["query"]
	var pages = query["pages"]
	
	var hasimg = false
	
	for k in pages:
		var page = pages[k]
		if "title" in page.keys():
			card_name = page["title"]
		if "pageviews" in page.keys():
			view_data = page["pageviews"]
		if "images" in page.keys():
			image_data = page["images"]
		if "original" in page.keys():
			
			hasimg = true
			
			var image_source = page["original"]["source"]
			#print(image_source)
			$HTTPRequest6.request_completed.connect(image_returned_sam)
			$HTTPRequest6.request(image_source)
			
	if hasimg == false:
		set_card()

func image_returned_sam(result, response_code, headers, body):
	#print(headers)
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
		
	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	card_img = ImageTexture.create_from_image(image)
	
	set_card()
	
func set_card():
	
	var scrabbler = {1: "aeilnorstu",
	2: "dg",
	3: "bcmp",
	4: "fhvwy",
	5: "k",
	8: "jx",
	10: "qz"}
	
	$ColorRect2/TextureRect.texture = card_img
	
	$RichTextLabel.text = card_name
	
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
				
	stats["Images"] = len(image_data)
	
	var stattext = ""
	
	for stat in stats:
		stattext += stat
		stattext += ": "
		stattext += str(stats[stat])
		stattext += "\n"
	
	$Label.text = stattext
