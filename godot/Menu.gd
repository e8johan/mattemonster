extends Control

signal play
signal quit

func _ready() -> void:
    pass

func _on_PlayButton_pressed():
    emit_signal("play")


func _on_ExitButton_pressed():
    emit_signal("quit")
