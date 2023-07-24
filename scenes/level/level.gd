extends Node3D

@onready var ui = $CanvasLayer/Ui
@onready var warning: Label = $CanvasLayer/Menu/MarginContainer/VBoxContainer/Warning
@onready var enemyspawner: Node3D = $enemyspawner
@onready var menu: ColorRect = $CanvasLayer/Menu
@onready var health: Label = $CanvasLayer/Ui/Health
@onready var player = $Player
@onready var score: Label = $CanvasLayer/Ui/Score

# Called when the node enters the scene tree for the first time.
func _ready():
	score.text = "score: 0"
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	enemyspawner.incrementscore.connect(incrementscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health.text = "health: " + str(player.health)
	
func incrementscore():
	player.score += 1
	score.text = "score: " + str(player.score)


# Called when the user presses enter
func _on_line_edit_text_submitted(new_text: String):
	# Checks if the text the user entered is an integer because this number determines
	# how many enemies are spawned
	if new_text.is_valid_int():
		var number = int(new_text)
		# Checks is the number is a negative because we can't spawn a negative amount of enemies
		if number <0:
			warning.text = "Number is negative try again"
			warning.show()
			return
		
		# The number is valid and we pass the number to the spawner and unpause the game to start it
		enemyspawner.numberofenemies = number
		menu.hide()
		get_tree().paused = false
		ui.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		enemyspawner.spawnenemies()
	else:
		warning.text = "Not a valid number try again"
		warning.show()


func _on_exit_pressed():
	get_tree().quit()
