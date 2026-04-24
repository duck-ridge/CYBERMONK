extends Node2D


var is_occupied: bool = false
var can_contain_num: int
var is_contain_num: int = 0
var occupied_monk: CharacterBody2D

#enum MonkType {
	#LITTLE,
	#BIG,
	#MASTER,
	#VISITOR
#}

func _ready():
	$MenuPanel.hide()
	can_contain_num = $PanelContainer/VBoxContainer.get_child_count()
	
	pass # Replace with function body.




func monk_dragged_in(registered_monk: CharacterBody2D, specific_drop_pos: Vector2):
	if is_occupied == true:
		return
	
	if is_contain_num > can_contain_num:
		is_occupied = true
		return
		
	is_contain_num += 1
	
	occupied_monk = registered_monk
	if occupied_monk.get_parent():
		occupied_monk.get_parent().remove_child(registered_monk)
		$MonkResidence.add_child(registered_monk)
		registered_monk.visible = false
		registered_monk.position = Vector2.ZERO
		
		if "is_grabbed" in registered_monk:
			registered_monk.is_grabbed = false
	
	refill_based_on_is_contain_num(is_contain_num)
	

func refill_based_on_is_contain_num(contain_num: int):
	var i = 0
	for c in $PanelContainer/VBoxContainer.get_children():
		i += 1
		
		if i <= contain_num:
			
			var char = $MonkResidence.get_child(i - 1)
			var monk_code
			print(char)
			print(monk_code)
			print(char.monk_code)
			match char.monk_code:
				0:
					monk_code = 0
				1:
					monk_code = 1
				"_":
					print("false: building sengshe")
			c.monk_code = monk_code
			c.is_occupied = true
		else:
			c.is_occupied = false
			
		

func _on_click_area_input_event(viewport, event, shape_idx):
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				show_menu()
			
var menu_tween: Tween

func show_menu():
	if menu_tween:
		menu_tween.kill()
	$MenuPanel.show()
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2.ONE, 0.5).from(Vector2(0, 1))
	
func hide_menu():
	if menu_tween:
		menu_tween.kill()
		
	menu_tween = create_tween()
	menu_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	menu_tween.tween_property($MenuPanel, "scale", Vector2(0, 1), 0.5).from(Vector2.ONE)
	await menu_tween.finished
	if not menu_tween.is_valid(): 
		$MenuPanel.hide()
	$MenuPanel.hide()

func registered_monk_release(index: int):
	var removed_monk = $MonkResidence.get_child(index)
	var world = get_node("../..")
	var monksystem = world.get_node("MonkSystem")
	if removed_monk.get_parent():
		removed_monk.get_parent().remove_child(removed_monk)
	monksystem.add_child(removed_monk)
	
	is_contain_num = $MonkResidence.get_child_count()
	refill_based_on_is_contain_num(is_contain_num)
	
	removed_monk.show()
	#world.get_node("MonkSystem").add_child(removing_monk)
	removed_monk.position = global_position + Vector2(0, -40)
	pass
