class_name LightFlicker
extends SpotLight3D

var flicker_code:String="mmamammmmammamamaaamammma"
var flicker_off:String="aaaaaaaaaaaaaaaaaaaaaaaaa"
@export var flicker_next:bool = true

var light_string_current:String

@export var read_speed: float=10
var timer:float=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    light_string_current=flicker_off
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    timer+=delta*read_speed
    
    var cursor: int=int(timer)
    if cursor == light_string_current.length():
        print("LIGHT RESTART")
        timer=0
        cursor=0
        
        light_string_current=flicker_off
        if flicker_next:
            light_string_current=flicker_code
            flicker_next=false
        
    var c: String = light_string_current[cursor]
    if c == "a":
        show()
    else:
        hide()