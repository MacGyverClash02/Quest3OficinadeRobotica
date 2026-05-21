extends ColorRect

var total_energia: float = 0.0

func _can_drop_data(_at_position, data):
	# Só aceita se o que estivermos arrastando tiver um "valor"
	return typeof(data) == TYPE_DICTIONARY and data.has("valor")

func _drop_data(_at_position, data):
	# Soma o valor da peça à energia do motor
	total_energia += data["valor"]
	
	# Remove a peça da lista de opções (ela foi usada)
	data["node_referencia"].queue_free()
	
	_verificar_status()

func _verificar_status():
	var label = $LabelBateria
	
	if total_energia == 1.0:
		color = Color.MEDIUM_SPRING_GREEN
		label.text = "SOMA: 1.0 - MOTOR LIGADO!"
		
		# --- AS 3 LINHAS QUE FALTAVAM AQUI ---
		
		#
		Global.bateria_consertada = true
		
		# 2. Espera 2 segundinhos para a criança ver que acertou
		await get_tree().create_timer(2.0).timeout
		
		# 3. Volta para o Hub (Certifique-se de que o nome do arquivo está exato!)
		get_tree().change_scene_to_file("res://Cenas/OficinaMain.tscn")
		
		# -------------------------------------
		
	elif total_energia > 1.0:
		color = Color.INDIAN_RED
		label.text = "SOBRECARGA! (Passou de 1)"
	else:
		label.text = "ENERGIA ATUAL: " + str(total_energia)
