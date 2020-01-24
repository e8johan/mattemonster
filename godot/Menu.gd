extends Control

signal play
signal settings
signal quit

func _ready() -> void:
    if OS.get_name() == "HTML5":
        $MarginContainer/VBoxContainer/ExitButton.visible = false
        
func _notification(what: int) -> void:
    if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST or what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        _on_ExitButton_pressed()

func _on_PlayButton_pressed():
    emit_signal("play")

func _on_ExitButton_pressed():
    emit_signal("quit")

func _on_SettingsButton_pressed():
    emit_signal("settings")
