class_name ScrapSpawner
extends Marker3D

@export var scrap_scenes: Dictionary[String,PackedScene] = {
    "d":preload("res://nodes/scraps/scrap_datablock.tscn"), #d (DATA)
    "s":preload("res://nodes/scraps/scrap_green_goo.tscn"), # s (SLIME)
    
    "r":preload("res://nodes/scraps/scrap_robot_deactivate.tscn"), #r (ROBOT)
    
    "m":preload("res://nodes/scraps/scrap_robot_blue.tscn"), # (ROBO BLUE)
    "n":preload("res://nodes/scraps/scrap_robot_greenblue.tscn"), #n (ROBO GREEN BLUE)
    
    "p":preload("res://nodes/scraps/scrap_robot_green.tscn"), #n (ROBO GREEN)
    "x":preload("res://nodes/scraps/scrap_robot_red.tscn"), #x (ROBO RED)
    "z":preload("res://nodes/scraps/scrap_robot_redblue.tscn"), #x (ROBO RED BLUE)
    
    "g":preload("res://nodes/scraps/scrap_gear.tscn"), #g (GEAR)
    "t":preload("res://nodes/scraps/scrap_torso.tscn"), #t (TORSO)
}

# SPAWN POOLS
@export var spanw_pools:Array[String]=[
    "g", #0 tutorial (gear)
    "s", #1 tutorial (slime)
    
    "gss", #2 # normal scrap
    "t", #3 (nromal torso)
    
    "d", #4 (DATA)
    
    "gst", #5 (normal scrap + torso)
    "r", #6 (robot)
    
    "d", #7 (DATA)
    
    "p", #8 (ROBO GREEN)
    
    "m", #9 (ROBOT DATA)
    "r", #10 (robots)
    "n", #11 (ROBOT DATA GREEN)
    
    "x", #12 (ROBOT RED)
    "m", #13 (ROBOT DATA)
    
    "d", #14 (DATA)
    "xrp", #15 (robots)
    
    
    "z", #16 (ROBO RED BLUE)
    "xrppp", #17 (robots)
    "z", #18 (ROBO RED BLUE)
    
    "sz", #19 (slime, green / ROBO RED BLUE)
    "sz", #20 (slime, green / ROBO RED BLUE)
    "s" #21 (slime, green / ROBO RED BLUE)
]

var game_state:GameState

func _ready() -> void:
    game_state = $/root/Game/GameState

func spawn() -> void:
    if game_state.gamephase!=1:
        print("Not the right phase, kiddo.")
        return

    var level: int = $/root/Game/GameState.promotion_level
    # var stage: int = $/root/Game/GameState.promotion_level
    
    # welchen pool nehmen wir?
    # var pool_scenes: Array[PackedScene] = []
    var pool:String = spanw_pools[game_state.promotion_level]
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
