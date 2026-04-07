extends Node2D

var registered_monk
var gongde_sum: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("monk_grabbed", register_monk)
	Global.connect("monk_drop_pos", drop_monk)
	Global.connect("add_gongde", update_gongde)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false)
	DisplayServer.window_set_flag(6, true)
	_align_window_to_bottom.call_deferred()

	_align_window_to_bottom()
	_fit_to_bottom_width.call_deferred()
	
func _fit_to_bottom_width():
	# 获取当前显示器索引
	var screen = DisplayServer.window_get_current_screen()
	
	# 获取显示器的可用区域（排除任务栏后的矩形）
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	
	# 获取当前窗口设定的高度（保持你原始设计的 1052 比例下的高度）
	# 假设你在项目设置里定的窗口高度是 200
	var original_height = DisplayServer.window_get_size().y
	
	# 计算新窗口大小：宽度设为屏幕全宽，高度保持不变
	var new_size = Vector2i(screen_rect.size.x, original_height)
	DisplayServer.window_set_size(new_size)
	
	# 计算新位置：X 轴从屏幕最左边开始(0)，Y 轴贴紧可用区域底部
	var target_x = screen_rect.position.x
	var target_y = screen_rect.position.y + (screen_rect.size.y - original_height)
	
	DisplayServer.window_set_position(Vector2i(target_x, target_y))

	# 3. 重要：如果你开启了点击穿透，需要覆盖整条底部
	# 否则玩家只能点到宠物，点不到宠物旁边的空白透明处
	_set_click_through(new_size)
	
func _set_click_through(size: Vector2i):
	# 方案 A：让整个底部窗口都能接收点击（会挡住桌面图标）
	# var area = PackedVector2Array([Vector2(0,0), Vector2(size.x,0), Vector2(size.x,size.y), Vector2(0,size.y)])
	
	# 方案 B (推荐)：全穿透。这样你点透明的地方会点到桌面。
	# 然后你需要在宠物节点（Sprite）上单独处理点击逻辑。
	var empty_area = PackedVector2Array() 
	DisplayServer.window_set_mouse_passthrough(empty_area)
	
	# 注意：如果你希望只有宠物能被点到，你需要在这里传入宠物图片的四个角坐标。
func _align_window_to_bottom():
	# 获取当前屏幕索引
	var screen = DisplayServer.window_get_current_screen()
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var window_size = DisplayServer.window_get_size()
	var target_x = screen_rect.position.x + (screen_rect.size.x - window_size.x) / 2
	var target_y = screen_rect.position.y + (screen_rect.size.y - window_size.y)
	
	DisplayServer.window_set_position(Vector2i(target_x, target_y))
	
	
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
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
		
var scroll_x: float
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
