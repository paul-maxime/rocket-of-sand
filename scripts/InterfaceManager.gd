extends CanvasLayer

@onready var sand_label: Label = $"Panel/CenterContainer/SandLabel"
@onready var buy_drill_button: Button = $"Panel/BuyDrillButton"
@onready var buy_factory_button: Button = $"Panel/BuyFactoryButton"

func _ready():
	update_sand(0)

func update_sand(value: int):
	sand_label.text = str(value)
	buy_drill_button.disabled = value < 100
	buy_factory_button.disabled = value < 100
