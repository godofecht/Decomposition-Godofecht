extends Control

onready var label = $Text
onready var animation = $Display


func showText(text):
	label.text = text
	animation.play("Show")
	
