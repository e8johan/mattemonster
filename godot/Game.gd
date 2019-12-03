extends Node2D

enum { MENU, GAME, RESULT }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $GameView.connect("game_ended", self, "_end_game")
    $Menu.connect("play", self, "_play")
    $Menu.connect("quit", self, "_quit")
    $Results.connect("back", self, "_back_to_menu")
    
    _show_view(MENU)

func _end_game(elapsedSeconds : int, total : int, wrong : int) -> void:
    $Results.questions = total
    $Results.wrong = wrong
    $Results.elapsed_seconds = elapsedSeconds

    _show_view(RESULT)

func _back_to_menu() -> void:
    _show_view(MENU)

func _play() -> void:
    _show_view(GAME)

func _quit() -> void:
    get_tree().quit()

func _show_view(v) -> void:
    $GameView.visible = false
    $Menu.visible = false
    $Results.visible = false
    
    match v:
        MENU:
            $Menu.visible = true
        GAME:
            $GameView.visible = true
            $GameView.start_game()
        RESULT:
            $Results.visible = true
    