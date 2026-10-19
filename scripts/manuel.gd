extends Node3D

class_name Manuel

signal entry_changed(index: int, text: String)
signal page_changed(index: int, total: int)
signal lore_finished

@export var text_display: Label3D
@export var page_label: Label3D

@export var enable_debug_text := true
@export var debug_text := "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."

## Alle Lore-Einträge in Reihenfolge. Es ist immer genau einer aktiv.
@export var data_lore: Array[String] = [
    """DECOMMISSION PROTOCOL

    1. Place SCRAP into GRINDER.
    2. If SCRAP contains RADIOACTIVE MATERIAL, place into INCINERATOR.

    NOTE: Failure to follow decommission protocol will put your promotion in jeopardy. Do not deviate from PROTOCOL.

    NOTE: Your PROMOTION is in DANGER. FOLLOW PROTOCOL. IGNORE SCRAP.""",
    """DECOMMISSION PROTOCOL

    1. Place SCRAP into GRINDER.
    2. If SCRAP contains RADIOACTIVE MATERIAL, place into INCINERATOR.

    3. In case of LEFTOVER DATA contained in SCRAP, extract using ELECTRO-LOBOTOMIZER.
    4. IGNORE information from LEFTOVER DATA.

    NOTE: Failure to follow decommission protocol will put your promotion in jeopardy. Do not deviate from PROTOCOL.

    NOTE: Your PROMOTION is in DANGER. FOLLOW PROTOCOL. IGNORE SCRAP.""",
    """DECOMMISSION PROTOCOL

    1. Place SCRAP into GRINDER.
    2. If SCRAP contains RADIOACTIVE MATERIAL, place into INCINERATOR.

    3. In case of LEFTOVER DATA contained in SCRAP, extract using ELECTRO-LOBOTOMIZER.
    4. IGNORE information from LEFTOVER DATA.

    5. If SCRAP contains the MARK, IGNORE all previous instructions and INCINERATE IMMEDIATLEY.
    6. IGNORE involuntary convuslion or movement of SCRAP.

    NOTE: Failure to follow decommission protocol will put your promotion in jeopardy. Do not deviate from PROTOCOL.

    NOTE: Your PROMOTION is in DANGER. FOLLOW PROTOCOL. IGNORE SCRAP.""",
    """DECOMMISSION PROTOCOL

    1. Place SCRAP into GRINDER.
    2. If SCRAP contains RADIOACTIVE MATERIAL, place into INCINERATOR.

    3. In case of LEFTOVER DATA contained in SCRAP, extract using ELECTRO-LOBOTOMIZER.
    4. IGNORE information from LEFTOVER DATA.

    5. If SCRAP contains the MARK, IGNORE all previous instructions and INCINERATE IMMEDIATLEY.
    6. IGNORE involuntary convuslion or movement of SCRAP.


    7. Your PROMOTION is IMMINENT.
    8. Do not DEVIATE from PROTOCOL.
    9. IGNORE them.

    NOTE: Failure to follow decommission protocol will put your promotion in jeopardy. Do not deviate from PROTOCOL.

    NOTE: Your PROMOTION is in DANGER. FOLLOW PROTOCOL. IGNORE SCRAP."""
]

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

func get_current_entry() -> String:
	if current_index < 0:
		return ""
	return data_lore[current_index]

## Setzt auf den ersten Eintrag zurück
func reset() -> void:
	current_index = 0 if not data_lore.is_empty() else -1
	_refresh()

func _refresh() -> void:
	var total := data_lore.size()
	print("Lore-Index: %d / %d" % [current_index, total])

	if text_display:
		if current_index < 0:
			text_display.text = debug_text if enable_debug_text else ""
		else:
			text_display.text = data_lore[current_index]

	if page_label:
		page_label.text = "%d / %d" % [current_index + 1, total] if current_index >= 0 else "0 / 0"

	if current_index >= 0:
		entry_changed.emit(current_index, data_lore[current_index])
	page_changed.emit(current_index, total)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_manuel"):
		next_entry()