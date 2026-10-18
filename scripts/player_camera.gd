extends Camera3D

var mousePos: Vector2=Vector2.ZERO

@export var lookLimitDegreeX: float=25.0
@export var invertX:bool=false
@export var lookLimitDegreeY: float=25.0
@export var invertY:bool=true

@export var wheel_step: float = 5.0        # Grad pro Mausrad-Klick
@export var hold_speed: float = 40.0       # Grad pro Sekunde beim Halten
@export var min_fov: float = 20.0
@export var max_fov: float = 90.0
@export var smoothing: float = 10.0

@export var return_delay: float = 1.0      # Sekunden ohne Eingabe, bevor es zurückgeht
@export var return_speed: float = 15.0     # Grad pro Sekunde zurück zum Standard

var default_fov: float
var target_fov: float
var zoom_in_held := false
var zoom_out_held := false
var idle_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    default_fov = fov
    target_fov = fov
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    _prosses_zoom(delta)
    
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

func _prosses_zoom(delta):
    var dir := 0.0
    if zoom_in_held:
        dir -= 1.0
    if zoom_out_held:
        dir += 1.0

    if dir != 0.0:
        target_fov = clamp(target_fov + dir * hold_speed * delta, min_fov, max_fov)
        idle_time = 0.0
    else:
        idle_time += delta
        if idle_time >= return_delay:
            target_fov = move_toward(target_fov, default_fov, return_speed * delta)

    fov = lerp(fov, target_fov, smoothing * delta)

func _input(event):
    # Mouse in viewport coordinates.
    if event is InputEventMouseButton:
        pass
        # print("Mouse Click/Unclick at: ", event.position)
    elif event is InputEventMouseMotion:
        # print("Mouse Motion at: ", event.position)
        mousePos=event.position

func _is_wheel(event: InputEvent) -> bool:
    return event is InputEventMouseButton and event.button_index in [
        MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN
    ]

func _unhandled_input(event: InputEvent) -> void:
    if _is_wheel(event):
        # Mausrad: schrittweise
        if event.is_action_pressed("zoom_in"):
            target_fov -= wheel_step
            idle_time = 0.0
        elif event.is_action_pressed("zoom_out"):
            target_fov += wheel_step
            idle_time = 0.0
        target_fov = clamp(target_fov, min_fov, max_fov)
    else:
        # Tasten / rechte Maustaste: Halte-Status merken
        if event.is_action_pressed("zoom_in"):
            zoom_in_held = true
        elif event.is_action_released("zoom_in"):
            zoom_in_held = false
        if event.is_action_pressed("zoom_out"):
            zoom_out_held = true
        elif event.is_action_released("zoom_out"):
            zoom_out_held = false
