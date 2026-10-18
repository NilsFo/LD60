class_name ScrapSpawner
extends Marker3D

@export var objekt_szene: PackedScene

@export var scrap_scenes: Array[PackedScene] = [
    preload("res://nodes/scraps/scrap_datablock.tscn"),
    preload("res://nodes/scraps/scrap_green_goo.tscn"),
    preload("res://nodes/scraps/scarp_robot.tscn"),
    preload("res://nodes/scraps/scrap_gear.tscn"),
]

func spawn() -> void:
    var level: int = $/root/Game/GameState.promotion_level
    var stage: int = $/root/Game/GameState.stage
    #TODO: decide what spawns when
    
    var szene = scrap_scenes.pick_random()
    var obj = szene.instantiate()
    get_tree().current_scene.add_child(obj)
    obj.global_position = global_position
    if obj.has_node("Roboter/Roboter/Armature/Skeleton3D/PhysicalBoneSimulator3D"):
        var skeleton = obj.get_node("Roboter/Roboter/Armature/Skeleton3D/PhysicalBoneSimulator3D")
        skeleton.physical_bones_start_simulation()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_spawn"):
        spawn()
