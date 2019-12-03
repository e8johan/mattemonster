extends Node2D

signal game_ended(seconds, total, wrong)

onready var questionLabel = $UI/VBoxContainer/QuestionLabel
onready var answerLabel = $UI/VBoxContainer/AnswerLabel
onready var timeLabel = $UI/VBoxContainer/MarginContainer/HBoxContainer/TimeLabel
onready var timeTimer = $Timer
onready var progressLabel = $UI/VBoxContainer/MarginContainer/HBoxContainer/ProgressLabel
onready var numberKeyboard = $UI/VBoxContainer/TabContainer/Keyboard
onready var compareKeyboard = $UI/VBoxContainer/TabContainer/CompareKeyboard
onready var keyboardSelector = $UI/VBoxContainer/TabContainer
onready var animationPlayer = $AnimationPlayer

var exercise : Object
var noOfExercises: int = 0
var wrongAnswers : int = 0

var timeStart: int = 0

var exercises = []

func _ready() -> void:
    $RightAudioPlayer.stream.loop = false
    $WrongAudioPlayer.stream.loop = false
    numberKeyboard.connect("pressed", self, "_on_keypress")
    compareKeyboard.connect("pressed", self, "_on_keypress")
    
func start_game() -> void:
    # Create random exercises
    for i in range(10):
        exercises.append(random_exercise_factory())

    # Start first game
    _start_game()
        
func _start_game() -> void:
    noOfExercises = len(exercises)
    wrongAnswers = 0
    timeStart = OS.get_unix_time()
    _update_time_label()
    timeTimer.start()
    _try_next_game()

func _try_next_game() -> bool:
    if len(exercises) == 0:
        return false
    else:
        var e = exercises[0]
        exercises.remove(0)
        _prepare_task(e)
        
        return true

func _prepare_task(e) -> void:
    progressLabel.text = str(noOfExercises - len(exercises)) + " / " + str(noOfExercises)
    answerLabel.text = "?"
    
    keyboardSelector.set_current_tab(e.keyboard_index())
    questionLabel.text = e.question_text()
    exercise = e

func _on_keypress(v : int, t : String) -> void:
    answerLabel.text = t
    if exercise.is_answer_correct(v, t):
        animationPlayer.play("right")
        yield(animationPlayer, "animation_finished")
        if not _try_next_game():
            timeTimer.stop()
            emit_signal("game_ended", OS.get_unix_time() - timeStart, noOfExercises, wrongAnswers) # seconds, total, wrong
    else:
        wrongAnswers += 1
        animationPlayer.play("wrong")
        yield(animationPlayer, "animation_finished")
        answerLabel.text = "?"

func _on_Timer_timeout() -> void:
    _update_time_label()

func _update_time_label() -> void:
    var elapsed : int = OS.get_unix_time() - timeStart
    var minutes : int = elapsed / 60
    var seconds : int = elapsed % 60
    timeLabel.text = "%02d:%02d" % [minutes, seconds]
    
func play_right() -> void:
	$RightAudioPlayer.play()
	
func play_wrong() -> void:
	$WrongAudioPlayer.play()

#interface Exercise:
#    func init_random() -> void
#    func keyboard_index() -> int:
#    func question_text() -> String:
#    func is_answer_correct(v : int, t : String) -> bool:

func random_exercise_factory() -> Object:
    var res
    var rng : = RandomNumberGenerator.new()
    rng.randomize()
    match rng.randi_range(0,10):
        0, 1, 2, 3, 4:
            res = ExerciseTenFriends.new()
        5, 6:
            res = ExerciseDouble.new()
        7, 8, 9, 10:
            res = ExerciseCompare.new()
    res.init_random()
    return res

class ExerciseTenFriends:
    var _v : int = 0
    var _f : bool = false
    
    func init(value : int, is_first : bool) -> void:
        _v = value
        _f = is_first
    
    func init_random() -> void:
        var rng : = RandomNumberGenerator.new()
        rng.randomize()
        self.init(rng.randi_range(0, 10), rng.randi_range(0, 1) == 0)
    
    func keyboard_index() -> int:
        return 0
    
    func question_text() -> String:
        if _f:
            return "_ + " + str(_v) + " = 10"
        else:
            return str(_v) + " + _ = 10"
    
    func is_answer_correct(v : int, t : String) -> bool:
        return (v == 10 - _v)

class ExerciseDouble:
    var _v : int = 0
    
    func init(value : int) -> void:
        _v = value
    
    func init_random() -> void:
        var rng : = RandomNumberGenerator.new()
        rng.randomize()
        self.init(rng.randi_range(1, 5))
    
    func keyboard_index() -> int:
        return 0
    
    func question_text() -> String:
        return str(_v) + " + " + str(_v)
    
    func is_answer_correct(v : int, t : String) -> bool:
        return (v == _v*2)

class ExerciseCompare:
    var _l : int = 0
    var _r : int = 0
    
    func init(left : int, right : int) -> void:
        _l = left
        _r = right
        
    func init_random() -> void:
        var rng : = RandomNumberGenerator.new()
        rng.randomize()
        self.init(rng.randi_range(0, 10), rng.randi_range(0, 10))
    
    func keyboard_index() -> int:
        return 1
    
    func question_text() -> String:
        return str(_l) + "  _  " + str(_r)
    
    func is_answer_correct(v : int, t : String) -> bool:
        if _l < _r:
            return (v == -1)
        elif _l == _r:
            return (v == 0)
        else:
            return (v == 1)
