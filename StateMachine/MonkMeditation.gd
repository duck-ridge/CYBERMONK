extends State
class_name MonkIdle

@export var monk: CharacterBody2D
@export var move_speed:= 0


var wait_time: float
var animationSprite


func random_wait_time():
	wait_time = randf_range(1,3)

func _ready():
	animationSprite = get_node("../../Sprite")

#
	
func enter():
	meditation_play()
	random_wait_time()

func meditation_play():
	animationSprite.play("Meditation")


func physics_update(delta: float):
	if wait_time > 0:
		wait_time -= delta

	else:
		transitioned.emit(self, "monkwalk")

func exist():
	pass

func choose_target():
	pass
		
