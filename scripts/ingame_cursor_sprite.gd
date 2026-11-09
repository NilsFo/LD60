extends Sprite2D

var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    global_position=Vector2(
        int(gameState.virtual_cursor.position.x),
        int(gameState.virtual_cursor.position.y)
    )
    