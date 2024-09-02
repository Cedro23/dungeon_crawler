extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display(amount: int, start_pos: Vector2, duration: float, spread: float, is_crit: bool):
	z_index = 10
	text = str(amount) if amount > 0 else "Miss"
	
	
	position = start_pos
	var movement = Vector2(0, -7).rotated(randf_range(-spread, spread))
	
	var tween = create_tween()
	tween.tween_property(self, "position", position + movement, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "label_settings:font_color:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if is_crit:
		modulate = Color.RED
		pivot_offset = size / 2
		tween.parallel().tween_property(self, "scale", scale * 2, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	await tween.finished
	queue_free()
