extends Node2D

var center = Vector2(0, 0)
export var radius = 16
var start_angle = 0
var end_angle = deg2rad(360)
var point_count = 32
export var color: Color = Color(1.0, 1.0, 1.0)
var width = 1
var antialiased = 0
export var player: bool = false
export var npc: bool = false
var node

func _draw():
	if player or npc:
		var points = PoolVector2Array([Vector2(5, 0), Vector2(-3, -4), Vector2(-3, 4), Vector2(5, 0)])
		draw_colored_polygon(points, Color(0, 0, 0))
		draw_polyline(points, color, width, antialiased)
	else:
		draw_circle(center, radius, color)
		draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialiased)

func _physics_process(_delta):
	if npc:
		if not is_instance_valid(node):
			queue_free()
		else:
			global_rotation = node.global_rotation
