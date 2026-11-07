extends Sprite2D

var _mouse_pos:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _mouse_pos = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var viewport_size: Vector2=get_viewport().get_visible_rect().size
    global_position=Vector2(
        int(_mouse_pos.x),
        int(_mouse_pos.y)
    )

func _input(event):
    # Mouse in viewport coordinates.
    if event is InputEventMouseButton:
        _mouse_pos=event.position
    elif event is InputEventMouseMotion:
        _mouse_pos=event.position

    # Print the size of the viewport.
    # print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)