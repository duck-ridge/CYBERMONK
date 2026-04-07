extends Node2D

var registered_monk
var gongde_sum: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("monk_grabbed", register_monk)
	Global.connect("monk_drop_pos", drop_monk)
	Global.connect("add_gongde", update_gongde)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_gongde(gongde):
	gongde_sum += gongde
	$CanvasLayer/GongdeLabel.text = str(gongde_sum)
	
func check_through_buildings(pos):
	var b_pool: Array
	var dist_to_b: Array
	for b in $BuildingSystem.get_children():
		dist_to_b.append(pos.distance_to(b.get_global_position()))
		b_pool.append(b)
		
	var min_value: float = dist_to_b.min()
	var min_index = dist_to_b.find(min_value)
	
	if min_value < 60:
		b_pool[min_index].monk_dragged_in(registered_monk, pos)
	
func drop_monk(pos: Vector2):
	if registered_monk != null:
		check_through_buildings(pos)
		registered_monk = null

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				for b in $BuildingSystem.get_children():
					b.hide_menu()
				for b in $EmptyBuildingSystem.get_children():
					b.hide_menu()
var scroll_x
func _input(event):
	scroll_x = Input.get_axis("ui_left", "ui_right")
	
	
func _physics_process(delta):
	if scroll_x != 0:
		$CanvasLayer/HScrollBar.value += scroll_x
		$CanvasLayer/HScrollBar.emit_signal("scrolling")
func register_monk(monk):
	registered_monk = monk


func _on_muyu_button_pressed():
	$CanvasLayer/MuyuButton.tap_muyu()

func _on_lv_up_button_pressed():
	if $CanvasLayer/MuyuButton.MuyuLevel <3:
		$CanvasLayer/MuyuButton.MuyuLevel += 1
	if $CanvasLayer/MuyuButton.MuyuLevel >= 3:
		$CanvasLayer/MuyuButton/MuyuTimer.start()
	$CanvasLayer/MuyuButton.change_muyu_level()

func _on_muyu_timer_timeout():
	$CanvasLayer/MuyuButton.tap_muyu()
	
func _on_h_scroll_bar_scrolling():
	$Camera2D.offset.x = $CanvasLayer/HScrollBar.value * 10 + 576
