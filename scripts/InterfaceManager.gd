extends CanvasLayer

@onready var sand_label: Label = $"Panel/SandLabelContainer/SandLabel"
@onready var power_label: Label = $"Panel/PowerLabelContainer/PowerLabel"
@onready var buy_drill_button: Button = $"Panel/BuyDrillButton"
@onready var buy_factory_button: Button = $"Panel/BuyFactoryButton"
@onready var buy_rocket_button: Button = $"Panel/BuyRocketButton"

var drill_price = 100
var factory_price = 100
var rocket_price = 100

func _ready():
	update_sand(0)
	update_power(1)

func update_sand(value: int):
	sand_label.text = str(value)
	buy_drill_button.disabled = value < drill_price
	buy_factory_button.disabled = value < factory_price
	buy_rocket_button.disabled = value < rocket_price

func update_power(value: int):
	power_label.text = str(value)

func update_rocket_price(price, new_sprite):
	rocket_price = price
	update_button_price(buy_rocket_button, rocket_price)
	buy_rocket_button.get_node("RocketIcon").texture = new_sprite

func update_drill_price(price):
	drill_price = price
	update_button_price(buy_drill_button, drill_price)

func update_factory_price(price):
	factory_price = price
	update_button_price(buy_factory_button, factory_price)

func update_button_price(button, price):
	button.text = str(price)
	button.get_node("SandIcon").position.x = 130 + (len(str(price)) - 3) * 8
