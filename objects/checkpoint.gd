extends Node2D

@onready var audioplayer = $Checkpoint_AudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name == "player":
        if body.most_recent_checkpoint != self:
            print("Hit checkpoint.")
            $Effect.restart()
            audioplayer.play()
        body.most_recent_checkpoint = self
