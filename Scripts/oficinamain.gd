extends Control

func _ready():
	# Toda vez que a tela da Oficina carregar, verificamos a Memória Global
	if Global.bateria_consertada == true:
		# Se a bateria já foi arrumada no minigame, bloqueamos o botão
		$BotaoBateria.disabled = true
		
		# Feedback visual extra no futuro:
		# Aqui podemos mandar mostrar um ícone de "Check" verde ou acender um LED no chassi!
		print("Status: Bateria Operante.")

func _on_botao_bateria_pressed():
	# Quando a criança clicar na bateria quebrada, carrega a cena do conserto
	get_tree().change_scene_to_file("res://Cenas/MinigameBateria.tscn")
