extends MeshInstance3D

@export var current_mesh: MeshInstance3D

# For a 3D MeshInstance3D
func _ready() -> void:
    var effect_color = Vector3(
        randf_range(0.1, 0.3), 
        randf_range(0.2, 0.4), 
        randf_range(0.7, 0.9)
        ); 

    current_mesh.set_instance_shader_parameter("effect_color", effect_color)
    current_mesh.set_instance_shader_parameter("octave_count", randi_range(8, 12))
    current_mesh.set_instance_shader_parameter("speed", randf_range(4, 6))
    current_mesh.set_instance_shader_parameter("amp_start", randf_range(0.4, 0.6))
    current_mesh.set_instance_shader_parameter("amp_coeff", randf_range(0.4, 0.6))
    current_mesh.set_instance_shader_parameter("thickness", randf_range(0.5, 1.0))
