class_name Scrap
extends Node3D


@export var isGreen: bool
@export var isRed: bool
@export var isBlue: bool

@export var dataMessage: String

@onready var game: GameState = $/root/Game/GameState

@export var mesh: MeshInstance3D

signal zapped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print("Spawned " + name)
    if isBlue and dataMessage == "":
        push_warning("Blue scrap without data message spawned!")
    if isBlue and not mesh:
        push_warning("Blue scrap without mesh spawned!")

func zap():
    print(name + " wird gezappt")
    if isBlue:
        game.push_data_message(dataMessage)
        isBlue = false
        zapped.emit()
        mesh.set_surface_override_material(1, preload("res://nodes/scraps/data_sucked.tres"))
    else:
        print("...but nothing happened")
        return

func incinerate():
    print(name + " wird geincinerated")
    if isGreen and not isRed and not isBlue:
        game.report_decomission_correct("C_DangerousMaterialIncinerated")
    elif isRed:
        game.report_decomission_correct("C_ActiveRobotIncinerated")
    elif isBlue:
        game.report_decomission_incorrect("F_DataIncinerated")
    else:
        game.report_decomission_incorrect("F_ScrapIncinerated")
    queue_free()

func grind():
    print(name + " wird gegrinded")
    if not isGreen and not isRed and not isBlue:
        game.report_decomission_correct("C_ScrapReclaimed")
    elif isRed:
        game.report_decomission_incorrect("F_ActiveRobotGrinded")
    elif isBlue:
        game.report_decomission_incorrect("F_DataGrinded")
    else:
        game.report_decomission_incorrect("F_DangerousMaterialGrinded")
    queue_free()
