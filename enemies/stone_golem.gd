extends Enemy

var has_triggered = false
var animation_playing = false
var started_combat = true
var is_waiting = false

@onready var wait_timer = $WaitTimer

@export var can_be_staggered = true
@export var time_to_ignore_hits : float = 1.0
@onready var stagger_timer = $StaggerTimer

@export var has_spawned = false
@onready var spawn_audioplayer = $Spawn_AudioPlayer

@onready var clap = $Attack_Clap
@onready var stomp = $Attack_Stomp
@onready var chase = $Chase

@onready var navigation = $NavigationAgent2D
var next_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    sprite.frame = 80
    stagger_timer.wait_time = time_to_ignore_hits

func _physics_process(delta: float) -> void:
    super._physics_process(delta)
    next_position = navigation.get_next_path_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

    if has_died:
        return

    if !has_spawned:
        if distance_from_player <= 150 && !has_triggered:
            trigger_spawn()
        if has_triggered && !animation_playing:
            spawn_golem()
        return

    face_player()

    navigation.target_position = player.global_position

    if started_combat:
        var result = false
        if !is_waiting:
            if current_action == -1:
                var rand_val = rng.randi_range(0, clap.chance + stomp.chance)
            
                if rand_val < clap.chance:
                    result = change_action(clap.action_id)
                    clap.chance = clampi(clap.chance - clap.chance_change, clap.chance_min, clap.chance_max)
                    stomp.chance = clampi(stomp.chance + stomp.chance_change, stomp.chance_min, stomp.chance_max)
                else:
                    result = change_action(chase.action_id)
                    stomp.chance = clampi(stomp.chance - stomp.chance_change, stomp.chance_min, stomp.chance_max)
                    clap.chance = clampi(clap.chance + clap.chance_change, clap.chance_min, clap.chance_max)

        if distance_from_player <= 60 && current_action == chase.action_id:
            chase.end()
            result = change_action(stomp.action_id)
        if !result:
            if !animation_player.is_playing():
                animation_player.play("idle")

func walk(delta: float, direction: Vector2, play_sound: bool = true) -> void:
    if direction.length_squared() > 0.0:
        last_non_zero_input = direction

    update_current_walk_speed(delta, direction)

    if !can_walk:
        return

    if velocity.normalized() == (direction.normalized() * -1.0):
        direction += (direction.orthogonal() * turn_speed)

    velocity = (velocity + (direction * turn_speed)).normalized() * current_walk_speed

    if current_walk_speed == 0.0:
        animation_player.play("idle")
    else:
        if play_sound:
            play_footstep_sound()
        animation_player.play("walk")
    move_and_slide()

func spawn_golem():
    var time = spawn_audioplayer.get_playback_position() + AudioServer.get_time_since_last_mix()
    time -= AudioServer.get_output_latency()
    if time >= 2.7:
        animation_player.play("spawn")
        player.camera.add_trauma(0.5)
        animation_playing = true

func face_player() -> void:
    var player_direction = player.position.x - position.x
    if player_direction < 0.0:
        sprite.flip_h = true
    else:
        sprite.flip_h = false

func trigger_spawn() -> void:
    spawn_audioplayer.play()
    has_triggered = true
    player.camera.add_trauma(0.25)

func shake_player_camera(amount: float):
    player.camera.add_trauma(amount)

func kill() -> void:
    super.kill()
    animation_player.play("death")

func take_damage(damage: int) -> void:
    if !started_combat || !has_spawned:
        return

    super.take_damage(damage)
    if can_be_staggered:
        animation_player.play("hit")
        start_stagger_timer()

func start_stagger_timer():
    can_be_staggered = false
    stagger_timer.start()

func _on_stagger_timer_timeout() -> void:
    can_be_staggered = true

func freeze_movement():
    can_walk = false

func unfreeze_movement():
    can_walk = true

func _on_wait_timer_timeout() -> void:
    is_waiting = false

func change_action(new_action: int) -> bool:
    var result = super.change_action(new_action)
    if result && new_action != chase.action_id:
        is_waiting = true

    return result

func start_wait_timer():
    wait_timer.set_wait_time( clampf(rng.randf_range(1.0, 5.0), 1.0, 5.0) )
    wait_timer.start()
