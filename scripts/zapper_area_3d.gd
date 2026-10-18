extends Area3D

signal rigidbody_zapped()
signal rigidbody_enters_zapper()
signal rigidbody_exited_zapper()

@export var targets: Array[RigidBody3D] = [] 

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body is RigidBody3D:
        rigidbody_enters_zapper.emit()
        targets.append(body)

func _on_body_exited(body: Node3D) -> void:
    if body is RigidBody3D:
        rigidbody_exited_zapper.emit()
        targets.erase(body)

func _on_start_of_zap():
    return

func _on_end_of_zap():
    rigidbody_zapped.emit()
    #TODO Change Properties of Bot 
    return