class_name PlayerGunAudio extends AudioStreamPlayer

const sounds: Dictionary[String, AudioStream] = {
	"shot": preload("uid://g00370uk6ud5"),
	"slam": preload("uid://dt44rycts6ytr"),
	"click": preload("uid://c2ao0bpu7qxi5"),
	"slide": preload("uid://cd2rej13v8g68")
	
}

func play_sound(sound_name: String = "click"):
	var sound_stream = sounds.get(sound_name)
	stream = sound_stream if sound_stream else sounds.get("click")

	pitch_scale = remap(randf(), 0, 1, 0.8, 1.4)
	play(0.0)
