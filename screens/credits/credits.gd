extends Control

var return_scene = "res://screens/menu/menu.tscn"

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene(return_scene)

func _on_Button_pressed():
	get_tree().change_scene(return_scene)
