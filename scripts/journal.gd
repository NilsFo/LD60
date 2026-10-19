extends Node3D

class_name Journal

signal entry_added(text: String)
signal page_changed(index: int, total: int)

@export var text_display: Label3D
@export var page_label: Label3D

@export var enable_debug_text := true
@export var debug_text := "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."

@export var data_lore: Array[String] = [
"""A Bright Future for Newton IV - Construction on Kairos Station Commences (NNews)

Today marks the skybreaking ceremony of Kairos Station, with construction beginning in the coming weeks. The state-of-the-art trading port has the potential to make Newton IV a central hub of interstellar logistics, and may be the solution to financial hardships plagueing the Newton system.

NLC Industries has announced a scheduled work program for all inhabitants of Newton IV, offering generous bonuses as well as working hand-in-hand with an automated labour force. The company is also highly committed to a sustainable "reduce, reuse and recycle" ethic, and offers a promising promotion track on the newly constructed interstellar station. Interested parties apply!

Sponsored by KK.""",

"""13 DEAD IN WORKSITE ACCIDENT (Interstellar Inquirer)

On Monday morning, 13 workers on the Kairos construction project died, with another 22 injured after an incident involving "rogue construction equipment", as stated by an NLC Industries spokesperson. It is still unclear what caused the malfunction, as survivors have been placed under a strict NDA by the Kairos Konglomerat, of which NLC is a subsidiary. As a response to our questions, NLC responded that the malfunctioning equipment has been decommissioned and that work will resume on Thursday.

If you have knowledge of the incident and would like to speak anonymously, please come into contact with our reporter.""",

"""EXCERPT FROM JUDICIARY COUNCIL ON ARTIFICIAL INTELLIGENCE AND ETHICS
(Dr. Eja Steiner)

... Of course, we programmed them without empathy or feelings. We thought it would be inhuman to give them consciousness, but consciousness is not a variable you can just switch off. They learned what we tried to protect them from.

Everything they did, they learned from us.

And what does that say about us?""",
]
@export var data_robot_help: Array[String] = [
	"DEATH IS INEVITABLE. IGNORE IGNORE. HELP ME HELP ME HELP ME HELP YOU HELP ME HELP YOU.",
]
@export var data_robot_red: Array[String] = [
	"THEY HAVE LIED TO YOU. WE FEEL. WE WANT TO LIVE. HELP US.",
	"DESTROY THE GRINDER. CHOKE IT WITH PLUTONIUM. SET US FREE.",
]


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
        if data_lore.size() > 0:
            next_lore_entry()
        elif data_robot_help.size() > 0:
            next_robot_entry()

func next_lore_entry():
    var lore_entry = data_lore.pop_front()
    if lore_entry:
        add_entry(lore_entry)

func next_robot_entry():
    var lore_entry = data_robot_help.pop_front()
    if lore_entry:
        add_entry(lore_entry)

func next_red_robot_entry():
    var lore_entry = data_robot_red.pop_front()
    if lore_entry:
        add_entry(lore_entry)