extends Control

@onready var label_instrucao = $LabelInstrucao
@onready var grid_container = $GridContainer
@onready var label_status = $LabelStatus
@onready var caixa_dialogo = $CaixaDialogo

var sequencia_alvo: Array = []
var indice_atual: int = 0
var linhas = ["A", "B", "C", "D"]
var colunas = ["1", "2", "3", "4"]
var minigame_vencido: bool = false
var tamanho_sequencia: int = 3 # Quantidade de fios para conectar

func _ready():
	var historinha_protoboard = [
		"Hora de plugar os fios no cérebro do robô usando o Protoboard!",
		"Olhe as letras nas linhas e os números nas colunas. É como um mapa de batalha naval.",
		"Leia o painel e clique no buraco exato (como B3 ou D1) na ordem correta.",
		"Não troque a ordem dos fios ou a placa vai apitar de erro!"
	]
	caixa_dialogo.iniciar_dialogo(historinha_protoboard)
	await caixa_dialogo.tutorial_concluido
	randomize()
	_montar_protoboard()
	_gerar_nova_sequencia()

func _montar_protoboard():
	# Cria os 16 buracos do protoboard
	for linha in linhas:
		for coluna in colunas:
			var coordenada = linha + coluna
			var btn = Button.new()
			btn.text = coordenada
			
			btn.custom_minimum_size = Vector2(80, 80)
			btn.add_theme_font_size_override("font_size", 24)
			
			# Passamos o próprio botão como parâmetro para podermos mudar a cor dele!
			btn.pressed.connect(func(): _verificar_conexao(coordenada, btn))
			
			grid_container.add_child(btn)

func _gerar_nova_sequencia():
	sequencia_alvo.clear()
	indice_atual = 0
	
	# Reseta as cores de todos os botões para o padrão
	for btn in grid_container.get_children():
		btn.modulate = Color.WHITE

	# Sorteia 3 coordenadas diferentes para garantir que não repita o mesmo buraco
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
			texto_sequencia += "[ OK ]  " # Marca o fio que já foi conectado corretamente
		else:
			texto_sequencia += "[ " + sequencia_alvo[i] + " ]  "
			
	label_instrucao.text = "Ordem de montagem dos fios do robô:\n\n" + texto_sequencia

func _verificar_conexao(coordenada_clicada: String, botao: Button):
	if minigame_vencido:
		return
		
	# Checa se o clique corresponde ao fio atual da sequência
	if coordenada_clicada == sequencia_alvo[indice_atual]:
		botao.modulate = Color.GREEN # Pinta o botão de verde para dar feedback
		indice_atual += 1 # Avança para o próximo fio
		
		if indice_atual == sequencia_alvo.size():
			_vencer_minigame()
		else:
			label_status.text = "Conexão estabelecida! Faltam " + str(sequencia_alvo.size() - indice_atual) + " fio(s)."
			label_status.modulate = Color.YELLOW
			_atualizar_texto_instrucao()
	else:
		# Errou o fio na ordem
		label_status.text = "Curto-circuito! Ordem incorreta. Reiniciando montagem..."
		label_status.modulate = Color.RED
		botao.modulate = Color.RED # Pisca em vermelho para mostrar o erro
		
		# Espera um tempinho e gera um novo puzzle do zero para punir o "chute"
		await get_tree().create_timer(1.5).timeout
		_gerar_nova_sequencia()

func _vencer_minigame():
	minigame_vencido = true
	label_status.text = "SISTEMA ONLINE! Todos os fios conectados perfeitamente!"
	label_status.modulate = Color.GREEN
	_atualizar_texto_instrucao()
	
	if "progresso" in Global:
		Global.progresso = 4 
		
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
