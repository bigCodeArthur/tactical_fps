class_name Player extends CharacterBody3D

var facing_wall: bool = false
var fall_timer : float = 0.0
var max_fall_time : int = 5000
var last_save_pos = position

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 5.0

@export var disable_gavity: bool = false

@export var lean_pivot : Node3D
@export var lean_amount : float = 0.5

@onready var head: Head = $LeanPivot/Head
@onready var lean_checker: Area3D = $LeanPivot/Head/LeanChecker
var lean_checker_timer: float = 10


func _physics_process(delta: float) -> void:
	var lean := 0.0
	var input_dir := Input.get_vector("left", "right", "forward", "backward")

	if Input.is_action_pressed("lean left"):
		if facing_wall: input_dir += Vector2.LEFT
		lean += lean_amount

	if Input.is_action_pressed("lean right"): 
		if facing_wall: input_dir += Vector2.RIGHT
		lean += -lean_amount

	
	lean_pivot.rotation.z = move_toward(lean_pivot.rotation.z, lean, 0.05)
	if abs(lean_pivot.rotation.z) == lean_amount: lean_checker.monitoring = false
	else: lean_checker.monitoring = true

	if not is_on_floor(): 
		velocity += get_gravity() * delta
		if not fall_timer: fall_timer = Time.get_ticks_msec()
		if Time.get_ticks_msec() - fall_timer > max_fall_time:
			position = last_save_pos
			fall_timer = 0.0
	else:
		last_save_pos = position
		fall_timer = 0.0

	if disable_gavity: 
		velocity *= Vector3(1, 0, 1)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_area_3d_body_entered(_body: Node3D) -> void: facing_wall = true
func _on_area_3d_body_exited(_body: Node3D) -> void: facing_wall = false
