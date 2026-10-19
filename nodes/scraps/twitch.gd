extends PhysicalBoneSimulator3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    get_tree().create_timer(0.2).timeout.connect(twitch_bone)


func twitch_bone():
    get_tree().create_timer(randf()*2 + 0.2).timeout.connect(twitch_bone)
    if is_simulating_physics():
        var bone: PhysicalBone3D = get_children().pick_random()
        bone.apply_impulse(Vector3(randf(), randf(), randf()) * 2)
