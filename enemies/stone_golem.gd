extends Enemy

var has_triggered = false
var animation_playing = false
@export var has_spawned = false
@onready var spawn_audioplayer = $Spawn_AudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    sprite.frame = 80

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

    if !has_spawned || has_died:
        if distance_from_player <= 100 && has_triggered == false:
            trigger_spawn()
        if has_triggered && !animation_playing:
            var time = spawn_audioplayer.get_playback_position() + AudioServer.get_time_since_last_mix()
            time -= AudioServer.get_output_latency()
            if time >= 2.7:
                animation_player.play("spawn")
                player.camera.add_trauma(0.5)
                animation_playing = true
        return

    if !animation_player.is_playing():
        animation_player.play("idle")

func trigger_spawn() -> void:
    spawn_audioplayer.play()
    has_triggered = true
    player.camera.add_trauma(0.25)

func shake_player_camera():
    player.camera.add_trauma(1.0)

func kill() -> void:
    super.kill()
    animation_player.play("death")

func take_damage(damage: int) -> void:
    super.take_damage(damage)
    animation_player.play("hit")
