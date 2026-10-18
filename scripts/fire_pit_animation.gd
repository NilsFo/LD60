extends Node3D

@export var anim_player: AnimationPlayer
@export var anim_name: StringName = &"open"
@export var min_value: float = 2.0
@export var max_value: float = 5.0

var _in_range: bool = false
var gamestate :GameState

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
        anim_player.play(anim_name)
        anim_player.seek(anim_player.current_animation_length, true)

func _is_in_range() -> bool:
    return value >= min_value and value <= max_value

func _update_animation() -> void:
    var now_in_range := _is_in_range()
    if now_in_range == _in_range:
        return  # nothing changed, don't retrigger
    _in_range = now_in_range

    if _in_range:
        anim_player.play(anim_name)            # forward, once
    else:
        anim_player.play_backwards(anim_name)  # reverse, once
