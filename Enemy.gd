extends CharacterBody3D

var health = 100
var player: Node3D
var maxbullettime = 5
var bullettime = maxbullettime

var enemyspawner

@export var bulletscene: PackedScene

func _ready():
	pass

func _physics_process(delta):
	bullettime -= 0.1
	velocity = -basis.z * 5
	velocity.y = -10
	look_at(player.position)
	rotation.x = 0
	rotation.z = 0
	move_and_slide()
	if bullettime <0:
		print("fired")
		fire()
		bullettime = maxbullettime

func damage(amount):
	health -= amount
	if health <0:
		health = 0
		die()

func die():
	print("enemy dead")
	enemyspawner.enemydied()
	queue_free()
	
func fire():
	var newbullet = bulletscene.instantiate()
	newbullet.isfiredbyenemy = true
	add_child(newbullet)
	newbullet.look_at(player.position)
