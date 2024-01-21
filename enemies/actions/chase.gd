extends Ability

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    if is_running:
        parent.walk(delta, (parent.next_position - parent.global_position).normalized(), false)

func start() -> bool:
    if (!super.start()):
        return false

    parent.can_walk = true
    is_running = true

    return true

func end() -> void:
    super.end()
    is_running = false
