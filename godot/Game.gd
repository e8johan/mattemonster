extends Node2D

enum { MENU, GAME }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $GameView.connect("game_ended", self, "_end_game")
    $Menu.connect("play", self, "_play")
    $Menu.connect("quit", self, "_quit")
    
    _show_view(MENU)

func _end_game(seconds : int, total : int, wrong : int) -> void:
    print("end game found")
    _show_view(MENU)
    
func _play() -> void:
    _show_view(GAME)

func _quit() -> void:
    get_tree().quit()

func _show_view(v) -> void:
    match v:
        MENU:
            $Menu.visible = true
            $GameView.visible = false
        GAME:
            $Menu.visible = false
            $GameView.visible = true
            $GameView.start_game()
    