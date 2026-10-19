class_name LookArea
extends Area3D

signal rigidbody_enter(body: RigidBody3D)
signal rigidbody_leave(body: RigidBody3D)

@export var opposite_look_area:LookArea

@export var is_spawn_pipe:bool=false
@export var is_narrow:bool=false
@export var auto_turn_on:bool=false
@export var is_looking:bool=false
@export var lights: Array[Light3D]
@export var all_areas: Array[LookArea]
var lightsSFX:AudioStreamPlayer
var ambianceSFX:AudioFader
var gameState:GameState

var timer: float = 0.0

@export var spook_flicker:Array[Node3D]
@export var spook_decals:Array[Node3D]
@export var spook_robots_1:Array[Node3D]
@export var spook_robots_3:Array[Node3D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState
    
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)
    is_looking=false
    
    if all_areas:
        for a in all_areas:
            if a:
                a.is_looking=false

    unspook()

    lightsSFX=get_node_or_null("LightsSFX")
    ambianceSFX=get_node_or_null("AmbianceFader")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    timer+=delta
    if timer > 0.1 and auto_turn_on:
        for a in all_areas:
            a.is_looking=false
            
        auto_turn_on=false
        is_looking=true
        
    if ambianceSFX:
        if is_looking:
            ambianceSFX.play()
        else:
            ambianceSFX.stop()

    for l in lights:
        if l:
            l.visible=is_looking

func _on_body_entered(body: Node3D) -> void:
    for a in all_areas:
        a.is_looking=false

    if body.name == "LookArea3D":
        print("Player looks at: "+name+" from: "+get_parent().name)
        is_looking=true
        
        # we unspook opposite area to clean up
        if opposite_look_area:
            opposite_look_area.unspook()
            
        # then we roll to spook (again)
        gameState.on_look_area_entered(self)
        
        if lightsSFX:
            lightsSFX.play()

func _on_body_exited(body: Node3D) -> void:
    if body.name == "LookArea3D":
        print("Player stoped looking at: "+name +"from: "+get_parent().name)
        
        if is_narrow:
            is_looking=false

func spook():
    var spook_objects:Array[Node3D] = []
    
    if gameState.lights_count==0:
        spook_objects=[]
    elif gameState.lights_count==1:
        spook_objects=[gameState.crane_light]
    elif gameState.lights_count==2:
        spook_objects=spook_decals+spook_robots_1
        spook_objects.append(gameState.crane_light)
    elif gameState.lights_count==3:
        spook_objects=spook_decals+spook_robots_3
        spook_objects.append(gameState.crane_light)
    elif gameState.lights_count==4:
        spook_objects=spook_decals+spook_robots_3
    
    if spook_objects.size()!=0:
        var spook_node:Node3D = spook_objects.pick_random()
    
        if spook_node is LightFlicker:
            var flicker:LightFlicker=spook_node
            flicker.flicker_next=true
            print("PLAYER LIGHT CONNA FLICKER ANY SECOND NOW!")
        else:
            print("SPOOKY OBJECT NOW VISIBLE: "+str(spook_node.get_path()))
            spook_node.show()

func unspook():
    if gameState:
        if gameState.lights_count >=3:
            print('Not gonna unspook. Player is too far gone.')

    for n in (spook_decals):
        n.hide()
    for n in (spook_robots_1):
        n.hide()
    for n in (spook_robots_3):
        n.hide()
