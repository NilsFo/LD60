extends RigidBody3D

@export var targets: Array[RigidBody3D] = []    # der andere Körper
@export var strength: float = 50.0              # Magnetkraft
@export var max_range: float = 10.0             # Reichweite
@export var min_distance: float = 0.5           # verhindert riesige Kräfte bei Nähe
@export var pull_self: bool = true              # zieht auch das Ziel an (actio = reactio)

var magnet_on := false

func _unhandled_input(event):
    if event.is_action_pressed("magnet_toggle"):
        toggel_magnet()

func toggel_magnet():
    magnet_on = !magnet_on
    return magnet_on

func add_body(body: RigidBody3D):
    push_warning("body enter!")
    targets.append(body)

func remove_body(body: RigidBody3D):
    push_warning("body remove!")
    targets.erase(body)

func _physics_process(delta):
    if not magnet_on:
        return

    for target in targets:
        if not is_instance_valid(target):   # falls ein Ziel gelöscht wurde
            continue

        var dir : Vector3 = global_position - target.global_position
        var dist : float = dir.length()
        if dist > max_range or dist < 0.001:
            continue

        var d: float = max(dist, min_distance)
        var force: Vector3 = dir.normalized() * strength / (d * d)

        target.apply_central_force(force)
        if pull_self:
            apply_central_force(-force)
