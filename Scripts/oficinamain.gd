extends Control

@onready var caixa_dialogo = $CaixaDialogo
@onready var oficina_sprite = $OficinaSprite

@onready var botao_bateria = $BotaoBateria
@onready var botao_ponte_h = $BotaoPonteH
@onready var botao_engrenagem = $BotaoEngrenagem
@onready var botao_radar = $BotaoRadar
@onready var botao_protoboard = $BotaoProtoboard

var texturas_cenario = [
	preload("res://Assets/FPG2.png"), 
	preload("res://Assets/FPG2_1.png"), 
	preload("res://Assets/FPG2_2.png")  
]

var tween_destaque: Tween 

func _ready():
	botao_bateria.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MinigameBateria.tscn"))
	botao_ponte_h.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MinigamePonteH.tscn"))
	botao_engrenagem.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MinigameEngrenagem.tscn"))
	botao_radar.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MinigameRadar.tscn"))
	botao_protoboard.pressed.connect(func(): get_tree().change_scene_to_file("res://Cenas/MinigameProtoboard.tscn"))
	
	_atualizar_visuais_progresso()
	_atualizar_botoes_por_progresso()
	_tocar_dialogo_se_necessario()

func _atualizar_visuais_progresso():
	var estagio_visual = 0
	
	if Global.progresso <= 1:
		estagio_visual = 0 
	elif Global.progresso <= 3:
		estagio_visual = 1 
	else:
		estagio_visual = 2 
		
	oficina_sprite.texture = texturas_cenario[estagio_visual]

func _atualizar_botoes_por_progresso():
	if tween_destaque:
		tween_destaque.kill() 
		
	var todos_botoes = [botao_bateria, botao_ponte_h, botao_engrenagem, botao_radar, botao_protoboard]
	for btn in todos_botoes:
		btn.mouse_filter = Control.MOUSE_FILTER_IGNORE # Bloqueia clique inicial por segurança
		btn.modulate = Color.WHITE

	# A peça só aparece se ainda não foi consertada
	botao_bateria.visible = not Global.bateria_consertada
	botao_ponte_h.visible = not Global.ponte_h_consertada
	botao_engrenagem.visible = not Global.engrenagem_consertada
	botao_radar.visible = not Global.radar_consertado
	botao_protoboard.visible = not Global.protoboard_consertado

	# Anima apenas a próxima peça da sequência
	if Global.progresso == 0 and not Global.bateria_consertada:
		_animar_botao_atual(botao_bateria)
	elif Global.progresso == 1 and not Global.ponte_h_consertada:
		_animar_botao_atual(botao_ponte_h)
	elif Global.progresso == 2 and not Global.engrenagem_consertada:
		_animar_botao_atual(botao_engrenagem)
	elif Global.progresso == 3 and not Global.radar_consertado:
		_animar_botao_atual(botao_radar)
	elif Global.progresso == 4 and not Global.protoboard_consertado:
		_animar_botao_atual(botao_protoboard)

func _animar_botao_atual(botao: TextureButton):
	# MODIFICAÇÃO: Garante que o botão reage ao mouse ao ficar ativo
	botao.mouse_filter = Control.MOUSE_FILTER_STOP 
	
	tween_destaque = create_tween().set_loops() 
	tween_destaque.tween_property(botao, "modulate", Color(0.8, 1.2, 1.5, 0.6), 0.5)
	tween_destaque.tween_property(botao, "modulate", Color.WHITE, 0.5)

func _tocar_dialogo_se_necessario():
	if Global.progresso == 0:
		if tween_destaque:
			tween_destaque.pause()
		
		# MODIFICAÇÃO: Impede clique na bateria usando mouse_filter durante o diálogo
		botao_bateria.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var historinha_intro = [
			"Olá, jovem engenheiro! Bem-vindo à sua nova Oficina de Robótica.",
			"Nossa missão de hoje é incrível: precisamos montar o cérebro e o corpo de um Robô Seguidor de Linha!",
			"Ele está todo desmontado. Clique nas peças brilhantes na bancada para consertá-las usando a matemática."
		]
		
		caixa_dialogo.iniciar_dialogo(historinha_intro)
		await caixa_dialogo.tutorial_concluido
		
		# MODIFICAÇÃO: Libera o clique da bateria de volta ao terminar o diálogo
		botao_bateria.mouse_filter = Control.MOUSE_FILTER_STOP
		if tween_destaque:
			tween_destaque.play()
