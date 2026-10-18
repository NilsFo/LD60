class_name Magnetable
extends Area3D

@export var my_body:PhysicsBody3D
var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    gameState = $/root/Game/GameState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    
func attract_to_magnet(delta):
    
    
    var dir: Vector3 = (
            gameState.magnet.global_position - my_body.global_position
        ).normalized()
    dir = dir *gameState.magnet_strength*delta
    
    my_body.apply_central_impulse(dir)
