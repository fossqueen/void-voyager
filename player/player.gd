extends RigidBody2D

var ship: Resource
export var points: PoolVector2Array
var buf_v: Vector2
var buf_v_length: float
var camera: Node

var reset_state: bool = false
var flight_assist: bool = true

const FUEL_EFFICIENCY: float = 0.0015
const FLIGHT_ASSIST_AMOUNT: float = 0.6

func _ready() -> void:
	set_variables()


func _draw() -> void:
	draw_colored_polygon(ship.points, ship.color_black)
	draw_polyline(ship.points, ship.color_white, ship.width, ship.antialiased)


func _integrate_forces(_state) -> void:
	movement()
	store_velocity()
	reset()


func _physics_process(_delta) -> void:
	look()


func _unhandled_input(event):
	if Input.is_action_just_pressed("toggle_system_map"):
		$UI.toggle_system_map()
	
	if Input.is_action_just_pressed("toggle_galaxy_map"):
		pass
	
	if Input.is_action_just_pressed("hyperspace"):
		$UI/Radar.remove_all_objects()
		reset_state = true
		Global.main.hyperspace()
		$UI/Radar.get_objects()
	
	if event.is_action("primary_fire"):
		$MiningLaser.is_casting = event.is_pressed()
	
	if Input.is_action_just_pressed("secondary_fire"):
		pass
	
	if Input.is_action_just_pressed("flight_assist"):
		toggle_flight_assist()
	
	if Input.is_action_just_pressed("ship_panel"):
		$UI.toggle_ship_panel()
	
	if Input.is_action_just_pressed("ui_home"):
		Global.save.player.inventory.add_item("poopball", 1)


func movement() -> void:
	if Input.is_action_pressed("thrust") and ship.fuel > 0:
		apply_impulse(Vector2(0, 0).rotated(rotation), Vector2(ship.speed, 0).rotated(rotation))
		$Animations/AnimationPlayer.play("thrust")
		burn_fuel(FUEL_EFFICIENCY)
		linear_damp =  -1
	else:
		$Animations/AnimationPlayer.play("idle")
		if flight_assist:
			linear_damp = FLIGHT_ASSIST_AMOUNT


func look() -> void:
	look_at(get_global_mouse_position())


func toggle_flight_assist() -> void:
	if flight_assist:
		flight_assist = false
	elif !flight_assist:
		flight_assist = true


func burn_fuel(amount: float) -> void:
	if ship.fuel > 0:
		ship.fuel -= amount


func store_velocity() -> void:
	buf_v = linear_velocity
	buf_v_length = buf_v.length()


func damage(amount: float) -> void:
	ship.health -= (amount / 10)
	if ship.health <= 0:
		destroy()


func destroy() -> void:
	print("Ship destroyed")
	queue_free()


func reset() -> void:
	if reset_state:
		set_deferred("mode", MODE_KINEMATIC)
		position = Vector2(0, 0)
		set_deferred("mode", MODE_RIGID)
		reset_state = false


func set_variables() -> void:
	Global.player = self
	$UI/Radar.player = self
	$UI/PlayerStats.player = self
	camera = $Camera
	Global.ui = $UI


# Signals
func _on_Player_body_entered(body):
	print("Player: Collision detected with %s" % body)
	body.damage(buf_v_length)
	damage(buf_v_length)


func _on_Scanner_body_entered(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.add_object(body)
	if body.is_in_group("npc"):
		$UI/Radar.add_object(body)


func _on_Scanner_body_exited(body):
	if body.is_in_group("radar_objects"):
		$UI/Radar.remove_object(body)
	if body.is_in_group("npc"):
		$UI/Radar.remove_object(body)
