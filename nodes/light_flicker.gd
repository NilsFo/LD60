class_name LightFlicker
extends Light3D

@export var flicker_code:String="mmamammmmammamamaaamammma"
@export var flicker_off:String="aaaaaaaaaaaaaaaaaaaaaaaaa"
@export var flicker_next:bool = true

var light_string_current:String
var intensity_max: float

@export var read_speed: float=10
var timer:float=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    timer = randi_range(0,10)
    light_string_current=flicker_off
    
    intensity_max = light_energy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    timer+=delta*read_speed
    
    var cursor: int=int(timer)
    if cursor == light_string_current.length():
        timer=0
        cursor=0
        
        light_string_current=flicker_off
        if flicker_next:
            light_string_current=flicker_code
            flicker_next=false
        
    var c: String = light_string_current[cursor]
    var value = inverse_lerp(ord("z"), ord("a"), ord(c))
    light_energy = lerpf(0, intensity_max, value)
