extends Area3D

signal zapping_ended(targets: Array[RigidBody3D])

signal start_zapper_effect()
signal rigidbody_enters_zapper()
signal rigidbody_exited_zapper()

@export var targets: Array = [] 
@export var delay: float = 1.5

@export var is_running: bool = false

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body is RigidBody3D or body is PhysicalBone3D:
        rigidbody_enters_zapper.emit()
        targets.append(body)
        start_zap();

func _on_body_exited(body: Node3D) -> void:
    if body is RigidBody3D or body is PhysicalBone3D:
        rigidbody_exited_zapper.emit()
        targets.erase(body)

func zap_ended():
    is_running = false
    for target in targets:
        var scrap: Scrap = target.find_parent("Scrap*")
        if scrap:
            scrap.zap()
    zapping_ended.emit(targets)
    return

func start_zap():
    if is_running: 
        return

    is_running = true
    await get_tree().create_timer(delay).timeout
    start_zapper_effect.emit()
