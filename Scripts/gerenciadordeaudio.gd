extends Node

@onready var player_clique = $PlayerClick

func _ready():
	# Fica vigiando o jogo: qualquer nó novo que aparecer na tela vai passar por aqui
	get_tree().node_added.connect(_configurar_botao)
	
	# Para garantir, varre os nós que já nasceram junto com o jogo
	_varrer_arvore_para_botoes(get_tree().root)

# Função que verifica se o nó é um botão e injeta o som nele
func _configurar_botao(node: Node):
	# "BaseButton" engloba Button, TextureButton, e todos os tipos de botão do Godot!
	if node is BaseButton:
		# Verifica se já não conectamos antes para não tocar duas vezes
		if not node.pressed.is_connected(_tocar_som_clique):
			node.pressed.connect(_tocar_som_clique)

func _tocar_som_clique():
	player_clique.play()

# Uma função "varredora" que procura botões escondidos dentro de outros contêineres
func _varrer_arvore_para_botoes(node: Node):
	_configurar_botao(node)
	for filho in node.get_children():
		_varrer_arvore_para_botoes(filho)
