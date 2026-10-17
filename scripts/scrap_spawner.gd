extends Marker3D

@export var objekt_szene: PackedScene

func spawn() -> void:
    var obj := objekt_szene.instantiate()
    get_tree().current_scene.add_child(obj)
    obj.global_position = global_position
    obj.get_node("Roboter/Roboter/Armature/Skeleton3D/PhysicalBoneSimulator3D").physical_bones_start_simulation()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_spawn"):
        spawn()
