extends Label

@onready var timer = $Timer
@onready var ballon_interact = $ballon_interact

# O texto completo a ser exibido.
var full_text: String = "Parabens por subir aqui, agora desce que não tem mais nada"
# O texto atualmente visível.
var current_text: String = ""
# O índice do próximo caractere a ser adicionado.
var current_index: int = 0
var timer_wait := false
var start_show_text := false;

func _ready():
	# Inicia o processo de digitação.
	set_process(true)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		start_show_text = true
	daitlografar()

func daitlografar():
	if current_index < full_text.length() && timer_wait && start_show_text:
		timer_wait = false;
		current_text += full_text[current_index]
		current_index += 1
		self.set_text(current_text)
		# Espera antes de adicionar o próximo caractere.
		timer.start()

func _on_timer_timeout():
	timer_wait = true;

func _on_area_2d_body_entered(body):
	if body.name == "Character":
		current_text = ""
		print("Player entrou na area, iniciar datilografia")
		ballon_interact.show()
		timer_wait = true
		self.set_text(current_text)
		self.show()

func _on_area_2d_body_exited(body):
	if body.name == "Character":
		print("Player saiu da area")
		current_text = ""
		current_index = 0
		timer_wait = false;
		start_show_text = false
		ballon_interact.hide()
		self.set_text(current_text)
		self.hide()
