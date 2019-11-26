extends Control

signal pressed(number)

func _ready():
    _connect_button($VBoxContainer/GridContainer/Button0)
    _connect_button($VBoxContainer/GridContainer/Button1)
    _connect_button($VBoxContainer/GridContainer/Button2)
    _connect_button($VBoxContainer/GridContainer/Button3)
    _connect_button($VBoxContainer/GridContainer/Button4)
    _connect_button($VBoxContainer/GridContainer/Button5)
    _connect_button($VBoxContainer/GridContainer2/Button6)
    _connect_button($VBoxContainer/GridContainer2/Button7)
    _connect_button($VBoxContainer/GridContainer2/Button8)
    _connect_button($VBoxContainer/GridContainer2/Button9)
    _connect_button($VBoxContainer/GridContainer2/Button10)

func _connect_button(button : Button) -> void:
    button.connect("pressed", self, "_on_button_pressed", [ button ])

func _on_button_pressed(source : Button) -> void:
    emit_signal("pressed", int(source.text), source.text)