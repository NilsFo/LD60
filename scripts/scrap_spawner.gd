class_name ScrapSpawner
extends Marker3D

@export var scrap_scenes: Dictionary[String,PackedScene] = {
    "d":preload("res://nodes/scraps/scrap_datablock.tscn"), #d (DATA)
    "s":preload("res://nodes/scraps/scrap_green_goo.tscn"), # s (SLIME)
    "r":preload("res://nodes/scraps/scrap_robot_deactivate.tscn"), #r (ROBOT)
    
    "m":preload("res://nodes/scraps/scrap_robot_blue.tscn"), # (ROBO BLUE)
    "n":preload("res://nodes/scraps/scrap_robot_greenblue.tscn"), #n (ROBO GREEN BLUE)
    "x":preload("res://nodes/scraps/scrap_robot_red.tscn"), #x (ROBO RED)
    "y":preload("res://nodes/scraps/scrap_robot_redblue.tscn"), #y (ROBO RED BLUE)
    
    "g":preload("res://nodes/scraps/scrap_gear.tscn"), #g (GEAR)
    "t":preload("res://nodes/scraps/scrap_torso.tscn"), #t (TORSO)
}

# SPAWN POOLS
@export var spawn_pool_0: String = "g" #0
@export var spawn_pool_1:String = "ggsst" #1
@export var spawn_pool_2:String = "d" #2
@export var spawn_pool_3:String = "gstddrmn" #3
@export var spawn_pool_4:String = "d" #4
@export var spawn_pool_5:String = "tmnxxyy" #5
@export var spawn_pool_6:String = "tmnxxyy" #6
@export var spawn_pool_7:String = "tmnxxyy" #7
@export var spawn_pool_8:String = "tmnxxyy" #8
@export var spawn_pool_9:String = "tmnxxyy" #9
@export var spawn_pool_10:String = "tmnxxyy" #10
@export var spawn_pool_11:String = "tmnxxyy" #11
@export var spawn_pool_12:String = "tmnxxyy" #12
@export var spawn_pool_13:String = "tmnxxyy" #13
@export var spawn_pool_14:String = "tmnxxyy" #14
@export var spawn_pool_15:String = "tmnxxyy" #15
@export var spawn_pool_16:String = "tmnxxyy" #16
@export var spawn_pool_17:String = "tmnxxyy" #17
@export var spawn_pool_18:String = "tmnxxyy" #18

var game_state:GameState

func _ready() -> void:
    game_state = $/root/Game/GameState

func spawn() -> void:
    var level: int = $/root/Game/GameState.promotion_level
    # var stage: int = $/root/Game/GameState.promotion_level
    
    # welchen pool nehmen wir?
    # var pool_scenes: Array[PackedScene] = []
    var pool:String = ""
    if game_state.stage == 0:
        pool=spawn_pool_0
    if game_state.stage == 1:
        pool=spawn_pool_1
    if game_state.stage == 2:
        pool=spawn_pool_2
    if game_state.stage == 3:
        pool=spawn_pool_3
    if game_state.stage == 4:
        pool=spawn_pool_4
    if game_state.stage == 5:
        pool=spawn_pool_5
    print("Selecting from pool: "+pool.capitalize())
    game_state.spawn_pool_cache=pool.capitalize()
    
    # alle scenen aus dem pool in die liste
    # for key in scrap_scenes.keys():
    #     if key in pool:
    #         pool_scenes.append(scrap_scenes[key])
    
    # zufällig wählen
    print("Scene candidate count: "+str(int(pool.length())))
    var random_char: String = pool[randi_range(0, pool.length() - 1)]
    var szene: PackedScene = scrap_scenes[random_char]
    print("Scene key picked: "+str(random_char))
    print("Scene picked: "+str(szene))
    
    var obj: Node = szene.instantiate()
    $/root/Game/Scrap.add_child(obj)
    obj.global_position = global_position
    if obj.has_node("Roboter/Armature/Skeleton3D/PhysicalBoneSimulator3D"):
        var skeleton: Node = obj.get_node("Roboter/Armature/Skeleton3D/PhysicalBoneSimulator3D")
        skeleton.physical_bones_start_simulation()

func _unhandled_input(event: InputEvent) -> void:
    pass
    # if event.is_action_pressed("debug_spawn"):
    #     spawn()
