extends TextureRect # Mudamos de ColorRect para TextureRect

var valor: float = 0.0 

func _get_drag_data(_at_position):
	# 1. Cria uma cópia visual exata (preview) para seguir o mouse
	var preview = TextureRect.new()
	# Copia a textura e o tamanho atual da peça
	preview.texture = self.texture 
	preview.size = size
	
	# Centraliza a peça embaixo do mouse
	set_drag_preview(preview)
	
	# Retorna o pacote de dados para o Slot
	return {
		"valor": valor, 
		"node_referencia": self
	}
