extends Control

@onready var chave_a = $ChaveA
@onready var chave_b = $ChaveB
@onready var chave_c = $ChaveC
@onready var chave_d = $ChaveD
@onready var motor_sprite = $MotorSprite
@onready var label_status = $LabelStatus

var velocidade_motor = 0.0

func _ready():
	chave_a.toggled.connect(_ao_mudar_chave)
	chave_b.toggled.connect(_ao_mudar_chave)
	chave_c.toggled.connect(_ao_mudar_chave)
	chave_d.toggled.connect(_ao_mudar_chave)

func _process(delta):
	motor_sprite.rotation += velocidade_motor * delta

func _ao_mudar_chave(_estado):
	var a = chave_a.button_pressed
	var b = chave_b.button_pressed
	var c = chave_c.button_pressed
	var d = chave_d.button_pressed
	
	if (a and c) or (b and d) or (a and b and c and d):
		label_status.text = "CURTO-CIRCUITO!"
		label_status.modulate = Color.RED
		velocidade_motor = 0.0
	elif a and d and not b and not c:
		label_status.text = "FRENTE"
		label_status.modulate = Color.GREEN
		velocidade_motor = 5.0
	elif b and c and not a and not d:
		label_status.text = "TRAS"
		label_status.modulate = Color.GREEN
		velocidade_motor = -5.0
	else:
		label_status.text = "PARADO"
		label_status.modulate = Color.WHITE
		velocidade_motor = 0.0
