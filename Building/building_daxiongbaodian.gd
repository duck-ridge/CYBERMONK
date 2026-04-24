extends Node2D

@export var allow_occupied: bool = true
var is_occupied: bool = false
var occupied_monk: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuPanel.hide()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func monk_dragged_in(registered_monk: CharacterBody2D, specific_drop_pos: Vector2):
	if allow_occupied != true:
		return
	if is_occupied == true:
		return
	is_occupied = true
	
	occupied_monk = registered_monk
	if occupied_monk.get_parent():
		occupied_monk.get_parent().remove_child(registered_monk)
		add_child(registered_monk)
		registered_monk.visible = false
		registered_monk.position = Vector2.ZERO
		
		if "is_grabbed" in registered_monk:
			registered_monk.is_grabbed = false


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
