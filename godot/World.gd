extends Node2D

signal game_ended(seconds, total, wrong)

onready var questionLabel = $UI/VBoxContainer/QuestionLabel
onready var answerLabel = $UI/VBoxContainer/AnswerLabel
onready var progressLabel = $UI/VBoxContainer/MarginContainer/HBoxContainer/ProgressLabel
onready var keyboard = $UI/VBoxContainer/Keyboard
onready var animationPlayer = $AnimationPlayer

var answer : int
var startLen : int
var wrongAnswers : int

var tasks_value = []
var tasks_is_double = []
var tasks_is_first = []

func _ready() -> void:
    $RightAudioPlayer.stream.loop = false
    $WrongAudioPlayer.stream.loop = false
    keyboard.connect("pressed", self, "_on_keypress")
    
func start_game() -> void:
    # Create tasks
    for i in range(11):
        tasks_value.append(i)
        tasks_is_double.append(false)
        tasks_is_first.append(true)
        tasks_value.append(i)
        tasks_is_double.append(false)
        tasks_is_first.append(false)
        if i <= 5 and i != 0:
            tasks_value.append(i)
            tasks_is_double.append(true)
            tasks_is_first.append(false)     # Don't care, but needed to keep indexes in line

    # Randomize task order
    var rng = RandomNumberGenerator.new()
    rng.randomize()
    for i in range(100):
        var r : int = rng.randi_range(0, len(tasks_value)-1)
        
        var v : int = tasks_value[r]
        var d : bool = tasks_is_double[r]
        var f : bool = tasks_is_first[r]
        
        tasks_value.remove(r)
        tasks_is_double.remove(r)
        tasks_is_first.remove(r)
        
        tasks_value.insert(0, v)
        tasks_is_double.insert(0, d)
        tasks_is_first.insert(0, f)

    # Start first game
    _start_game()
        
func _start_game() -> void:
    startLen = len(tasks_value)
    wrongAnswers = 0
    _try_next_game()

func _try_next_game() -> bool:
    if len(tasks_value) == 0:
        return false
    else:
        var v : int = tasks_value[0]
        var d : bool = tasks_is_double[0]
        var f : bool = tasks_is_first[0]
        
        tasks_value.remove(0)
        tasks_is_double.remove(0)
        tasks_is_first.remove(0)
        
        _prepare_task(v, d, f)
        
        return true

func _prepare_task(v: int, is_double: bool, is_first: bool) -> void:
    progressLabel.text = str(startLen - len(tasks_value) - 1) + " / " + str(startLen)    
    answerLabel.text = "?"
    
    if is_double:
        questionLabel.text = str(v) + " + " + str(v)
        answer = v*2
    else:
        if is_first:
            questionLabel.text = str(v) + " + _ = 10"
        else:
            questionLabel.text = "_ + " + str(v) + " = 10"
        answer = 10-v

func _on_keypress(v : int) -> void:
    answerLabel.text = str(v)
    if v == answer:
        animationPlayer.play("right")
        yield(animationPlayer, "animation_finished")
        if not _try_next_game():
            print("GAME ENDED")
            emit_signal("game_ended", 0, startLen, wrongAnswers) # seconds, total, wrong
    else:
        wrongAnswers += 1
        animationPlayer.play("wrong")
        yield(animationPlayer, "animation_finished")
        answerLabel.text = "?"

func play_right():
	$RightAudioPlayer.play()
	
func play_wrong():
	$WrongAudioPlayer.play()
