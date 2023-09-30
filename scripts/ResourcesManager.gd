extends Node2D

var sand_money: int = 0

@onready var sand_label: Label = $CanvasLayer/SandLabel

func update_sand(delta: int):
	sand_money += delta
	sand_label.text = str(sand_money)
