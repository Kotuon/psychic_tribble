extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        print("Hit checkpoint.")
        if body.most_recent_checkpoint != self:
            $Effect.restart()
        body.most_recent_checkpoint = self
