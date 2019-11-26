extends Control

signal pressed(number, text)

func _ready() -> void:
    $HBoxContainer/LessThanButton.connect("pressed", self, "_on_lt_pressed")
    $HBoxContainer/EqualsButton.connect("pressed", self, "_on_equal_pressed")
    $HBoxContainer/GreaterThanButton.connect("pressed", self, "_on_gt_pressed")
    
func _on_lt_pressed() -> void:
    emit_signal("pressed", -1, "<")

func _on_equal_pressed() -> void:
    emit_signal("pressed", 0, "=")

func _on_gt_pressed() -> void:
    emit_signal("pressed", 1, ">")