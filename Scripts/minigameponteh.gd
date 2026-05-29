extends Control
@onready var caixa_dialogo = $CaixaDialogo
@onready var chave_a = $ChaveA
@onready var chave_b = $ChaveB
@onready var chave_c = $ChaveC
@onready var chave_d = $ChaveD
@onready var label_equacao = $LabelEquacao
@onready var label_status = $LabelStatus

var val_a: int
var val_b: int
var val_c: int
var val_d: int

var alvo_matematico: int 
var minigame_vencido: bool = false

func _ready():
	var historinha_ponteh = [
		"Esta é a Ponte H! Ela é quem diz para as rodas irem para frente ou para trás.",
		"O sistema está desbalanceado. Para o robô não bater, a energia precisa chegar no número exato que a tela pede.",
		"Ligue e desligue as chaves para somar (+) ou subtrair (-) a energia de cada bloco.",
		"Deixe o resultado igual ao objetivo!"
	]
	caixa_dialogo.iniciar_dialogo(historinha_ponteh)
	await caixa_dialogo.tutorial_concluido
	randomize()
	
	chave_a.toggled.connect(_ao_mudar_chave)
	chave_b.toggled.connect(_ao_mudar_chave)
	chave_c.toggled.connect(_ao_mudar_chave)
	chave_d.toggled.connect(_ao_mudar_chave)
	
	_gerar_novo_puzzle()
	_atualizar_equacao()

func _gerar_novo_puzzle():
	# Sorteia os valores de x a y para cada bloco
	val_a = randi_range(1, 20)
	val_b = randi_range(1, 20)
	val_c = randi_range(1, 20)
	val_d = randi_range(1, 20)
	
	# Cria um gabarito secreto (sorteia se o número vai ser positivo ou negativo)
	# randi() % 2 resulta em 0 ou 1.
	var gabarito_a = 1 if randi() % 2 == 0 else -1
	var gabarito_b = 1 if randi() % 2 == 0 else -1
	var gabarito_c = 1 if randi() % 2 == 0 else -1
	var gabarito_d = 1 if randi() % 2 == 0 else -1
	
	# Calcula o alvo com base nesse gabarito secreto para garantir que é possível vencer
	alvo_matematico = (val_a * gabarito_a) + (val_b * gabarito_b) + (val_c * gabarito_c) + (val_d * gabarito_d)

func _ao_mudar_chave(_estado):
	if minigame_vencido:
		return
	_atualizar_equacao()

func _atualizar_equacao():
	# Define se o botão está Somando (Ligado) ou Subtraindo (Desligado)
	var sinal_a = "+" if chave_a.button_pressed else "-"
	var sinal_b = "+" if chave_b.button_pressed else "-"
	var sinal_c = "+" if chave_c.button_pressed else "-"
	var sinal_d = "+" if chave_d.button_pressed else "-"
	
	# Aplica o sinal ao valor real para a matemática do Godot
	var calc_a = val_a if chave_a.button_pressed else -val_a
	var calc_b = val_b if chave_b.button_pressed else -val_b
	var calc_c = val_c if chave_c.button_pressed else -val_c
	var calc_d = val_d if chave_d.button_pressed else -val_d
	
	var total_atual = calc_a + calc_b + calc_c + calc_d
	
	# Atualiza a tela
	label_equacao.text = "%s%d   %s%d   %s%d   %s%d   =   %d" % [sinal_a, val_a, sinal_b, val_b, sinal_c, val_c, sinal_d, val_d, total_atual]
	
	# Verifica Vitória
	if total_atual == alvo_matematico:
		_vencer_minigame()
	else:
		label_status.text = "OBJETIVO: CHEGAR EM " + str(alvo_matematico)
		label_status.modulate = Color.WHITE

func _vencer_minigame():
	minigame_vencido = true
	label_status.text = "EQUAÇÃO BALANCEADA! SUCESSO!"
	label_status.modulate = Color.GREEN
	label_equacao.modulate = Color.GREEN
	
	Global.ponte_h_consertada = true
	Global.progresso = 2
	
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
