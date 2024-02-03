extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_body_entered(body: Node2D) -> void:
    if body.name != "player":
        return

    print("Entered arena.")

    for child in get_children():
        if child.has_method("enable_collision"):
            child.call_deferred("enable_collision")
            #child.collision_area.call_deffered("set_disabled", false)
