extends State
class_name MonkPatrol

@export var monk: CharacterBody2D
@export var move_speed := 1.0 # 对应你之前的 += 1 逻辑

var move_to_right: bool
var wander_time: float
var animation_sprite: AnimatedSprite2D

func _ready():
	# 确保路径正确，获取父节点的父节点下的 Sprite
	animation_sprite = get_node("../../Sprite")

func enter():
	# 状态切换进入时，初始化随机方向和时间
	random_wander()
	if animation_sprite:
		animation_sprite.play("walk")

func random_wander():
	move_to_right = randf() > 0.5
	wander_time = randf_range(2, 5)
	update_sprite_flip()

func update_sprite_flip():
	if animation_sprite:
		# move_to_right 为 true 时不翻转（向右），为 false 时翻转（向左）
		animation_sprite.flip_h = !move_to_right

func physics_update(delta: float):
	# 1. 计时逻辑
	if wander_time > 0:
		wander_time -= delta
		
		# 2. 边界检查逻辑 (修复了你之前代码中 left/right 判断冲突的 Bug)
		check_boundary(200, 800)
		
		# 3. 位移逻辑 (维持你要求的 position 直接加减)
		if move_to_right:
			get_node("../..").position.x += move_speed
		else:
			get_node("../..").position.x -= move_speed
	else:
		transitioned.emit(self, "monkidle")

func check_boundary(left_boundary: float, right_boundary: float):
	# 获取 Monk 的当前 X 坐标
	var current_x = get_node("../..").position.x
	
	if current_x <= left_boundary:
		move_to_right = true
		update_sprite_flip()
	elif current_x >= right_boundary:
		move_to_right = false
		update_sprite_flip()
