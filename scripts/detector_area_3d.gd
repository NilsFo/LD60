extends Area3D

signal rigidbody_enter(body: RigidBody3D)
signal rigidbody_leave(body: RigidBody3D)

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    push_warning("Detector: body enter!")
    if body is RigidBody3D:
        rigidbody_enter.emit(body)

func _on_body_exited(body: Node3D) -> void:
    if body is RigidBody3D:
        push_warning("Detector: body exited!")
        rigidbody_leave.emit(body)