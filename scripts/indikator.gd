class_name Indikator
extends Node3D
## Ein visueller Indikator mit Blinker-Funktionalität
##
## `turn_on()` und `turn_off()` schalten den status um. `get_state()` zeigt den Status.
## Du kannst `blink()`, `blink_on()` und `blink_off()` benutzen um den Indikator 
## blinken zu lassen. Ruft bisher nur `hide()` und `show()` auf, aber `_turn_on()`
## und `_turn_off()` können überschrieben werden.

@export var initial_state: bool = true
var _state: bool = true
@export var blink_interval = 0.25

var _blink_tween: Tween

func _ready() -> void:
    if initial_state:
        _turn_on()
    else:
        _turn_off()

func turn_on():
    blink_stop()
    _turn_on()

func turn_off():
    blink_stop()
    _turn_off()

func _turn_on():
    _state = true
    show()

func _turn_off():
    _state = false
    hide()

func get_state():
    return _state

func blink(times: int = 3):
    if _blink_tween and _blink_tween.is_valid():
        _blink_tween.kill()
    _blink_tween = create_tween()
    _blink_tween.set_loops(times)
    if _state:
        _blink_tween.tween_callback(_turn_off)
        _blink_tween.tween_interval(blink_interval)
        _blink_tween.tween_callback(_turn_on)
        _blink_tween.tween_interval(blink_interval)
    else:
        _blink_tween.tween_callback(_turn_on)
        _blink_tween.tween_interval(blink_interval)
        _blink_tween.tween_callback(_turn_off)
        _blink_tween.tween_interval(blink_interval)
    _blink_tween.play()

func blink_on(times: int = 3):
    if _blink_tween and _blink_tween.is_valid():
        _blink_tween.kill()
    _blink_tween = create_tween()
    for i in range(times):
        _blink_tween.tween_callback(_turn_on)
        _blink_tween.tween_interval(blink_interval)
        _blink_tween.tween_callback(_turn_off)
        _blink_tween.tween_interval(blink_interval)
    _blink_tween.tween_callback(_turn_on)
    _blink_tween.play()
    
func blink_off(times: int = 3):
    if _blink_tween and _blink_tween.is_valid():
        _blink_tween.kill()
    _blink_tween = create_tween()
    for i in range(times):
        _blink_tween.tween_callback(_turn_off)
        _blink_tween.tween_interval(blink_interval)
        _blink_tween.tween_callback(_turn_on)
        _blink_tween.tween_interval(blink_interval)
    _blink_tween.tween_callback(_turn_off)
    _blink_tween.play()

func blink_stop():
    if _blink_tween and _blink_tween.is_valid():
        _blink_tween.kill()
    
