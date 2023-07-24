extends CharacterBody3D

var speed = 10

var health = 200
var score = 0

var walkspeed = 10
var crouchspeed = 5
var sprintspeed = 15

var truespeed = walkspeed

var iscrouching = false

var horizontal_acceleration = 6
var air_acceleration = 2
var normal_acceleration = 12
var gravity = 20
var jump = 10
var full_contact = false

var bulletdamage = 25

var timer = 0.08
var timermax = 0.08

var mouse_sensitivity = 0.03

var direction = Vector3()
var horizontal_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

@onready var head = $Head
@onready var muzzle = $Head/Gun/Muzzle
@onready var bullet = preload("res://scenes/player/bullet.tscn")
@onready var gun: Node3D = $Head/Gun
@onready var targetgunposition = gun.position


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		gun.position.x -= event.relative.x * 0.0005
		gun.position.y += event.relative.y * 0.0005

func _physics_process(_delta):
	
	gun.position = gun.position.lerp(targetgunposition, 0.3)
	
	if is_on_ceiling():
		gravity_vec = Vector3.ZERO
		
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * _delta
		horizontal_acceleration = air_acceleration
	else:
		gravity_vec = -get_floor_normal()
		horizontal_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_just_pressed("crouch"):
		if iscrouching == false:
			movementStateChange("crouch")
			truespeed = crouchspeed
	
	if Input.is_action_just_released("crouch"):
		if iscrouching == true:
			movementStateChange("uncrouch")
			truespeed = walkspeed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("sprint"):
		if iscrouching == false:
			truespeed = sprintspeed
	
	elif Input.is_action_just_released("sprint"): 
		if iscrouching == false:
			truespeed = walkspeed
	
	horizontal_velocity = horizontal_velocity.lerp(direction * truespeed, horizontal_acceleration * _delta)
	movement.z = horizontal_velocity.z + gravity_vec.z
	movement.x = horizontal_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	timer -= 0.01
	
	if Input.is_action_pressed("fire") and timer <0:
		$AnimationPlayer.play("fire")
		var b = bullet.instantiate()
		muzzle.add_child(b)
		b.shoot = true
		timer = timermax
	
	velocity = movement
	
	move_and_slide()

func damage(amount):
	health -= amount
	if health <0:
		health = 0
		die()

func die():
	print("dead")

func movementStateChange(changetype):
	match changetype:
		"crouch":
			$AnimationPlayer.play("standingtocrouch")
			changeCollisionShape("crouching")
			iscrouching = true
		
		"uncrouch":
			$AnimationPlayer.play_backwards("standingtocrouch")
			changeCollisionShape("standing")
			iscrouching = false

func changeCollisionShape(shape):
	match shape:
		"crouching":
			$CrouchCollisionShape3D.disabled = false
			$CollisionShape3D.disabled = true
			
		"standing":
			$CrouchCollisionShape3D.disabled = true
			$CollisionShape3D.disabled = false
