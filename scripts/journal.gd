extends Node3D

class_name Journal

signal entry_added(text: String)
signal page_changed(index: int, total: int)

@export var text_display: Label3D
@export var page_label: Label3D

@export var enable_debug_text := true
@export var debug_text := "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."

## Index 0 = ältester Eintrag, entries.size() - 1 = neuester Eintrag
var entries: Array[String] = []
var current_index: int = -1

func _ready() -> void:
    _refresh()

func add_entry(text: String) -> void:
    entries.append(text)
    current_index = entries.size() - 1
    entry_added.emit(text)
    _refresh()

## Eine Seite zurück (zu älteren Einträgen)
func to_older_entries() -> void:
    if has_older():
        current_index -= 1
        _refresh()

## Eine Seite vor (zu neueren Einträgen)
func to_new_entries() -> void:
    if has_newer():
        current_index += 1
        _refresh()

## Direkt zu einem bestimmten Eintrag springen
func show_entry(index: int) -> void:
    if entries.is_empty():
        return
    current_index = clampi(index, 0, entries.size() - 1)
    _refresh()

func show_newest() -> void:
    show_entry(entries.size() - 1)

func show_oldest() -> void:
    show_entry(0)

func has_older() -> bool:
    return current_index > 0

func has_newer() -> bool:
    return current_index < entries.size() - 1

func clear() -> void:
    entries.clear()
    current_index = -1
    _refresh()

func _refresh() -> void:
    var default = "" if !enable_debug_text else  debug_text
    print("Journal-Index: %d / %d" % [current_index, entries.size()])

    if text_display:
        if entries.is_empty():
            text_display.text = default if enable_debug_text else ""
        else:
            text_display.text = entries[current_index]

    if page_label:
        if entries.is_empty():
            page_label.text = "0 / 0"
        else:
            page_label.text = "%d / %d" % [current_index + 1, entries.size()]

    page_changed.emit(current_index, entries.size())


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("debug_jounal"):
        add_entry("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")