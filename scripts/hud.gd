class_name Hud
extends CanvasLayer

signal start_game_button_pressed()

@export var main_menu: CanvasLayer
@export var game_menu: CanvasLayer

@export var debugLB:Label
@export var cursorNormal:Sprite2D
@export var cursorSelect:Sprite2D
var gameState:GameState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gameState = $/root/Game/GameState
    game_menu.visible = false
    main_menu.visible = true
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if gameState.gamephase == 0:
        game_menu.visible = false
        main_menu.visible = true
    else: 
        game_menu.visible = true
        main_menu.visible = false
        if gameState.is_player_hover_over_interactable:
            cursorSelect.show()
            cursorNormal.hide()
        else:
            cursorSelect.hide()
            cursorNormal.show()
            
        # debug label
        debugLB.text="PromLvl: "+str(gameState.promotion_level)+" - "+gameState.spawn_pool_cache+"\nLamps: "+str(gameState.lights_count)
    
func start_game():
    start_game_button_pressed.emit()
        
    
    
