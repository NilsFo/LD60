class_name GameState
extends Node3D

@export var playerLookArea:LookArea

@export var player_rotation: float=0.0
@export var magnet:Node3D
@export var magnet_active:bool=false
@export var magnet_strength:float=10.0

var is_player_hover_over_interactable
var request_spawn_on_next_look:bool=false

@export var spawn_pool_cache:String=""
@export var promotion_level: int = 0
@export var stage: int = 0

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
@export var tutorial_timer: Timer 

@onready var music_ambience: AudioFader = $/root/Game/Music/AudioFaderAmbiance
@onready var music_gameplay: AudioFader = $/root/Game/Music/AudioFaderGameplayMusic
@onready var music_menu: AudioFader = $/root/Game/Music/AudioFaderMenu

@onready var crane_light: LightFlicker = $/root/Game/Player/SpotLight3D
@onready var cabin_light: LightFlicker = $/root/Game/Player/CabinLight3D

signal decomission_correct(reason: String)
signal decomission_incorrect(reason: String)
signal next_level(level: int)
signal lights_count_changed(lights_count: int)

signal magnet_activate
signal magnet_deactivate

signal display_next_lore_journal()
signal display_next_robot_data_journal()
signal display_next_red_robot_data_journal()
signal display_next_tutorial()

@export var max_rad_level: int = 5
@export var rad_level: int = 0

signal rad_level_changed(current_rad_level: int, max_rad_level:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gamephase = 0
    phase_game_change.emit(gamephase)
    phase_game_start.emit()
    magnet_active=false
    $NextLevelTimer.timeout.connect(_next_level)
    request_spawn_on_next_look=true
    
    music_gameplay.stop()
    music_menu.play()
    music_ambience.play()
    print("Music playing")
    
    if OS.has_feature("editor"):
        print("Running from Godot editor")
        tutorial_timer.wait_time=0.2
    else:
        tutorial_timer.wait_time=4
        print("Running as exported standalone game")
    
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
    if message == "Lore":
        display_next_lore_journal.emit()
    elif message == "RobotHelp":
        display_next_robot_data_journal.emit()
    elif message == "RobotRed":
        display_next_red_robot_data_journal.emit()

func push_tutorial_text():
    display_next_tutorial.emit()

func _next_level():
    print("Next level")
    scrap_spawner.spawn()
    next_level.emit()

func play():
    gamephase = 1;
    phase_game_change.emit(gamephase)
    phase_game_play.emit()
    print("GAME ON!")
    
    music_gameplay.play()
    music_menu.stop()
    
    if OS.has_feature("editor"):
        print("Running from Godot editor")
        print("No more confining")
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
    
    if promotion_level == scrap_spawner.spanw_pools.size():
        win()
        return
        
    spawn_pool_cache="?"
    update_crane_lights()
    request_spawn_on_next_look=true
    await get_tree().create_timer(2.).timeout
    decomission_correct.emit(reason)
    
func update_crane_lights():
    var last_lights_count = lights_count
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
    if last_lights_count != lights_count: 
        display_next_tutorial.emit()
    
func report_decomission_incorrect(reason: String):
    print("Decomission incorrect! " + reason)
    spawn_pool_cache="?"
    request_spawn_on_next_look=true
    await get_tree().create_timer(2.).timeout
    decomission_incorrect.emit(reason)
    if reason == "F_DangerousMaterialGrinded": 
        add_rad_level(1)

func on_look_area_entered(area:LookArea):
    playerLookArea=area
    print('GS: new area')
    
    if area.is_spawn_pipe:
        print('Pipe!')
        
        if request_spawn_on_next_look:
            $NextLevelTimer.start()
            request_spawn_on_next_look=false
            
    if area.is_narrow:
        spook_manager.next_spook(area.opposite_look_area)
        

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

func add_rad_level(add_value:int):
    rad_level += add_value
    rad_level_changed.emit(rad_level, max_rad_level)
    if rad_level >= max_rad_level:
        win_true()
