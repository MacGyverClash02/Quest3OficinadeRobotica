extends Control

@onready var label_sequencia = $FundoUI/VBoxContainer/LabelSequencia
@onready var line_edit_resposta = $FundoUI/VBoxContainer/HBoxContainer/LineEditResposta
@onready var botao_escanear = $FundoUI/VBoxContainer/HBoxContainer/BotaoEscanear
@onready var label_status = $FundoUI/VBoxContainer/LabelStatus
@onready var caixa_dialogo = $CaixaDialogo

var resposta_correta: int
var minigame_vencido: bool = false

func _ready():
	randomize()
	botao_escanear.pressed.connect(_verificar_resposta)
	line_edit_resposta.grab_focus() 
	
	var historinha = [
		"O robô precisa enxergar a pista usando o sensor ultrassônico, igual a um morcego!",
		"O radar escaneia a distância pulando os números em uma sequência constante (de 2 em 2, 5 em 5...).",
		"Descubra qual é a regra do pulo e digite o número que falta para focar o radar no obstáculo!"
	]
	caixa_dialogo.iniciar_dialogo(historinha)
	await caixa_dialogo.tutorial_concluido
	
	_gerar_nova_sequencia()

func _gerar_nova_sequencia():
	var passo = randi_range(2, 5) 
	if randi() % 2 == 0: 
		passo = 10 
		
	var inicio = randi_range(2, 20)
	var n1 = inicio
	var n2 = inicio + passo
	var n3 = inicio + (passo * 2)
	
	resposta_correta = inicio + (passo * 3) 
	
	label_sequencia.text = "%d cm   -   %d cm   -   %d cm   -   [ ? ] cm" % [n1, n2, n3]
	line_edit_resposta.text = "" 
	label_status.text = "Digite o próximo número e escaneie!"
	label_status.modulate = Color.WHITE

func _verificar_resposta():
	if minigame_vencido:
		return
		
	var resposta_jogador = line_edit_resposta.text.to_int()
	
	if resposta_jogador == resposta_correta:
		_vencer_minigame()
	else:
		label_status.text = "Sinal perdido! A sequência estava errada. Recalculando..."
		label_status.modulate = Color.RED
		await get_tree().create_timer(2.0).timeout
		_gerar_nova_sequencia()

func _vencer_minigame():
	minigame_vencido = true
	label_sequencia.text = label_sequencia.text.replace("[ ? ]", str(resposta_correta))
	label_status.text = "RADAR FOCADO! Obstáculo detectado perfeitamente!"
	label_status.modulate = Color.GREEN
	
	Global.radar_consertado = true
	Global.progresso = 4 
		
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
