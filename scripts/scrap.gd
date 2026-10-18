class_name Scrap
extends Node3D


@export var isGreen: bool
@export var isRed: bool
@export var isBlue: bool

@export var dataMessage: String

@onready var game: GameState = $/root/Game/GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if isBlue and dataMessage == "":
        push_warning("Blue scrap without data message spawned!")

func zap():
    print(name + " wird gezappt")
    if isBlue:
        game.push_data_message(dataMessage)
        isBlue = false
        #TODO: remove visual blue
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
