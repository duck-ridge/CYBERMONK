extends TextureButton

@onready var have_monk_little = preload("res://Asset/Profile/LittleMK.png")
@onready var have_monk_big = preload("res://Asset/Profile/Occupied_inner.png")
@onready var no_occupied = preload("res://Asset/Profile/OuterEmpty.png")

var parent_building
var monk_code: int = 0

var is_occupied: bool = false:
	set(value):
		is_occupied = value
		if is_occupied != true:
			texture_normal = no_occupied
		check_texture(monk_code)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	check_texture(monk_code)
	parent_building = get_node("../../..")


func _on_pressed():
	if is_occupied == false:
		return
	is_occupied = false
	# self_order_in_parent_node
	var index = get_index()
	
	if parent_building:
		parent_building.is_contain_num -= 1
		parent_building.registered_monk_release(index)
	
func check_texture(monk_code: int):
	if is_occupied != true:
		texture_normal = no_occupied
	else:
		match monk_code:
			0:
				texture_normal = have_monk_little
			1:
				texture_normal = have_monk_big
		#texture_normal = have_monk_little
