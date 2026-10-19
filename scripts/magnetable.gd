class_name Magnetable
extends Area3D

@export var my_body:PhysicsBody3D
@export var falloff_distancemultiplier:float=1
var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    gameState = $/root/Game/GameState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
    
func attract_to_magnet(delta):
    var dist: float = my_body.global_position.distance_to(gameState.magnet.global_position)
    var distance_mult = min(1.0,(2.0/pow(dist,2)+0.3)*falloff_distancemultiplier)
    
    var dir: Vector3 = (gameState.magnet.global_position - my_body.global_position).normalized()
    var pulse = dir *gameState.magnet_strength*delta * distance_mult
    
    my_body.apply_central_impulse(pulse)
