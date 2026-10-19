extends Node3D

@export var min_value: float = 2.0
@export var max_value: float = 5.0

@export var listOfGPUParticles: Array[GPUParticles3D]

var _in_range: bool = false
var gamestate: GameState

var value: float = 0.0:
    set(v):
        value = v
        _update_animation()

func set_value(newValue:float):
    value = newValue

func _process(delta):
    if gamestate: 
        value = gamestate.player_rotation

func _ready() -> void:
    gamestate = $/root/Game/GameState
    _in_range = _is_in_range()
    if _in_range:
        enable_emitter()
    else:
        disable_emitter()
        

func _is_in_range() -> bool:
    return value >= min_value and value <= max_value

func _update_animation() -> void:
    var now_in_range := _is_in_range()
    if now_in_range == _in_range:
        return  # nothing changed, don't retrigger
    _in_range = now_in_range

    if _in_range:
        enable_emitter()
    else:
        disable_emitter()

func enable_emitter():
    for particel in listOfGPUParticles:
        particel.emitting = true

func disable_emitter():
    for particel in listOfGPUParticles:
        particel.emitting = false
