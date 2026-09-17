extends CanvasLayer
## Shared HUD banner. Any level or puzzle can call UIManager.show_banner(...)
## instead of building its own popup label - keeps "DOF UNLOCKED" /
## "LEVEL COMPLETE" / interact-prompt text visually consistent everywhere.

var _label: Label
var _tween: Tween

func _ready() -> void:
	layer = 100
	_label = Label.new()
	_label.add_theme_font_size_override("font_size", 32)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_label.offset_left = -400
	_label.offset_right = 400
	_label.offset_top = 80
	_label.offset_bottom = 160
	_label.modulate.a = 0.0
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_child(_label)

func show_banner(text: String, hold_seconds: float = 2.5) -> void:
	_label.text = text
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_label, "modulate:a", 1.0, 0.3)
	_tween.tween_interval(hold_seconds)
	_tween.tween_property(_label, "modulate:a", 0.0, 0.5)
