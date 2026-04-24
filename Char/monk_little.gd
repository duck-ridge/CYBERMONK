extends CharacterBody2D
class_name MonkLittle


var is_grabbed: bool = false

var gravity = 980

enum MonkType {
	LITTLE,
	BIG,
	MASTER,
	VISITOR
}

var monk_code = MonkType.LITTLE

# Called when the node enters the scene tree for the first time.
func _ready():
	$StateMachine.ready_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func release_grab():
	is_grabbed = false
	Global.emit_signal("monk_drop_pos", get_global_mouse_position())


func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		#get_viewport().set_input_as_handled()
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				get_viewport().set_input_as_handled()
				is_grabbed = true
				Global.emit_signal("monk_grabbed", self)
			else:
				
				release_grab()
		if event.is_released():
			
			release_grab()


func _physics_process(delta):
	if is_grabbed:
		global_position = get_global_mouse_position()
		return

	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
