extends Area3D

signal rigidbody_burned()

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
    if body is RigidBody3D or body is PhysicalBone3D:
        rigidbody_burned.emit()
        var scrap: Scrap = body.find_parent("Scrap*")
        if scrap:
            scrap.incinerate()
