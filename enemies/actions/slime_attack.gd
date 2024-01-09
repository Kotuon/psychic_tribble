extends Attack

var jump_time : float
var is_jumping = false
var counter : float

var start_location : Vector2
var end_location : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        if is_jumping:
            counter += delta
            var t = counter / jump_time
            if (t > 1.0):
                is_jumping = false
                return

            var new_location = (1-t)*start_location + t*end_location
            parent.position = new_location

func start_jump_to_player(time_to_jump: float) -> void:
    jump_time = time_to_jump
    is_jumping = true
    start_location = parent.position
    end_location = parent.player.position
    counter = 0.0

func start() -> bool:
    if (!super.start()):
        return false

    if is_running:
        return false

    is_running = true

    var direction = parent.get_animation_direction((parent.player.position - parent.position).normalized())
    parent.animation_player.play(direction + "_attack")

    return true

func end() -> void:
    super.end()
    is_running = false
