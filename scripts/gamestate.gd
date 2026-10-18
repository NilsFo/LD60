class_name GameState
extends Node3D

@export var playerJournal: Journal
@export var playerManuel: Journal

@export var player_rotation: float=0.0
@export var magnet:Node3D
@export var magnet_active:bool=false
@export var magnet_strength:float=10.0

var is_player_hover_over_interactable

@export var promotion_level: int = 0
### Stage 0: Tutorial Green
### Stage 1: Green Spawns
### Stage 2: Tutorial Blue
### Stage 3: Blue Spawns
### Stage 4: Tutorial Red
### Stage 5: Red Spawns
### Stage 6: Game Over
@export var stage: int = 0
@export var stage1_promote: int = 3
@export var stage3_promote: int = 5
@export var stage5_promote: int = 8


@onready var scrap_spawner: ScrapSpawner = $/root/Game/ScrapSpawner

signal decomission_correct(reason: String)
signal decomission_incorrect(reason: String)
signal next_stage(level: int)
signal next_level(level: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    magnet_active=false
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    $NextLevelTimer.timeout.connect(_next_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func on_magnet_button_pressed():
    magnet_active=not magnet_active
    print("gamestate: magnet pressed. Magnet is now active: "+str(magnet_active))

func push_data_message(message):
    print("Data incoming: " + message)
    playerJournal.add_entry(message)

func _next_level():
    print("Next level")
    scrap_spawner.spawn()
    next_level.emit()

# promote up or down, respecting stages
func promote_mod(d: int):
    if d < 0:
        if stage == 0 or stage == 2 or stage == 4:
            # dont unpromote on tutorial
            return
    promotion_level += d
    if d > 0:
        # check for stage advances
        if promotion_level > stage5_promote and stage < 5:
            stage = 5
            next_stage.emit()
        if promotion_level > stage5_promote and stage < 4:
            stage = 4
            next_stage.emit()
        if promotion_level > stage3_promote and stage < 3:
            stage = 3
            next_stage.emit()
        if promotion_level > stage3_promote and stage < 2:
            stage = 2
            next_stage.emit()
        if promotion_level > stage1_promote and stage < 2:
            stage = 2
            next_stage.emit()
        if promotion_level > stage1_promote and stage < 1:
            stage = 1
            next_stage.emit()

func get_next_promote_threshold() -> int:
    if stage == 5:
        return -1
    if stage == 4:
        return stage5_promote
    if stage == 3:
        return stage5_promote
    if stage == 2:
        return stage3_promote
    if stage == 1:
        return stage3_promote
    if stage == 0:
        return stage1_promote
    
    return -1

func win():
    print("A WINNER IS YOU!")

func report_decomission_correct(reason: String):
    print("Decomission correct! " + reason)
    promote_mod(1)
    decomission_correct.emit(reason)
    $NextLevelTimer.start()
    
func report_decomission_incorrect(reason: String):
    print("Decomission incorrect! " + reason)
    promote_mod(-1)
    decomission_incorrect.emit(reason)
    $NextLevelTimer.start()
    
