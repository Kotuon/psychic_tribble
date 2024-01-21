extends Attack

var chance = 50
var chance_change = 10
var chance_min = 20
var chance_max = 50

@onready var sprite = $Sprite2D

var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

    tween = get_tree().create_tween().set_loops()
    #add_child(tween)
    #tween.connect("loop_finished", self)
    tween.loop_finished.connect(loop_finished)
    tween.tween_method(set_shader_value, 0.0, 1.0, 1)
    tween.stop()

    stop_shader()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)

func update_hitbox_position(_direction: String) -> void:
    pass

func start() -> bool:
    if (!super.start()):
        return false

    attack_hitbox.disabled = false
    hit_enemies.clear()

    parent.animation_player.play("stomp")

    return true

func end() -> void:
    super.end()
    attack_hitbox.disabled = true
    parent.start_wait_timer()

func _on_attack_area_body_entered(_body: Node2D) -> void:
    pass

func play_ability_audio(start_time: float) -> void:
    ability_audioplayer.play(start_time)

func trigger_shader():
    sprite.material.set_shader_parameter("is_running", true)
    tween.stop()
    tween.play()

func stop_shader():
    sprite.material.set_shader_parameter("is_running", false)

func set_shader_value(value: float) -> void:
    sprite.material.set_shader_parameter("input_value", value)

func loop_finished(_loop_count: int) -> void:
    tween.stop()
