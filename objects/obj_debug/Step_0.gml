if keyboard_check(vk_f12) {
global.PlayerHP = 69
global.PlayerMaxHP = 69
obj_debug.visible = true
audio_play_sound(Heal, 0, false)
}
