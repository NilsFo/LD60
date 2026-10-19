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
@onready var spook_manager: SpookManager = $/root/Game/LookAreas/SpookManager

signal decomission_correct(reason: String)
signal decomission_incorrect(reason: String)
signal next_level(level: int)
signal lights_count_changed(lights_count: int)

signal magnet_activate
signal magnet_deactivate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gamephase = 0
    phase_game_change.emit(gamephase)
    phase_game_start.emit()
    magnet_active=false
    $NextLevelTimer.timeout.connect(_next_level)
    request_spawn_on_next_look=true
    
    update_crane_lights()
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func on_magnet_button_pressed():
    magnet_active=not magnet_active
    if magnet_active:
        magnet_activate.emit()
    else:
        magnet_deactivate.emit()
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
    
    if OS.has_feature("editor"):
        print("Running from Godot editor")
    else:
        print("Running as exported standalone game")
        Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN) 

func win():
    print("A WINNER IS YOU!")
    gamephase = 2;
    phase_game_change.emit(gamephase)
    phase_game_win.emit()
    
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

func win_true():
    print("A TRUE WINNER IS YOU!")
    gamephase = 3;
    phase_game_change.emit(gamephase)
    phase_game_win_true.emit()
    
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

func report_decomission_correct(reason: String):
    print("Decomission correct! " + reason)
    promotion_level+=1
    spawn_pool_cache="?"
    update_crane_lights()
    request_spawn_on_next_look=true
    await get_tree().create_timer(1.).timeout
    decomission_correct.emit(reason)
    
func update_crane_lights():
    if promotion_level < 4:
        lights_count=0
    elif promotion_level < 8:
        lights_count=1
    elif promotion_level < 12:
        lights_count=2
    elif promotion_level < 15:
        lights_count=3
    elif promotion_level < 18:
        lights_count=4
    else:
        lights_count=5
        
    lights_count_changed.emit(lights_count)
    
func report_decomission_incorrect(reason: String):
    print("Decomission incorrect! " + reason)
    spawn_pool_cache="?"
    request_spawn_on_next_look=true
    await get_tree().create_timer(1.).timeout
    decomission_incorrect.emit(reason)

func on_look_area_entered(area:LookArea):
    playerLookArea=area
    print('GS: new area')
    
    if area.is_spawn_pipe:
        print('Pipe!')
        
        if request_spawn_on_next_look:
            $NextLevelTimer.start()
            request_spawn_on_next_look=false
            
    if area.is_narrow:
        spook_manager.roll_spook(area.opposite_look_area)
        

func _input(event: InputEvent) -> void:
    if $CheatManager.cheat_mode:
        if event is InputEventKey:
            if event.pressed and event.keycode == KEY_N:
                print("Cheating to the next lvl")
                for c in $/root/Game/Scrap.get_children():
                    c.queue_free()
                report_decomission_correct("Cheating")
                $NextLevelTimer.start()
            if event.pressed and event.keycode == KEY_R:
                print("Cheating to the next lvl")
                for c in $/root/Game/Scrap.get_children():
                    c.queue_free()
                report_decomission_incorrect("Cheating")
                $NextLevelTimer.start()
