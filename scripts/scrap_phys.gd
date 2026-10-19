extends RigidBody3D

@onready var hit_sound: AudioStreamPlayer3D = $HitSound

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
    if state.get_contact_count() > 0:
        var impulse = state.get_contact_impulse(0)
        if impulse.length_squared() > 1:
            print(impulse.length_squared())
            hit_sound.volume_linear = clampf(inverse_lerp(0,5,impulse.length_squared()), 0, 1)
            if hit_sound.get_playback_position() < 0.1:
                hit_sound.play()
