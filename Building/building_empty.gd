extends Node2D
class_name BuildingPlaceHolder


var allow_interact: bool = true
#enum hus_set_type {MAIN, SIDE, OTHER}
enum hus_set_type {BASIC, MAIN, SIDE, OTHER}

func _ready():
	hide_menu()
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
				unfold_a_tween(hus_set_type.BASIC)
				

func hide_menu():
	for menu in $HusMenuSystem.get_children():
		if menu.visible == true:
			var tween = create_tween()
			tween.tween_property(menu, "scale", Vector2(0, 1), 0.2).from_current()
			await tween.finished
			menu.hide()
		menu.hide()
		menu.scale = Vector2(0, 1)


func unfold_a_tween(set_code: int):
	match set_code:
		hus_set_type.BASIC:
			$HusMenuSystem/HusMenuPanel.show()
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property($HusMenuSystem/HusMenuPanel, "scale", Vector2.ONE, 0.2).from(Vector2(0, 1))
		hus_set_type.MAIN:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property($HusMenuSystem/MainHusMenuPanel, "scale", Vector2.ONE, 0.2).from(Vector2(0, 1))
		hus_set_type.SIDE:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property($HusMenuSystem/SideHusMenuPanel, "scale", Vector2.ONE, 0.2).from(Vector2(0, 1))
		hus_set_type.OTHER:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property($HusMenuSystem/OtherHusMenuPanel, "scale", Vector2.ONE, 0.2).from(Vector2(0, 1))


func all_set_choice_able(allow_disabled: bool):
	for menu in $HusMenuSystem.get_children():
		var sub_node = menu.get_child(0)
		for choice in sub_node.get_children():
			choice.disabled = allow_disabled
	
func _on_main_set_pressed():
	all_set_choice_able(true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($HusMenuSystem/HusMenuPanel, "scale", Vector2(0, 1), 0.2).from(Vector2(1, 1))
	await get_tree().create_timer(0.2).timeout
	
	all_set_choice_able(false)
	$HusMenuSystem/HusMenuPanel.hide()
	$HusMenuSystem/MainHusMenuPanel.show()
	unfold_a_tween(hus_set_type.MAIN)


func _on_side_set_pressed():
	all_set_choice_able(true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($HusMenuSystem/HusMenuPanel, "scale", Vector2(0, 1), 0.2).from(Vector2(1, 1))
	await get_tree().create_timer(0.2).timeout
	
	all_set_choice_able(false)
	$HusMenuSystem/HusMenuPanel.hide()
	$HusMenuSystem/SideHusMenuPanel.show()
	unfold_a_tween(hus_set_type.SIDE)

func _on_other_pressed():
	all_set_choice_able(true)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($HusMenuSystem/HusMenuPanel, "scale", Vector2(0, 1), 0.2).from(Vector2(1, 1))
	await get_tree().create_timer(0.2).timeout
	
	all_set_choice_able(false)
	$HusMenuSystem/HusMenuPanel.hide()
	$HusMenuSystem/OtherHusMenuPanel.show()
	unfold_a_tween(hus_set_type.OTHER)
