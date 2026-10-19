class_name GameState
extends Node3D

@export var playerJournal: Journal
@export var playerManuel: Journal
@export var playerLookArea:LookArea

@export var player_rotation: float=0.0
@export var magnet:Node3D
@export var magnet_active:bool=false
@export var magnet_strength:float=10.0

var is_player_hover_over_interactable
var request_spawn_on_next_look:bool=false

@export var spawn_pool_cache:String=""
@export var promotion_level: int = 0
### Stage 0: Tutorial Green
### Stage 1: Green Spawns
### Stage 2: Tutorial Blue
### Stage 3: Blue Spawns
### Stage 4: Tutorial Red
### Stage 5: Red Spawns
### Stage 6: Game Over
@export var stage: int = 0
@export var stage_promotions: Array[int] = [1,4,5,8,9,12,15]

### Phase 0: Start Screen
### Phase 1: Play
### Phase 2: Win
### Phase 3: Win_True
@export var gamephase: int = 0

signal phase_game_change(old: int, new: int)
signal phase_game_start()
signal phase_game_play()
signal phase_game_win()
signal phase_game_win_true()

var lights_count: int=0
@onready var scrap_spawner: ScrapSpawner = $/root/Game/ScrapSpawner

signal decomission_correct(reason: String)
signal decomission_incorrect(reason: String)
signal next_level(level: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gamephase = 0
    phase_game_change.emit(gamephase)
    phase_game_start.emit()
    magnet_active=false
    $NextLevelTimer.timeout.connect(_next_level)
    request_spawn_on_next_look=true
    
    if OS.has_feature("editor"):
        print("Running from Godot editor")
    else:
        print("Running as exported standalone game")
        Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) 

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

func play():
    gamephase = 1;
    phase_game_change.emit(gamephase)
    phase_game_play.emit()
    print("GAME ON!")

func win():
    gamephase = 2;
    phase_game_change.emit(gamephase)
    phase_game_win.emit()
    print("A WINNER IS YOU!")

func win_true():
    gamephase = 3;
    phase_game_change.emit(gamephase)
    phase_game_win_true.emit()
    print("A TRUE WINNER IS YOU!")

func report_decomission_correct(reason: String):
    print("Decomission correct! " + reason)
    decomission_correct.emit(reason)
    promotion_level+=1
    spawn_pool_cache="?"
    request_spawn_on_next_look=true
    
func report_decomission_incorrect(reason: String):
    print("Decomission incorrect! " + reason)
    spawn_pool_cache="?"
    decomission_incorrect.emit(reason)
    request_spawn_on_next_look=true

func on_look_area_entered(area:LookArea):
    playerLookArea=area
    print('GS: new area')
    
    if area.is_spawn_pipe:
        print('Pipe!')
        
        if request_spawn_on_next_look:
            $NextLevelTimer.start()
            request_spawn_on_next_look=false

func _input(event: InputEvent) -> void:
    if $CheatManager.cheat_mode:
        if event is InputEventKey:
            if event.pressed and event.keycode == KEY_N:
                print("Cheating to the next lvl")
                for c in $/root/Game/Scrap.get_children():
                    c.queue_free()
                report_decomission_correct("Cheating")
            if event.pressed and event.keycode == KEY_R:
                print("Cheating to the next lvl")
                for c in $/root/Game/Scrap.get_children():
                    c.queue_free()
                report_decomission_incorrect("Cheating")
