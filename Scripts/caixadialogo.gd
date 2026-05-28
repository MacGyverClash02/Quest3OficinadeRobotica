extends CanvasLayer

# Esse sinal avisa o minigame que a criança terminou de ler
signal tutorial_concluido 

@onready var label_texto = $FundoEscuro/PainelContainer/Margem/VBoxContainer/LabelTexto
@onready var botao_proximo = $FundoEscuro/PainelContainer/Margem/VBoxContainer/BotaoProximo
@onready var fundo_escuro = $FundoEscuro

var falas: Array = []
var indice_atual: int = 0

func _ready():
	# Conecta o botão de avançar
	botao_proximo.pressed.connect(_proxima_fala)
	hide() # A caixa começa invisível até ser chamada

func iniciar_dialogo(novas_falas: Array):
	falas = novas_falas
	indice_atual = 0
	show()
	_mostrar_fala_atual()

func _mostrar_fala_atual():
	if indice_atual < falas.size():
		label_texto.text = falas[indice_atual]
	else:
		# Acabaram os textos! Esconde a caixa e libera o jogo.
		hide()
		tutorial_concluido.emit()

func _proxima_fala():
	indice_atual += 1
	_mostrar_fala_atual()
