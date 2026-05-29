extends Control

func _on_botao_iniciar_pressed():
	# 1. Toca o som do clique
	$SomClique.play()
	# 2. Aguarda um tempinho (0.3 segundos) para o som não ser cortado
	await get_tree().create_timer(0.3).timeout
	# 3. Transita para a cena de inspeção do robô
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")

func _on_botao_fechar_pressed():
	$SomClique.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()


func _on_botao_creditos_pressed() -> void:
	$SomClique.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://Cenas/Creditos.tscn")
