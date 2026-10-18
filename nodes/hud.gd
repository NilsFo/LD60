class_name Hud
extends CanvasLayer

@export var cursorNormal:Sprite2D
@export var cursorSelect:Sprite2D
var gameState:GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if gameState.is_player_hover_over_interactable:
        cursorSelect.show()
        cursorNormal.hide()
    else:
        cursorSelect.hide()
        cursorNormal.show()
        
    
    
