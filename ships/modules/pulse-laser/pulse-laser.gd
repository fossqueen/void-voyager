extends Area2D

export var color: Color = Color(1, 1, 1, 1)
export var length: int = 32
export var damage: int = 100
export var speed: int = 100

const PROJECTILE_SPEED: int = 6000

func _process(delta):
	position += Vector2(1, 0).rotated(rotation) * PROJECTILE_SPEED * delta

func _on_Timer_timeout():
	queue_free()

func _draw():
	draw_line(Vector2(0,0), Vector2(length, 0), color, 1, false)

func _on_Laser_body_entered(body):
	body.damage(damage)
	queue_free()
