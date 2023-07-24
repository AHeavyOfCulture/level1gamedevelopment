extends Node

signal incrementscore

@export var player: Node3D
@export var enemyscene: PackedScene

@export var numberofenemies = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnenemies():
	print(numberofenemies)
	for i in range(numberofenemies):
		var newenemy = enemyscene.instantiate()
		newenemy.position = Vector3(randf_range(-100, 100), 50, randf_range(-100, 100))
		newenemy.enemyspawner = self
		newenemy.player = player
		add_child(newenemy)

func enemydied():
	incrementscore.emit()
	
