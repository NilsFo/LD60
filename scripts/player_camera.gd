extends Camera3D

var mousePos: Vector2=Vector2.ZERO

@export var lookLimitDegreeX: float=25.0
@export var invertX:bool=false
@export var lookLimitDegreeY: float=25.0
@export var invertY:bool=true

@export var wheel_step: float = 5.0        # Grad pro Mausrad-Klick
@export var hold_speed: float = 40.0       # Grad pro Sekunde beim Halten einer Taste
@export var min_fov: float = 20.0
@export var max_fov: float = 90.0
@export var smoothing: float = 10.0

var target_fov: float
var zoom_in_held := false
var zoom_out_held := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    target_fov = fov
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var dir := 0.0
    if zoom_in_held:
        dir -= 1.0
    if zoom_out_held:
        dir += 1.0
    target_fov = clamp(target_fov + dir * hold_speed * delta, min_fov, max_fov)

    fov = lerp(fov, target_fov, smoothing * delta)
    
    var screenResolution:Vector2= get_viewport().get_visible_rect().size
    var lookPercent: Vector2 = Vector2(
        (mousePos.x/screenResolution.x-0.5)*-2,
        (mousePos.y/screenResolution.y-0.5)*-2
    )
    
    if invertX:
        lookPercent.x=lookPercent.x*-1
    if invertY:
        lookPercent.y=lookPercent.y*-1
    
    rotation = Vector3(
        deg_to_rad(lookPercent.y*lookLimitDegreeY),
        deg_to_rad(lookPercent.x*lookLimitDegreeX),
        0
    )

func _input(event):
    # Mouse in viewport coordinates.
    if event is InputEventMouseButton:
        pass
        # print("Mouse Click/Unclick at: ", event.position)
    elif event is InputEventMouseMotion:
        # print("Mouse Motion at: ", event.position)
        mousePos=event.position
    
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        # Mausrad: schrittweise wie bisher
        if event.is_action_pressed("zoom_in"):
            target_fov -= wheel_step
        elif event.is_action_pressed("zoom_out"):
            target_fov += wheel_step
        target_fov = clamp(target_fov, min_fov, max_fov)
    else:
        # Tasten (oder Gamepad): Halte-Status merken
        if event.is_action_pressed("zoom_in"):
            zoom_in_held = true
        elif event.is_action_released("zoom_in"):
            zoom_in_held = false
        if event.is_action_pressed("zoom_out"):
            zoom_out_held = true
        elif event.is_action_released("zoom_out"):
            zoom_out_held = false

