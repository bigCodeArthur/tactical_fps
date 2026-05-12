class_name PlayerUI extends Control

@export var player: Player

@onready var mag_container: MarginContainer = $MarginContainer/MagContainer
@onready var ammo_status: AmmoStatus = $AmmoStatus

func _process(_delta: float) -> void:
	var player_gun = player.weapon_manager.gun

	ammo_status.value.text = str(player_gun.mag.ammo)

	if player_gun.current_state == Gun.state.UNLOADING:
		mag_container.visible = true
		ammo_status.visible = true
	else:
		mag_container.visible = false
		ammo_status.visible = false
