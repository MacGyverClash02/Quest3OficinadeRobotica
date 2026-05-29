extends Control
func _ready():
	$VBoxContainer/BotaoVoltar.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MenuPrincipal.tscn"))
