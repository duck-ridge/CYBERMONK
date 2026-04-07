extends Node2D
class_name BuildingPlaceHolder

@onready var Daxiongbaodian = preload("res://Building/building_daxiongbaodian.tscn")
@onready var Sengshe = preload("res://Building/building_sengshe.tscn")
@onready var Luohantang = preload("res://Building/building_luohantang.tscn")
# Called when the node enters the scene tree for the first time.
var allow_interact: bool = true

func _ready():
	$AniSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

			

func _on_click_area_input_event(viewport, event, shape_idx):
	get_viewport().set_input_as_handled()
	if allow_interact != true:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				show_menu()

			
var menu_tween: Tween

func show_menu():
	if allow_interact != true:
		return
		
	if menu_tween:
		menu_tween.kill()
	$MenuPanel.show()
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2.ONE, 0.5).from(Vector2(0, 1))
	
func hide_menu():
	if allow_interact != true:
		return
	if menu_tween:
		menu_tween.kill()
		
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2(0, 1), 0.5).from(Vector2.ONE)
	await menu_tween.finished
	if not menu_tween.is_valid(): 
		$MenuPanel.hide()
	$MenuPanel.hide()


enum hus_type {sengshe, daxiongbaodian, luohantang}
func _on_sengshe_btn_pressed():
	if allow_interact != true:
		return
	build_the_hus(hus_type.sengshe)
	hide_menu()
	
func _on_luohantang_btn_pressed():
	if allow_interact != true:
		return
	build_the_hus(hus_type.luohantang)
	hide_menu()

func _on_daxiongbaodian_btn_pressed():
	if allow_interact != true:
		return
	build_the_hus(hus_type.daxiongbaodian)
	hide_menu()
	
	
func build_the_hus(hus_code: int):
	if allow_interact != true:
		return
	var hus_inst
	match hus_code:
		hus_type.sengshe:
			hus_inst = Sengshe.instantiate()
		hus_type.daxiongbaodian:
			hus_inst = Daxiongbaodian.instantiate()
		hus_type.luohantang:
			hus_inst = Luohantang.instantiate()
		"_":
			return
	
	var world = get_node("../..")
	var building_system = world.get_node("BuildingSystem")
	
	var tween1 = create_tween()
	tween1.tween_property($AniSprite, "scale", Vector2.ZERO, 0.2)
	tween1.tween_callback($AniSprite.play.bind("working"))
	tween1.tween_property($AniSprite, "scale", Vector2.ONE, 0.2)
	await $AniSprite.animation_finished
	
	var tween2 = create_tween()
	tween2.tween_property($AniSprite, "scale", Vector2.ZERO, 0.2)
	await tween2.finished
	
	hus_inst.position = global_position
	hus_inst.scale = Vector2.ZERO
	building_system.add_child(hus_inst)
	
	var tween3 = create_tween()
	tween3.tween_property(hus_inst, "scale", Vector2.ONE, 0.2).from(Vector2.ZERO)
	await tween3.finished
	queue_free()



