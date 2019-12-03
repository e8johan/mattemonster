extends Control

signal play
signal settings
signal quit

func _ready() -> void:
    if OS.get_name() == "HTML5":
        $MarginContainer/VBoxContainer/ExitButton.visible = false

func _on_PlayButton_pressed():
    emit_signal("play")

func _on_ExitButton_pressed():
    emit_signal("quit")

func _on_SettingsButton_pressed():
    emit_signal("settings")
