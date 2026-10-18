extends Node3D

@export var listOfZaps: Array[Node3D] = []  
@export var default_dauer: float = 3.0

@export var is_triggert = false

func _ready() -> void:
    return
    #for zap in listOfZaps:
        #zap.visible = false

func trigger_zap(dauer: float = default_dauer) -> void:
    if is_triggert: 
        return

    is_triggert = true;
    for zap in listOfZaps:
        zap.show()

    await get_tree().create_timer(dauer).timeout

    for zap in listOfZaps:
        if is_instance_valid(zap):
            zap.hide()
    
    is_triggert = false;

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_zap"):
        trigger_zap()