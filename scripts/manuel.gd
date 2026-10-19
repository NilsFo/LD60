extends Node3D

class_name Manuel

signal entry_changed(index: int, texture: Texture2D)
signal page_changed(index: int, total: int)
signal lore_finished
signal new_entry

## Sprite, auf dem die aktuelle Lore-Seite angezeigt wird
@export var text_sprite: Sprite3D
@export var page_label: Label3D

## Wird angezeigt, wenn data_lore leer ist
@export var enable_debug_texture := true
@export var debug_texture: Texture2D

## Alle Lore-Seiten als Texturen in Reihenfolge. Es ist immer genau eine aktiv.
@export var data_lore: Array[Texture2D] = []

## Index des aktuell aktiven Eintrags (-1 = data_lore ist leer)
var current_index: int = -1


func _ready() -> void:
    current_index = 0 if not data_lore.is_empty() else -1
    _refresh()


## Schaltet zum nächsten Eintrag. Bleibt beim letzten stehen.
func next_entry() -> void:
    if not has_next():
        return
    current_index += 1
    _refresh()
    if is_last():
        lore_finished.emit()


func has_next() -> bool:
    return current_index < data_lore.size() - 1


func is_last() -> bool:
    return not data_lore.is_empty() and current_index == data_lore.size() - 1


func get_current_entry() -> Texture2D:
    if current_index < 0:
        return null
    return data_lore[current_index]


## Setzt auf den ersten Eintrag zurück
func reset() -> void:
    current_index = 0 if not data_lore.is_empty() else -1
    _refresh()


func _refresh() -> void:
    var total := data_lore.size()
    print("Lore-Index: %d / %d" % [current_index, total])

    if text_sprite:
        if current_index < 0:
            text_sprite.texture = debug_texture if enable_debug_texture else null
        else:
            text_sprite.texture = data_lore[current_index]

    if page_label:
        page_label.text = "%d / %d" % [current_index + 1, total] if current_index >= 0 else "0 / 0"

    if current_index >= 0:
        entry_changed.emit(current_index, data_lore[current_index])
    if current_index > 0:  
        new_entry.emit()
    page_changed.emit(current_index, total)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_manuel"):
        next_entry()