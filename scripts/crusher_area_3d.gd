extends Area3D

@export var particle_prefab: PackedScene
@export var particle_spawn_point: Node3D
 
var _last_body_position: Vector3

func _ready() -> void:
    body_entered.connect(_on_body_entered)
 
 
func _on_body_entered(body: Node3D) -> void:
    if not body is RigidBody3D:
        return
        
    _last_body_position = body.global_position
    body.queue_free()
    spawn_particles()
        
func spawn_particles() -> void:
    if particle_prefab == null:
        return
        
    var particles := particle_prefab.instantiate() as GPUParticles3D
    
    if particles == null:
        push_warning("particle_scene hat keinen GPUParticles3D als Root!")
        return
        
    get_tree().current_scene.add_child(particles)
    particles.global_position = particle_spawn_point.position
    particles.emitting = true
