extends Ability

@export var time_to_chase = 5.0
var counter : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    super._process(delta)
    
   # if parent.can_see_player:
    #    if parent.distance_from_player > 100:
   #         if start():
     #           parent.current_action = action_type

    if is_running:
        counter -= delta

        if counter <= 0.0:
            end()
            return

        parent.walk(delta, (parent.player.position - parent.position).normalized())

func start() -> bool:
    if (!super.start()):
        return false

    is_running = true
    counter = time_to_chase

    return true

func end() -> void:
    super.end()

    is_running = false
