extends Control

@onready var label_sequencia = $LabelSequencia
@onready var line_edit_resposta = $HBoxContainer/LineEditResposta
@onready var botao_escanear = $HBoxContainer/BotaoEscanear
@onready var label_status = $LabelStatus
@onready var caixa_dialogo = $CaixaDialogo

var resposta_correta: int
var minigame_vencido: bool = false

func _ready():
	var historinha_radar = [
		"O robô precisa enxergar a pista usando o sensor ultrassônico, igual a um morcego!",
		"O radar escaneia a distância pulando os números em uma sequência constante (de 2 em 2, 5 em 5...).",
		"Descubra qual é a regra do pulo e digite o número que falta para focar o radar no obstáculo!"
	]
	caixa_dialogo.iniciar_dialogo(historinha_radar)
	await caixa_dialogo.tutorial_concluido
	randomize()
	botao_escanear.pressed.connect(_verificar_resposta)
	
	# Dica de usabilidade: Foca na caixa de texto automaticamente
	line_edit_resposta.grab_focus() 
	
	_gerar_nova_sequencia()

func _gerar_nova_sequencia():
	# Sorteia o padrão da sequência (pulos de 2, 3, 4, 5 ou 10)
	var passo = randi_range(2, 5) 
	if randi() % 2 == 0: 
		passo = 10 
		
	# Sorteia o número inicial (ex: começa do 5, do 12...)
	var inicio = randi_range(2, 20)
	
	var n1 = inicio
	var n2 = inicio + passo
	var n3 = inicio + (passo * 2)
	
	# O 4º número é o que a criança precisa adivinhar
	resposta_correta = inicio + (passo * 3) 
	
	label_sequencia.text = "%d cm   -   %d cm   -   %d cm   -   [ ? ] cm" % [n1, n2, n3]
	
	line_edit_resposta.text = "" # Limpa a caixinha
	label_status.text = "Digite o próximo número e escaneie!"
	label_status.modulate = Color.WHITE

func _verificar_resposta():
	if minigame_vencido:
		return
		
	# Pega o texto digitado e converte para número
	var resposta_jogador = line_edit_resposta.text.to_int()
	
	if resposta_jogador == resposta_correta:
		_vencer_minigame()
	else:
		label_status.text = "Sinal perdido! A sequência estava errada. Recalculando..."
		label_status.modulate = Color.RED
		
		# Gera um novo puzzle se errar
		await get_tree().create_timer(2.0).timeout
		_gerar_nova_sequencia()

func _vencer_minigame():
	minigame_vencido = true
	
	# Mostra o número escondido na tela para dar aquele visual de "resolvido"
	label_sequencia.text = label_sequencia.text.replace("[ ? ]", str(resposta_correta))
	
	label_status.text = "RADAR FOCADO! Obstáculo detectado perfeitamente!"
	label_status.modulate = Color.GREEN
	
	if "progresso" in Global:
		Global.progresso = 3 # Atualiza o progresso para a oficina final
		
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
