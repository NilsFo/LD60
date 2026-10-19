class_name LookArea
extends Area3D

signal rigidbody_enter(body: RigidBody3D)
signal rigidbody_leave(body: RigidBody3D)

@export var is_narrow:bool=false
@export var auto_turn_on:bool=false
@export var is_looking:bool=false
@export var lights: Array[Light3D]
@export var all_areas: Array[LookArea]
@onready var lightsSFX:AudioStreamPlayer=$LightsSFX
@onready var ambianceSFX:AudioFader=$AmbianceFader

var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)
    is_looking=false
    
    for a in all_areas:
        a.is_looking=false


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
        l.visible=is_looking

func _on_body_entered(body: Node3D) -> void:
    for a in all_areas:
        a.is_looking=false

    if body.name == "LookArea3D":
        print("Player looks at: "+name+" from: "+get_parent().name)
        is_looking=true
        
        if lightsSFX:
            lightsSFX.play()

func _on_body_exited(body: Node3D) -> void:
    if body.name == "LookArea3D":
        print("Player stoped looking at: "+name +"from: "+get_parent().name)
        
        if is_narrow:
            is_looking=false
        
