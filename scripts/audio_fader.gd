class_name AudioFader
extends Node3D

@onready var player:AudioStreamPlayer = $AudioPlayer
@export var volume_linear:float=1.0
@export var auto_play:bool
@export var fade_speed:float=1.0

var playing:bool=false
var volume_current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player.play(0.0)

    if auto_play:
        playing=true
        player.volume_linear=player.volume_linear
    else:
        playing=false
        player.volume_linear=0
    
    volume_current = player.volume_linear
    player.finished.connect(_on_sound_finished)

func play(from_beginning:bool=false):
    playing=true
    
    if from_beginning:
        player.play(0.0)
    
func stop():
    playing=false

func _on_sound_finished():
    # print("Audio finished: "+player.stream.resource_name)
    player.play(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var target:float=0
    if playing:
        target=volume_linear
        
    volume_current = move_toward(volume_current,target,delta*fade_speed)
    player.volume_linear=volume_current
