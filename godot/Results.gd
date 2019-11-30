extends Control

signal back

var questions : int = 0 setget _set_questions, _get_questions
var wrong : int = 0 setget _set_wrong, _get_wrong

var _questions : int = 0
var _wrong : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $MarginContainer/VBoxContainer/BackButton.connect("pressed", self, "_on_back")
    
func _on_back() -> void:
    emit_signal("back")

func _set_questions(q : int) -> void:
    _questions = q
    _update_texts()

func _get_questions() -> int:
    return _questions

func _set_wrong(w : int) -> void:
    _wrong = w
    _update_texts()
    
func _get_wrong() -> int:
    return _wrong
    
func _update_texts() -> void:
    var answers = _questions + _wrong
    
    if _wrong == 0:                    # All correct
        $MarginContainer/VBoxContainer/EncouragementLabel.text = tr("RESULT_1")
    else:
        var percentage : = (float(_wrong) / float(answers))
        if percentage <= 0.1:    # 90% correct
            $MarginContainer/VBoxContainer/EncouragementLabel.text = tr("RESULT_2")
        elif percentage <= 0.4:    # 60% correct
            $MarginContainer/VBoxContainer/EncouragementLabel.text = tr("RESULT_3")
        else:    # 40% correct
            $MarginContainer/VBoxContainer/EncouragementLabel.text = tr("RESULT_4")

    $MarginContainer/VBoxContainer/ResultsLabel.text = str(answers - _wrong) + " " + tr("RESULT_FROM") + " " + str(answers) + " " + tr("RESULT_RIGHT")
