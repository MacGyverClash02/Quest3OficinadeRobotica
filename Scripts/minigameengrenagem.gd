extends Control

@onready var label_descricao = $LabelDescricao
@onready var label_status = $LabelStatus
@onready var botao_1 = $ContainerBotoes/BotaoOpcao1
@onready var botao_2 = $ContainerBotoes/BotaoOpcao2
@onready var botao_3 = $ContainerBotoes/BotaoOpcao3
@onready var caixa_dialogo = $CaixaDialogo

var voltas_motor: int
var proporcao_engrenagem: int
var resposta_correta: int

var minigame_vencido: bool = false

func _ready():
	var historinha_engrenagem = [
		"Os motores estão prontos, mas as rodas precisam de força extra das engrenagens.",
		"Para saber a força total, você precisa multiplicar o número de voltas do motor pela força da engrenagem.",
		"Calcule a multiplicação correta e escolha o botão certo para a roda não travar!"
	]
	caixa_dialogo.iniciar_dialogo(historinha_engrenagem)
	await caixa_dialogo.tutorial_concluido
	randomize()
	
	# Conecta os botões via código para acelerar o desenvolvimento
	botao_1.pressed.connect(func(): _verificar_resposta(botao_1.text))
	botao_2.pressed.connect(func(): _verificar_resposta(botao_2.text))
	botao_3.pressed.connect(func(): _verificar_resposta(botao_3.text))
	
	_gerar_desafio_tabuada()

func _gerar_desafio_tabuada():
	# Define valores típicos de tabuada do 2 ao 9 para o ensino fundamental
	voltas_motor = randi_range(2, 9)
	proporcao_engrenagem = randi_range(2, 9)
	resposta_correta = voltas_motor * proporcao_engrenagem
	
	# Atualiza o texto com uma historinha contextualizada no robô
	label_descricao.text = "O motor do robô deu %d voltas.\nA engrenagem da roda gira %d vezes para cada volta do motor.\n\nQuantas voltas a roda deu no total?" % [voltas_motor, proporcao_engrenagem]
	
	# Cria opções de resposta erradas próximas da correta para desafiar
	var erro_1 = resposta_correta + randi_range(1, 4)
	var erro_2 = resposta_correta - randi_range(1, 4)
	if erro_2 <= 0: erro_2 = resposta_correta + 5 # Evita respostas negativas ou zero
	
	# Coloca as opções num array e embaralha
	var opcoes = [resposta_correta, erro_1, erro_2]
	opcoes.shuffle()
	
	# Atribui os textos aos botões
	botao_1.text = str(opcoes[0])
	botao_2.text = str(opcoes[1])
	botao_3.text = str(opcoes[2])
	
	label_status.text = "Escolha a resposta correta!"
	label_status.modulate = Color.WHITE

func _verificar_resposta(texto_botao: String):
	if minigame_vencido:
		return
		
	var resposta_jogador = texto_botao.to_int()
	
	if resposta_jogador == resposta_correta:
		_vencer_minigame()
	else:
		label_status.text = "Ih, a conta deu errada e a roda travou! Tente de novo!"
		label_status.modulate = Color.RED
		# Pequena penalidade: gera um novo problema para não ficar adivinhando o mesmo botão
		await get_tree().create_timer(1.5).timeout
		_gerar_desafio_tabuada()

func _vencer_minigame():
	minigame_vencido = true
	label_status.text = "CÁLCULO PERFEITO! O motor girou com força total!"
	label_status.modulate = Color.GREEN
	
	# Atualiza o progresso no Global e retorna para a oficina
	if "progresso" in Global:
		Global.progresso = 2
		
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
