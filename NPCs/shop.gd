extends Sprite3D

var dialogues
var dialogueBox = load("res://GUIs/DialogueBox.tscn")

var items
var itemsTex = load("res://assets/shop/Edwards_products.png")
@onready var gui = $GUI
@onready var itemCont = $GUI/ShopBack/Items
@onready var quoteL : Label = $GUI/ShopBack/Quote
@onready var toolL : Label = $GUI/ShopBack/Tooltip
@onready var priceL : Label = $GUI/ShopBack/Price

func _ready() -> void:
	var file_access := FileAccess.open("res://Dialogues/test_dialogue.json", FileAccess.READ)
	var json_string := file_access.get_as_text()
	file_access.close()
	dialogues = JSON.parse_string(json_string).dialogues
	
	var ifile_access := FileAccess.open("res://NPCs/items.json", FileAccess.READ)
	var ijson_string := ifile_access.get_as_text()
	ifile_access.close()
	items = JSON.parse_string(ijson_string)
	for item in items:
		var button = create_item(item["id"])
		button.mouse_entered.connect(func(): set_fields(item["quote"], item["tooltip"], item["price"]))
		itemCont.add_child(button)
		

func create_item(textId: int) -> TextureButton:
	var button = TextureButton.new()
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	var texture = AtlasTexture.new()
	texture.atlas = itemsTex
	texture.region = Rect2(textId*80,0,80,170)  # Define the region from the atlas
	button.texture_normal = texture
	return button


func set_fields(quote: String,tooltip: String, price: int):
	quoteL.text = quote
	toolL.text = tooltip
	priceL.text = str(price) + " Ronds"

func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		var dial = dialogueBox.instantiate()
		dial.start_dialogue(dialogues, gui)
		get_tree().get_root().get_node("Node3D").add_child(dial)
