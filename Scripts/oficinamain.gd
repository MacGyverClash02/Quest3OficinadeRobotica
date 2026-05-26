extends Control

@onready var caixa_dialogo = $CaixaDialogo

func _ready():
	# Toda vez que a tela da Oficina carregar, verificamos a Memória Global
	if Global.bateria_consertada == true:
		# Se a bateria já foi arrumada no minigame, bloqueamos o botão
		$BotaoBateria.disabled = true
		
		# Feedback visual extra no futuro:
		# Aqui podemos mandar mostrar um ícone de "Check" verde ou acender um LED no chassi!
		print("Status: Bateria Operante.")
# Pausa a interação da oficina até o diálogo acabar
	var historinha_intro = [
		"Olá, jovem engenheiro! Bem-vindo à sua nova Oficina de Robótica.",
		"Nossa missão de hoje é incrível: precisamos montar o cérebro e o corpo de um Robô Seguidor de Linha!",
		"Vamos usar o poderoso microcontrolador Arduino Uno para dar vida a ele.",
		"Mas olha só... ele está todo desmontado e sem energia.",
		"Clique nas estações de trabalho brilhantes para consertar cada parte do robô usando a matemática. Boa sorte!"
	]
	
	caixa_dialogo.iniciar_dialogo(historinha_intro)
	await caixa_dialogo.tutorial_concluido
	# A partir daqui, você libera os botões da oficina para a criança clicar.
func _on_botao_bateria_pressed():
	# Quando a criança clicar na bateria quebrada, carrega a cena do conserto
	get_tree().change_scene_to_file("res://Cenas/MinigameBateria.tscn")
