extends TextureButton

var MuyuLevel: int = 1

@onready var wooden_muyu_normal = preload("res://Asset/Muyu/Wooden_normal.png")
@onready var silver_muyu_normal = preload("res://Asset/Muyu/Silver_normal.png")
@onready var golden_muyu_normal = preload("res://Asset/Muyu/Golden_normal.png")

@onready var wooden_muyu_hover = preload("res://Asset/Muyu/Wooden_hover.png")
@onready var silver_muyu_hover = preload("res://Asset/Muyu/Silver_hover.png")
@onready var golden_muyu_hover = preload("res://Asset/Muyu/Golden_hover.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	change_muyu_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_muyu_level():
	if MuyuLevel == 1:
		texture_normal = wooden_muyu_normal
		texture_hover = wooden_muyu_hover
	elif MuyuLevel == 2:
		texture_normal = silver_muyu_normal
		texture_hover = silver_muyu_hover
	elif MuyuLevel == 3:
		texture_normal = golden_muyu_normal
		texture_hover = golden_muyu_hover
func tap_muyu():
	if MuyuLevel == 1:
		Global.emit_signal("add_gongde", 1)
	elif MuyuLevel >= 2:
		Global.emit_signal("add_gongde", 10)
	$MuyuSound.play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.05, 0.05).from(Vector2.ONE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.05).from(Vector2.ONE * 1.05)
