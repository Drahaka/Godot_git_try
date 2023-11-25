extends Node3D
var movement = Vector3()
var can_jump = false
var side_move
var jump_str
var bunny_pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	jump_str = 0
	bunny_pos.resize(10)
	bunny_pos.fill(Vector3(0,0,0))

func _physics_process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bunny_pos.insert(0,$RigidBody3D.global_transform.origin)
	
	$bunny_merged.position = $RigidBody3D.position
	$Camera3D.position = $bunny_merged.position + Vector3(60,0,0)
	$Camera3D.position = bunny_pos[9] + Vector3(60,0,0)
	jump_str = clamp(jump_str,0,45)
	jump_str += Input.get_action_strength("ui_accept")
	side_move = Input.get_action_strength("ui_left")-Input.get_action_strength("ui_right")
	if side_move != 0:$bunny_merged.scale.z = -side_move
	#$bunny_merged.look_at(Vector3(0,$bunny_merged.position.y,$bunny_merged.position.z + side_move))
	if Input.is_action_pressed("ui_accept") and can_jump:$AnimationTree.set("parameters/BlendSpace2D/blend_position",Vector2(jump_str/46,jump_str/46))
	if Input.is_action_just_released("ui_accept") and can_jump:
		$RigidBody3D.apply_impulse(Vector3(0,jump_str*50,side_move*jump_str*25))
		jump_str = 0
	if bunny_pos.size()>10:
		bunny_pos.remove_at(10)
	print(jump_str)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Floors"):
		can_jump = true
		$AnimationTree.set("parameters/BlendSpace2D/blend_position",Vector2(0,0))
		side_move = 0

func _on_area_3d_body_exited(body):
	if body.is_in_group("Floors"):
		can_jump = false
		$AnimationTree.set("parameters/BlendSpace2D/blend_position",Vector2(1,-1))
