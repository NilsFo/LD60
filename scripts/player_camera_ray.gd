
extends RayCast3D

@export var ray_length: float = 1000.0
var gameState:GameState

var _camera: Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState
    _camera=get_parent() as Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
    var mouse_pos = gameState.virtual_cursor.position

    # Convert mouse position into a 3D ray
    var ray_origin: Vector3 = _camera.project_ray_origin(mouse_pos)
    var ray_direction: Vector3 = _camera.project_ray_normal(mouse_pos)

    # Position the ray at its projected origin
    global_position = ray_origin

    # Convert the world-space endpoint into local coordinates
    target_position = to_local(ray_origin + ray_direction * ray_length)

    # Update collision detection immediately
    force_raycast_update()

    # debug
    # if is_colliding():
    #     var object: Object = get_collider()
    #     print("Hovering over: ", object.name)