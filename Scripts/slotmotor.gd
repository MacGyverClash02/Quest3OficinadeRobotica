extends ColorRect # (Ou TextureRect, dependendo do seu nó)

var total_energia: float = 0.0
var altura_maxima_slot: float

func _ready():
	# Descobre o tamanho total da caixa para a animação
	altura_maxima_slot = size.y
	$CargaVisual.size.y = 0
	$CargaVisual.position.y = altura_maxima_slot

func _can_drop_data(_at_position, data):
	# Só deixa soltar se os dados tiverem a palavra "valor"
	return typeof(data) == TYPE_DICTIONARY and data.has("valor")

func _drop_data(_at_position, data):
	# Soma a energia e destrói a peça que foi arrastada
	total_energia += data["valor"]
	data["node_referencia"].queue_free()
	
	atualizar_visual()
	_verificar_status()

func atualizar_visual():
	# Limita o visual a 1.0 (100%) para a barra não sair voando da tela
	var energia_visual = min(total_energia, 1.0) 
	var nova_altura = altura_maxima_slot * energia_visual
	
	# Anima a barra de carga subindo
	var tween = create_tween()
	tween.tween_property($CargaVisual, "size:y", nova_altura, 0.3)
	tween.parallel().tween_property($CargaVisual, "position:y", altura_maxima_slot - nova_altura, 0.3)

func _verificar_status():
	var label = $LabelBateria
	
	if total_energia == 1.0:
		label.text = "ENERGIA 100%!"
		Global.bateria_consertada = true
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
		
	elif total_energia > 1.0:
		label.text = "SOBRECARGA! Reiniciando..."
		
		# Pinta o fundo do slot de vermelho
		color = Color.INDIAN_RED 
		
		# PINTA A BARRINHA DE VERMELHO TAMBÉM! (O inseto morre aqui)
		if $CargaVisual != null:
			$CargaVisual.color = Color.INDIAN_RED 
		
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
