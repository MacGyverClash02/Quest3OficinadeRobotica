extends Control

const PecaFracao = preload("res://Cenas/PecaFracao.tscn")

@onready var caixa_dialogo = $CaixaDialogo

var valores_baterias = [0.5, 0.25, 0.25, 0.6, 0.3]

func _ready():
	var historinha_bateria = [
		"Estação de Energia ligada!",
		"O Arduino Uno do robô precisa exatamente de 1 bateria inteira de energia para funcionar (1.0).",
		"Junte os pedaços fracionados, como 1/2 e 1/4, para encher o tanque de bateria.",
		"Mas cuidado: se a soma passar de 1, o sistema vai sobrecarregar e dar curto-circuito!"
	]
	caixa_dialogo.iniciar_dialogo(historinha_bateria)
	await caixa_dialogo.tutorial_concluido
	
	gerar_pecas() # Só gera o jogo depois que ler
func gerar_pecas():
	var area = $AreaBandeja
	var rect = area.get_global_rect()
	
	var mapa_texturas = {
		0.5: preload("res://Assets/Bateria1_2.PNG"),
		0.25: preload("res://Assets/Bateria1_4.PNG"),
		0.6: preload("res://Assets/Bateria1_3_5.png"),
		0.3: preload("res://Assets/Bateria1__3_10.PNG")
	}
	
	for i in range(valores_baterias.size()):
		var valor_sorteado = valores_baterias[i]
		
		var nova_peca = PecaFracao.instantiate()
		add_child(nova_peca)
		
		nova_peca.valor = valor_sorteado 
		
		if mapa_texturas.has(valor_sorteado):
			nova_peca.texture = mapa_texturas[valor_sorteado]
		
		# --- CORREÇÃO DO LABEL PARA FRAÇÕES EDUCACIONAIS ---
		# Dicionário que traduz o valor matemático invisível para o texto na tela
		var mapa_textos_fracoes = {
			0.5: "1/2",
			0.25: "1/4",
			0.6: "3/5", # Pegadinha de sobrecarga
			0.3: "3/10" # Pegadinha pirata
		}
		
		var texto_fracao = nova_peca.find_child("LabelFracao", true, false)
		if texto_fracao != null:
			# Checa se o valor tem uma tradução no nosso dicionário
			if mapa_textos_fracoes.has(valor_sorteado):
				texto_fracao.text = mapa_textos_fracoes[valor_sorteado]
			else:
				texto_fracao.text = str(valor_sorteado) # Prevenção de erro
			
			texto_fracao.visible = true
		# ---------------------------------------------------
		
		var pos_x = rect.position.x + 30 + (i * 20) 
		var pos_y = rect.position.y + 30 + (i * 65)
		
		nova_peca.global_position = Vector2(pos_x, pos_y)
