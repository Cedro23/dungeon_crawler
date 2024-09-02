extends Label

var _rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_rng.randomize()

func display(amount: int, start_pos: Vector2, direction: Vector2, duration: float, is_crit: bool):
	z_index = 10
	text = str(amount) if amount > 0 else "Miss"
	
	
	position = start_pos
	var movement = direction / 2
	
	var tween = create_tween()
	tween.tween_property(self, "position", position + movement, duration/3 if is_crit else duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "label_settings:font_color:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if is_crit:
		modulate = Color.RED
		pivot_offset = size / 2
		tween.parallel().tween_property(self, "scale", scale * 2, duration/3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await tween.finished
	queue_free()
