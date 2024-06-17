extends Projectile

var target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    curr_lifetime -= delta
    if curr_lifetime <= 0.0:
        queue_free()

    if target != null:
        velocity = position.direction_to(target.position) * 10.0
        rotation = velocity.angle()

    move_and_collide(velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
    velocity = Vector2.ZERO
    if body is CharacterBase && !(body is Player):
        body.take_damage(1)
        queue_free()
