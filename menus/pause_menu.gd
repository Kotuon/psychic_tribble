extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        print("PAUSING")
        if get_tree().paused:
            pause_game()
        else:
            unpause_game()

func pause_game():
    get_tree().paused = true
    show()

func unpause_game():
    hide()
    get_tree().paused = false
