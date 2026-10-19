extends Area3D

@export var particles: Array[GPUParticles3D]

signal play_scrap_grind_sound()
 
var _last_body_position: Vector3

func _ready() -> void:
    body_entered.connect(_on_body_entered)
 
func _on_body_entered(body: Node3D) -> void:
    if not body is RigidBody3D and body is not PhysicalBone3D:
        return

    _last_body_position = body.global_position
    var scrap: Scrap = body.find_parent("Scrap*")
    if scrap:
        scrap.grind()
        play_scrap_grind_sound.emit()
        spawn_particles()
    else: 
        print("crusher: body in not a scrap!!!")
        
func spawn_particles() -> void:
    if particles == null:
        return

    for particl in particles:
        particl.emitting = true
