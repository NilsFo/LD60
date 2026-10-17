class_name PlayerButton
extends StaticBody3D

enum ButtonType {UNBEKANNT,START_LINKS,START_RECHTS, STOP, MAGNET}

@export var buttonType: int = ButtonType.UNBEKANNT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func press():
	print("Gedrückt: "+str(buttonType))