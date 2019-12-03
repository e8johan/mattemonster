extends Control

signal back

onready var noOfExercisesLabel = $MarginContainer/VBoxContainer/HBoxContainer/NoOfExLabel
onready var tensToggle = $MarginContainer/VBoxContainer/TensToggle
onready var doublesToggle = $MarginContainer/VBoxContainer/DoublesToggle
onready var compareToggle = $MarginContainer/VBoxContainer/CompareToggle

var no_of_exercises : int = 0 setget _set_no_of_exercises
var exercise_tens : bool = true
var exercise_doubles : bool = true
var exercise_compare : bool = true

func _ready() -> void:
    var f = File.new()
    if f.file_exists("user://settings.save"):
        f.open("user://settings.save", File.READ)
        var noe = f.get_var()
        _set_no_of_exercises(noe)
        exercise_tens = f.get_var()
        exercise_doubles = f.get_var()
        exercise_compare = f.get_var()
        f.close()
    else:
        _set_no_of_exercises(10)
        exercise_tens = true
        exercise_doubles = true
        exercise_compare = true
    
    tensToggle.pressed = exercise_tens
    doublesToggle.pressed = exercise_doubles
    compareToggle.pressed = exercise_compare

func _set_no_of_exercises(noe : int) -> void:
    if noe < 1:
        noe = 1
    if noe > 99:
        noe = 99
    noOfExercisesLabel.text = str(noe)
    no_of_exercises = noe

func _on_MinusButton_pressed() -> void:
    _set_no_of_exercises(no_of_exercises - 1)

func _on_PlusButton_pressed() -> void:
    _set_no_of_exercises(no_of_exercises + 1)

func _on_BackButton_pressed() -> void:
    exercise_tens = tensToggle.pressed
    exercise_doubles = doublesToggle.pressed
    exercise_compare = compareToggle.pressed

    var f = File.new()
    f.open("user://settings.save", File.WRITE)
    f.store_var(no_of_exercises)
    f.store_var(exercise_tens)
    f.store_var(exercise_doubles)
    f.store_var(exercise_compare)
    f.close()

    emit_signal("back")

func _on_TensToggle_toggled(button_pressed):
    if not tensToggle.pressed and not doublesToggle.pressed and not compareToggle.pressed:
        tensToggle.pressed = true

func _on_DoublesToggle_toggled(button_pressed):
    if not tensToggle.pressed and not doublesToggle.pressed and not compareToggle.pressed:
        doublesToggle.pressed = true

func _on_CompareToggle_toggled(button_pressed):
    if not tensToggle.pressed and not doublesToggle.pressed and not compareToggle.pressed:
        compareToggle.pressed = true
        
func get_exercise_settings() -> Dictionary:
    return {'tens': exercise_tens, 'doubles': exercise_doubles, 'compare': exercise_compare}
