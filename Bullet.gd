extends MeshInstance3D

var shoot = false
var lastposition = Vector3.ZERO
var isfiredbyenemy = false
var maxlifetime = 10
var lifetime = maxlifetime

const DAMAGE = 25
const SPEED = 2

func _ready():
	set_as_top_level(true)

func _physics_process(_delta):
	lifetime -= 0.1
	if lifetime <0:
		queue_free()
	position = position + (-basis.z * SPEED)
	var space_state = get_world_3d().direct_space_state
	var query_parameters = PhysicsRayQueryParameters3D.create(lastposition, position)
	var result = space_state.intersect_ray(query_parameters)
	if result:
		var entity = result.collider
		if isfiredbyenemy:
			if entity.is_in_group("Player"):
				entity.damage(DAMAGE)
		else:
			if entity.is_in_group("Enemy"):
				entity.damage(DAMAGE)
		#print("Hit at point: ", result.position)
		queue_free()
	
	lastposition = position
