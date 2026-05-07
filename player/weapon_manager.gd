class_name WeaponManager extends Node

@export var ammo: int = 0

@export_category("Resources")
@export var gun: Gun
@export var mags: Array[Mag]

@export_category("Nodes")
@export var player: Player
@export var bullet_spawner: BulletSpawner
@export var gun_reticle: Sprite3D
@export var gun_audio: PlayerGunAudio

@export_category("Flipbooks")
@export var gun_mesh: Flipbook3D
@export var mag_mesh: Flipbook3D


func _process(_delta: float) -> void:
	# TODO: get input
	# TODO: check animation interupt




	if gun_mesh.animation_lock or mag_mesh.animation_lock: return

	if gun.current_state == Gun.state.DEFAULT: handle_default()
	if gun.current_state == Gun.state.AIMING: handle_aiming()
	if gun.current_state == Gun.state.COCKED: handle_cocked()
	if gun.current_state == Gun.state.UNLOADING: handle_unloaded()


func handle_default():
	if Input.is_action_just_pressed("fire") and gun.mag.ammo == 0:
		gun_audio.play_sound()

	if Input.is_action_just_pressed("cock"):
		gun_audio.play_sound("slide")
		gun.current_state = Gun.state.COCKED
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_mesh.play_animation(5, 0, 3)
		return

	if Input.is_action_just_pressed("switch next"):
		pass # TODO: switch to next gun

	if Input.is_action_just_pressed("switch prev"):
		pass # TODO: switch to prev gun

	if Input.is_action_pressed("fire"):
		if not bullet_spawner.fire_bullet(): return
		gun_mesh.play_animation(0, 0, 4, func(): print(gun.mag.ammo))
		return

	if Input.is_action_just_pressed("reload"):
		mag_mesh.fallback_frame = gun.mag.get_fallback_frame()
		var mag_visible := func(): mag_mesh.visible = true
		gun_reticle.visible = false

		gun.current_state = Gun.state.UNLOADING
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_audio.play_sound("slide")
		gun_mesh.play_animation(5, 0, 3, gun_mesh.play_animation.bind(3, 4, 7, mag_visible))
		return

	if Input.is_action_just_pressed("aim"):
		bullet_spawner.position.y = gun.bullet_aim_vertical_offset
		gun_reticle.visible = false

		gun.current_state = Gun.state.AIMING
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_mesh.play_animation(1, 0, 7)
		return


func handle_aiming():
	if Input.is_action_just_pressed("fire") and gun.mag.ammo == 0:
		gun_audio.play_sound()

	if not Input.is_action_pressed("aim"):
		bullet_spawner.position.y = gun.bullet_vertical_offset
		gun_reticle.visible = true

		gun.current_state = Gun.state.DEFAULT
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_mesh.play_animation(1, 7, 0)
		return

	if Input.is_action_pressed("fire"):
		if not bullet_spawner.fire_bullet(): return
		gun_mesh.play_animation(2, 0, 4, func(): print(gun.mag.ammo))
		return


func handle_cocked():
	var wants_to_uncock := (
		Input.is_action_just_pressed("cock") or 
		Input.is_action_just_pressed("aim") or 
		Input.is_action_just_pressed("fire")
	)

	if wants_to_uncock:
		gun_audio.play_sound("slam")
		gun.current_state = Gun.state.DEFAULT
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_mesh.play_animation(5, 3, 0)
		return
	if Input.is_action_just_pressed("reload"):
		mag_mesh.fallback_frame = gun.mag.get_fallback_frame()
		var mag_visible := func(): mag_mesh.visible = true
		gun_reticle.visible = false

		gun.current_state = Gun.state.UNLOADING
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_audio.play_sound("slide")
		gun_mesh.play_animation(3, 4, 7, mag_visible)


func handle_unloaded():
	if not Input.is_action_pressed("reload"):
		mag_mesh.fallback_frame = gun.mag.get_fallback_frame()
		mag_mesh.visible = false
		gun_reticle.visible = true

		gun.current_state = Gun.state.COCKED
		gun_mesh.fallback_frame = gun.get_fallback_frame()
		gun_audio.play_sound("slide")
		gun_mesh.play_animation(3, 7, 4)
		return

	if Input.is_action_just_pressed("switch next"):
		pass # TODO: switch to next mag

	if Input.is_action_just_pressed("switch prev"):
		pass # TODO: switch to prev mag

	if Input.is_action_just_pressed("fire"):
		if gun.mag.ammo >= gun.mag.max_ammo or ammo <= 0: return
		var offset = 0 if gun.mag.ammo <= 0 else 3
		gun.mag.ammo += 1
		ammo -= 1

		mag_mesh.fallback_frame = gun.mag.get_fallback_frame()
		mag_mesh.play_animation(4, 2 + offset, 4 + offset, func(): print(gun.mag.ammo))
		return

	if Input.is_action_just_pressed("aim"):
		if gun.mag.ammo <= 0: return
		gun.mag.ammo -= 1
		ammo += 1
		var offset = 0 if gun.mag.ammo <= 0 else 3

		mag_mesh.fallback_frame = gun.mag.get_fallback_frame()
		mag_mesh.play_animation(4, 4 + offset, 2 + offset, func(): print(ammo))
		return
