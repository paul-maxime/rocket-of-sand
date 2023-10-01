extends CanvasLayer

@onready var sand_label: Label = $"Panel/CenterContainer/SandLabel"
@onready var buy_drill_button: Button = $"Panel/BuyDrillButton"
@onready var buy_factory_button: Button = $"Panel/BuyFactoryButton"
@onready var buy_rocket_button: Button = $"Panel/BuyRocketButton"

var drill_price = 100
var factory_price = 100
var rocket_price = 100

func _ready():
	update_sand(0)

func update_sand(value: int):
	sand_label.text = str(value)
	buy_drill_button.disabled = value < drill_price
	buy_factory_button.disabled = value < factory_price
	buy_rocket_button.disabled = value < rocket_price

func update_rocket_price(price, current_sand, new_sprite):
	rocket_price = price
	buy_rocket_button.text = str(rocket_price)
	buy_rocket_button.disabled = current_sand < rocket_price
	buy_rocket_button.get_child(0).texture = new_sprite
