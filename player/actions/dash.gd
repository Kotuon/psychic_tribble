extends Ability

@export var time_to_dash = 0.2
@export var dash_distance = 200

var dash_direction : Vector2
var time_since_dash_started = 0.0

@export var time_between_trail = 0.01
var trail_counter = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        time_since_dash_started += delta
        trail_counter -= delta

        if trail_counter <= 0.0:
            spawn_trail()
            trail_counter = time_between_trail

        parent.move_and_slide()

        if time_since_dash_started > time_to_dash:
            end()

func start() -> bool:
    if (!super.start()):
        return false

    dash_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if dash_direction.length_squared() == 0.0:
        dash_direction = parent.last_non_zero_input

    parent.can_walk = false
    is_running = true
    parent.set_can_take_damage(false)
    time_since_dash_started = 0.0

    parent.animation_player.play(parent.get_animation_direction(dash_direction) + "_dash")
    parent.velocity = dash_direction * (dash_distance / time_to_dash)
    play_sound(0.0)
    trail_counter = time_between_trail

    return true

func end() -> void:
    parent.can_walk = true
    is_running = false
    parent.set_can_take_damage(true)
    parent.current_walk_speed = parent.current_walk_speed * 2.0

    if parent.in_hazard:
        parent.kill()

    super.end()

func play_sound(start_position: float) -> void:
    if ability_audioplayer.is_playing():
        ability_audioplayer.stop()

    ability_audioplayer.stream = sound_effects[0]
    ability_audioplayer.play(start_position)

func spawn_trail():
    var this_trail = preload("res://player/dash_trail.tscn").instantiate()
    parent.get_parent().add_child(this_trail)
    this_trail.texture = parent.sprite.get_texture()
    this_trail.hframes = parent.sprite.hframes
    this_trail.vframes = parent.sprite.vframes
    this_trail.frame = parent.sprite.frame
    this_trail.position = parent.position
