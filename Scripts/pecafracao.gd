extends Control

@export var valor_fracao: float = 0.5
@export var texto_exibicao: String = "1/2"
@export var cor_peça: Color = Color.CORNFLOWER_BLUE

func _ready():
	$CorFundo.color = cor_peça
	$CorFundo/LabelFracao.text = texto_exibicao

func _get_drag_data(_at_position):
	var data = {
		"valor": valor_fracao,
		"node_referencia": self
	}
	
	var preview = ColorRect.new()
	preview.size = $CorFundo.size
	preview.color = cor_peça
	preview.modulate.a = 0.6 # Fica transparente
	
	# Centraliza a prévia sob o mouse
	var control = Control.new()
	control.add_child(preview)
	preview.position = -preview.size / 2
	
	set_drag_preview(control)
	return data
