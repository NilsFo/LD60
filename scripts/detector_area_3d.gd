extends Area3D

signal rigidbody_enter(body: RigidBody3D)
signal rigidbody_leave(body: RigidBody3D)

@export var detections:Array[Magnetable] 
var gameState:GameState

func _ready() -> void:
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)
    
    gameState = $/root/Game/GameState
    
func _process(delta: float) -> void:
    if gameState.magnet_active:
        for d in detections:
            d.attract_to_magnet(delta)
            

func _on_body_entered(body: Node3D) -> void:
    if body is Magnetable:
        var m :Magnetable = body
        print("Magnetable enter")
        if body not in detections:
            detections.append(body)

func _on_body_exited(body: Node3D) -> void:
    if body is Magnetable:
        var m :Magnetable = body
        print("Magnetable leave")
        detections.remove_at(detections.find(body))
        