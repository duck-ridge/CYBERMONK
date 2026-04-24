extends PanelContainer

@onready var anisprite = $RollingMachine/AniSprite
@onready var rollingtimer = $RollingTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rolling_timer_timeout():
	anisprite.play("empty")


func _on_start_bn_pressed():
	anisprite.play("rolling")
	rollingtimer.start(3)

func _on_close_btn_pressed():
	Global.emit_signal("luohantang_panel", false)
