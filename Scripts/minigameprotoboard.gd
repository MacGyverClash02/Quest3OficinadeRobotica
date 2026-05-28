extends Control

@onready var caixa_dialogo = $CaixaDialogo
@onready var label_instrucao = $LabelInstrucao
@onready var grid_container = $GridContainer
@onready var label_status = $LabelStatus

var sequencia_alvo: Array = []
var indice_atual: int = 0
var linhas = ["A", "B", "C", "D"]
var colunas = ["1", "2", "3", "4"]
var minigame_vencido: bool = false
var tamanho_sequencia: int = 3 

func _ready():
	randomize()
	_montar_protoboard()
	
	var historinha = [
		"Hora de plugar os fios no cérebro do robô usando o Protoboard!",
		"Olhe as letras nas linhas e os números nas colunas. É como um mapa de batalha naval.",
		"Leia o painel e clique no buraco exato na ordem correta.",
		"Não troque a ordem dos fios ou a placa vai apitar de erro!"
	]
	caixa_dialogo.iniciar_dialogo(historinha)
	await caixa_dialogo.tutorial_concluido
	
	_gerar_nova_sequencia()

func _montar_protoboard():
	for linha in linhas:
		for coluna in colunas:
			var coordenada = linha + coluna
			var btn = Button.new()
			btn.text = coordenada
			
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
			btn.add_theme_font_size_override("font_size", 24)
			
			btn.pressed.connect(func(): _verificar_conexao(coordenada, btn))
			grid_container.add_child(btn)

func _gerar_nova_sequencia():
	sequencia_alvo.clear()
	indice_atual = 0
	
	for btn in grid_container.get_children():
		btn.modulate = Color.WHITE

	while sequencia_alvo.size() < tamanho_sequencia:
		var coord = linhas[randi() % linhas.size()] + colunas[randi() % colunas.size()]
		if not coord in sequencia_alvo:
			sequencia_alvo.append(coord)
			
	_atualizar_texto_instrucao()
	label_status.text = "Conecte os fios na ordem exata!"
	label_status.modulate = Color.WHITE

func _atualizar_texto_instrucao():
	var texto_sequencia = ""
	for i in range(sequencia_alvo.size()):
		if i < indice_atual:
			texto_sequencia += "[ OK ]  " 
		else:
			texto_sequencia += "[ " + sequencia_alvo[i] + " ]  "
			
	label_instrucao.text = "Ordem de montagem dos fios do robô:\n\n" + texto_sequencia

func _verificar_conexao(coordenada_clicada: String, botao: Button):
	if minigame_vencido:
		return
		
	if coordenada_clicada == sequencia_alvo[indice_atual]:
		botao.modulate = Color.GREEN 
		indice_atual += 1 
		
		if indice_atual == sequencia_alvo.size():
			_vencer_minigame()
		else:
			label_status.text = "Conexão estabelecida! Faltam " + str(sequencia_alvo.size() - indice_atual) + " fio(s)."
			label_status.modulate = Color.YELLOW
			_atualizar_texto_instrucao()
	else:
		label_status.text = "Curto-circuito! Ordem incorreta. Reiniciando montagem..."
		label_status.modulate = Color.RED
		botao.modulate = Color.RED 
		
		await get_tree().create_timer(1.5).timeout
		_gerar_nova_sequencia()

func _vencer_minigame():
	minigame_vencido = true
	label_status.text = "SISTEMA ONLINE! Todos os fios conectados perfeitamente!"
	label_status.modulate = Color.GREEN
	_atualizar_texto_instrucao()
	
	Global.protoboard_consertado = true
	Global.progresso = 5 
		
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
