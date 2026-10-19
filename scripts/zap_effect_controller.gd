extends Node3D

signal zapper_triggered()
signal zapper_finished()

signal play_scrap_zapping_sound_start()
signal play_scrap_zapping_sound_end()

@export var listOfZaps: Array[Node3D] = []  
@export var default_dauer: float = 3.0

@export var is_triggert = false

func _ready() -> void:
    for zap in listOfZaps:
        zap.visible = false

func trigger_zap(visual_only: bool = false, dauer: float = default_dauer) -> void:
    if is_triggert: 
        return

    if !visual_only: zapper_triggered.emit()

    is_triggert = true;
    play_scrap_zapping_sound_start.emit()

    for zap in listOfZaps:
        zap.show()

    await get_tree().create_timer(dauer).timeout

    for zap in listOfZaps:
        if is_instance_valid(zap):
            zap.hide()
    
    is_triggert = false;
    play_scrap_zapping_sound_end.emit()
    
    if !visual_only: zapper_finished.emit()

func trigger_visual_only():
    trigger_zap(true)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_zap"):
        trigger_zap()
