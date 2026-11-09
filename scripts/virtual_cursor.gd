class_name VirtualCursor
extends Node2D

var _mouse_pos:Vector2 = Vector2.ZERO
var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState
    _mouse_pos = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var viewport_size: Vector2=get_viewport().get_visible_rect().size
    if not gameState.gamepad_input_detector.is_gamepad_mode:
        global_position=Vector2(
            int(_mouse_pos.x),
            int(_mouse_pos.y)
        )
        # print("Viewport: "+str(viewport_size)+" - Mouse Pos: "+str(_mouse_pos))
        return
    
    # from now on we are in controller mode
    var joy_axis_left:Vector2=Vector2(
        Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
        Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
    )
    var joy_axis_right:Vector2=Vector2(
        Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
        Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
    )
    
    # print('L:'+str(joy_axis_left)+'. R:'+str(joy_axis_right))
    var joy_axis:Vector2=joy_axis_left
    if joy_axis_right.length_squared() > joy_axis_left.length_squared():
        joy_axis=joy_axis_right
        
    if joy_axis.length_squared() < 0.005:
        joy_axis=Vector2.ZERO
    
    var joy_axis_clamped: Vector2=joy_axis.clamp(Vector2(-0.75,-0.75),Vector2(0.75,0.75))
    # print(str(joy_axis)+" -> "+str(joy_axis_clamped))
    var viewport_pos: Vector2 = (joy_axis_clamped / 0.75 + Vector2.ONE) * 0.5 * viewport_size
    # print(viewport_pos)
    global_position=viewport_pos
    

func _input(event):
    # Mouse in viewport coordinates.
    if event is InputEventMouseButton:
        _mouse_pos=event.position
    elif event is InputEventMouseMotion:
        _mouse_pos=event.position

    # Print the size of the viewport.
    # print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)