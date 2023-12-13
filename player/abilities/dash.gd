extends Ability

@export var time_to_dash = 0.2
@export var dash_distance = 200

var dash_direction : Vector2
var time_since_dash_started = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        update(delta)

func start() -> bool:
    if (!super.start()):
        return false

    dash_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if dash_direction.length_squared() == 0.0:
        return false

    parent.can_walk = false
    is_running = true
    parent.can_take_damage = false
    time_since_dash_started = 0.0

    parent.animation_player.play(parent.get_animation_direction(dash_direction) + "_dash")
    parent.velocity = dash_direction * (dash_distance / time_to_dash)

    return true

func update(delta: float) -> void:
    super.update(delta)
    time_since_dash_started += delta
    parent.move_and_slide()

    if time_since_dash_started > time_to_dash:
        end()
    
func end() -> void:
    super.end()

    parent.can_walk = true
    is_running = false
    parent.can_take_damage = true
    parent.velocity = Vector2.ZERO
    parent.current_walk_speed = 0.0

    if parent.in_hazard:
        parent.kill()
