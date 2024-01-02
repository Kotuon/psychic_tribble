extends Attack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func start() -> bool:
    if !super.start():
        return false

    if is_running:
        return false

    parent.can_walk = false
    is_running = true

    var direction = parent.get_animation_direction(parent.last_non_zero_input)

    parent.animation_player.play(direction + "_throw")
    play_sound(0.0)

    return true

func end() -> void:
    is_running = false
    parent.can_walk = true
    #parent.current_walk_speed = 0
    super.end()
