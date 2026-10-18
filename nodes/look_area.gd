extends Area3D

signal rigidbody_enter(body: RigidBody3D)
signal rigidbody_leave(body: RigidBody3D)

@export var is_looking:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_body_entered(body: Node3D) -> void:
    if body.name == "LookArea3D":
        print("Player looks at: "+name+" from: "+get_parent().name)
        is_looking=true

func _on_body_exited(body: Node3D) -> void:
    if body.name == "LookArea3D":
        print("Player stoped looking at: "+name +"from: "+get_parent().name)
        is_looking=false
        