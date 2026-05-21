extends Control

const PecaFracao = preload("res://Cenas/PecaFracao.tscn")

var valores_baterias = [0.5, 0.25, 0.25, 0.6, 0.3]

func _ready():
	gerar_pecas()

func gerar_pecas():
	var area = $AreaBandeja
	var rect = area.get_global_rect()
	
	var mapa_texturas = {
		0.5: preload("res://Assets/Bateria1_2.PNG"),
		0.25: preload("res://Assets/Bateria1_4.PNG"),
		0.6: preload("res://Assets/Bateria1_0.PNG"),
		0.3: preload("res://Assets/Bateria1_0.PNG")
	}
	
	for i in range(valores_baterias.size()):
		var valor_sorteado = valores_baterias[i]
		
		var nova_peca = PecaFracao.instantiate()
		add_child(nova_peca)
		
		nova_peca.valor = valor_sorteado 
		
		if mapa_texturas.has(valor_sorteado):
			nova_peca.texture = mapa_texturas[valor_sorteado]
		
		var texto_fracao = nova_peca.find_child("LabelFracao", true, false)
		if texto_fracao != null:
			texto_fracao.visible = false
		
		var pos_x = rect.position.x + 30 + (i * 20) 
		var pos_y = rect.position.y + 30 + (i * 65)
		
		nova_peca.global_position = Vector2(pos_x, pos_y)
