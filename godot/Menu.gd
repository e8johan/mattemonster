extends Control

signal play
signal quit

func _ready() -> void:
    if OS.get_name() == "HTML5":
        $MarginContainer/VBoxContainer/ExitButton.visible = false

func _on_PlayButton_pressed():
    emit_signal("play")


func _on_ExitButton_pressed():
    emit_signal("quit")
