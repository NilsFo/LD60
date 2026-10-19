class_name Player
extends Node3D

@export var rotationSpeed: float=1.0
@onready var fader:AudioFader=$AudioFader
@onready var viewRay:RayCast3D=$PlayerCamera/RayCast3D
var gameState
var mouse_clicked: bool=false

var crane_button_force_target: float = 0.0
@export var crane_button_force_current:float=0.0
var mode_timer:float=0
@export var allButtons:Array[PlayerButton] 

@export var curve_accelaration:Curve 
@export var acceleration_speed: float=0.9
@export var curve_decelaration:Curve 
@export var deceleration_speed: float=2.1337

@export var promo_lamp_one: Node3D
@export var promo_lamp_two: Node3D
@export var promo_lamp_three: Node3D
@export var promo_lamp_four: Node3D
@export var promo_lamp_five: Node3D

signal promo_level_change()

@export var rad_scale: Node3D

var is_lamp_on: bool = false
@export var default_dauer: float = 3.0
@export var good_lamp: Node3D
@export var bad_lamp: Node3D

var base_color: Color
@export var good_color: Color
@export var bad_color: Color
@export var real_lamp: Light3D

signal play_sound_wrong_action()
signal play_sound_good_action()
signal play_sound_rad_warning()
signal play_sound_promo_sound()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    mode_timer=0
    mouse_clicked=false
    gameState = $/root/Game/GameState
    reset_buttons()

    set_rad_level(0.0)
    set_promo_level(0)

    curve_accelaration.bake()
    curve_decelaration.bake()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var rotation_current := crane_button_force_current
    var rotation_target := crane_button_force_target
    var is_accelerating: bool = (absf(rotation_target) > absf(rotation_current) and rotation_current * rotation_target >= 0.0)
    var speed: float = acceleration_speed if is_accelerating else deceleration_speed
    crane_button_force_current = move_toward(rotation_current,rotation_target, speed * delta)

    rotate(Vector3.UP, crane_button_force_current * rotationSpeed * delta)
    gameState.player_rotation = rotation.y
    
    if crane_button_force_current == 0.0:
        fader.stop()
    else:
        fader.play()
    
    # mode_timer+=delta
    # var curve:Curve
    # var speed:float
    # if crane_button_force_target==0:
    #     curve = curve_decelaration
    #     speed=acceleration_speed
    # else:
    #     curve = curve_accelaration
    #     speed=deceleration_speed
    # var c:float = curve.sample(min(mode_timer*speed,1))
    
    var valid_target: bool = false
    var focussed_button:PlayerButton = null
    
    if viewRay.is_colliding():
        var target: Object=viewRay.get_collider()
        if is_instance_of(target,PlayerButton):
            valid_target=true
            focussed_button=target
            
    gameState.is_player_hover_over_interactable=focussed_button!=null
        
    if mouse_clicked and valid_target:
        reset_buttons()
        focussed_button.press()
    
        if focussed_button.buttonType == PlayerButton.ButtonType.UNBEKANNT:
            pass
            print("UNBEKANNTER BUTTON GEDRÜCKT!!!")
        if focussed_button.buttonType == PlayerButton.ButtonType.START_LINKS:
            crane_button_force_target=-1.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.START_RECHTS:
            crane_button_force_target=1.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.STOP:
            crane_button_force_target=0.0
            mode_timer=0
        if focussed_button.buttonType == PlayerButton.ButtonType.MAGNET:
            print("mm")
            pass
            
    mouse_clicked = false
        
func reset_buttons():
    for button:PlayerButton in allButtons:
        button.is_pressed=false

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index ==MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
            mouse_clicked=true

@onready var promo_lamps: Array[Node] = [
    promo_lamp_one,
    promo_lamp_two,
    promo_lamp_three,
    promo_lamp_four,
    promo_lamp_five,
]

var _promo_level := 0
var _blink_tween: Tween

func set_promo_level(level: int) -> void:
    level = clampi(level, 0, promo_lamps.size())

    if _blink_tween and _blink_tween.is_valid():
        _blink_tween.kill()

    for i in promo_lamps.size():
        promo_lamps[i].visible = i < level

    if level > _promo_level:
        _blink(promo_lamps[level - 1])

    _promo_level = level
    promo_level_change.emit()

    if level > 0:
        play_sound_promo_sound.emit()


func _blink(lamp: CanvasItem, times: int = 4, interval: float = 0.25) -> void:
    _blink_tween = create_tween().set_loops(times)
    _blink_tween.tween_callback(lamp.hide)
    _blink_tween.tween_interval(interval)
    _blink_tween.tween_callback(lamp.show)
    _blink_tween.tween_interval(interval)

func set_rad_level(level:float):
    var is_bigger = level > rad_scale.scale.y
    rad_scale.scale = Vector3(rad_scale.scale.x, level, rad_scale.scale.z)
    if(is_bigger):
         play_sound_rad_warning.emit()

func trigger_good_lamp():
    if is_lamp_on: 
        return

    good_lamp.show()
    play_sound_good_action.emit()
    base_color = real_lamp.light_color
    real_lamp.light_color = good_color
    is_lamp_on = true

    await get_tree().create_timer(default_dauer).timeout

    good_lamp.hide()
    is_lamp_on = false
    real_lamp.light_color = base_color

func trigger_bad_lamp():
    if is_lamp_on: 
        return

    bad_lamp.show()
    play_sound_wrong_action.emit()
    base_color = real_lamp.light_color
    real_lamp.light_color = bad_color
    is_lamp_on = true

    await get_tree().create_timer(default_dauer).timeout

    bad_lamp.hide()
    is_lamp_on = false
    real_lamp.light_color = base_color

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_promo_three"):
        set_promo_level(4)
