class_name SpookManager
extends Node3D

var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    gameState = $/root/Game/GameState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func next_spook(area: LookArea):
    var arena_name: StringName=area.get_parent().name
    print('Rolling spook for area: '+arena_name)
    
    if roll_spook() or gameState.lights_count==4:
        print('SPOOKY THINGS HAPPENING IN: '+arena_name.to_upper())
        area.spook()

func roll_spook()->bool:
    var roll_max: int=6-gameState.lights_count
    roll_max = int((roll_max/3)+1)
    
    var roll: int = randi_range(0,roll_max)
    var roll_success: bool = roll==1
    print('Roll result: '+str(roll)+'/'+str(roll_max))
    return roll_success
