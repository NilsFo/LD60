extends Camera3D

var mousePos: Vector2=Vector2.ZERO

@export var lookLimitDegreeX: float=25.0
@export var invertX:bool=false
@export var lookLimitDegreeY: float=25.0
@export var invertY:bool=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var screenResolution:Vector2= get_viewport().get_visible_rect().size
	var lookPercent: Vector2 = Vector2(
		(mousePos.x/screenResolution.x-0.5)*-2,
		(mousePos.y/screenResolution.y-0.5)*-2
	)
	
	if invertX:
		lookPercent.x=lookPercent.x*-1
	if invertY:
		lookPercent.y=lookPercent.y*-1
	
	rotation = Vector3(
		deg_to_rad(lookPercent.y*lookLimitDegreeY),
		deg_to_rad(lookPercent.x*lookLimitDegreeX),
		0
	)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		pass
		# print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		# print("Mouse Motion at: ", event.position)
		mousePos=event.position
