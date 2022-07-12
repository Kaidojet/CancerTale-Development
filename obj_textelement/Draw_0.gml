// Colour and font
var colour = DefaultColour;
var font = font_battle_dialogue;

// Default positioning
var sentence_x = 0;
var sentence_y = 0;

// Set the parameters for the space between letters and lines, mess with it all you want
var line_spacing = 30;
var letter_spacing = 16;
if (Talker == "Papyrus") {
	font = font_speech_papyrus;
	line_spacing = 15;
	letter_spacing = 10;
}
if (Talker == "SansA" || Talker == "SansB") {
	font = font_speech_sans;
	line_spacing = 15;
	letter_spacing = 9;
}
if (Talker == "Gaster") {
	font = font_gaster;
	line_spacing = 15;
	letter_spacing = 13;
}
if (room != BattleRoom && room != Room_GameOver) {
	font = font_battle_dialogue_overworld;
	line_spacing /= 2;
	letter_spacing /= 2;
}
else {
	if Talker == "Normal" && instance_exists(obj_SpeechBubble) {
		font = font_speech_bubble;
		line_spacing = 15;
		letter_spacing = 9;
	}
}

// Draws every letter that it has so far
for (var i = 0; i < TextLength; i++) {
	// Makes the text colour default, you can set it to whatever you want if you use the code below
	if string_char_at(TextToDraw, i + 1) == "~" {
		if string_char_at(TextToDraw, i + 2) == "R"
			colour = c_red;
		if string_char_at(TextToDraw, i + 2) == "O"
			colour = c_orange;
		if string_char_at(TextToDraw, i + 2) == "Y"
			colour = c_yellow;
		if string_char_at(TextToDraw, i + 2) == "G"
			colour = c_lime;
		if string_char_at(TextToDraw, i + 2) == "A"
			colour = c_aqua;
		if string_char_at(TextToDraw, i + 2) == "B"
			colour = c_blue;
		if string_char_at(TextToDraw, i + 2) == "P"
			colour = c_fuchsia;
		if string_char_at(TextToDraw, i + 2) == "D"
			colour = DefaultColour;
		i += 2;
	}
	
	draw_set_color(colour);
	draw_set_font(font);
	
	// New line, use "}&" to include the & symbol otherwise it gets cancelled out
	// USAGE: "89 Snowdin Lane&Underground }& Co"
	if (string_char_at(TextToDraw, i + 1) == "&" && string_char_at(TextToDraw, i) != "}") {
		sentence_x = 0;
		sentence_y += line_spacing;
		i += 1;
	}
	
	// Used for text delays. Only use this for some long or creepy sentences.
	// USAGE: "@4You'd be dead where you stand."
	if (string_char_at(TextToDraw, i + 1) == "@") {
		TextDelay = 2 * real(string_char_at(TextToDraw, i + 2));
		if (TextDelay < 2) {
			TextDelay = 2;
		}
		i += 2;
	}
	
	// Draw the letters with the correct spacing, as defined above
	draw_text(x + sentence_x, y + sentence_y, string_char_at(TextToDraw, i + 1));
	sentence_x += letter_spacing;
}

// Sets the number of letters to draw, it ignores everything that we cancelled out above
if IsWriting {
	CurrentDelay += 1;
	if (CurrentDelay >= TextDelay) {
		CurrentDelay = 0;
		TextLength += 1;
		if string_char_at(TextToDraw, TextLength) != " " && CurrentDelay == 0 {
			if Talker == "Normal" audio_play_sound(Talk_Normal, 20, false);
			if Talker == "Battle" audio_play_sound(Talk_Battle, 20, false);
			if Talker == "Alphys" audio_play_sound(Talk_Alphys, 20, false);
			if Talker == "Asgore" audio_play_sound(Talk_Asgore, 20, false);
			if Talker == "AsrielA" audio_play_sound(Talk_AsrielChild, 20, false);
			if Talker == "AsrielB" audio_play_sound(Talk_AsrielGod, 20, false);
			if Talker == "FloweyA" audio_play_sound(Talk_Flowey, 20, false);
			if Talker == "FloweyB" audio_play_sound(Talk_FloweyEvil, 20, false);
			if Talker == "Gaster" {
				var snd = choose(Talk_Gaster1, Talk_Gaster2, Talk_Gaster3, Talk_Gaster4, Talk_Gaster5, Talk_Gaster6, Talk_Gaster7);
				audio_play_sound(snd, 20, false);
			}
			if Talker == "Papyrus" audio_play_sound(Talk_Papyrus, 20, false);
			if Talker == "SansA" audio_play_sound(Talk_Sans, 20, false);
			if Talker == "SansB" audio_play_sound(Talk_SansToriel, 20, false);
			if Talker == "Toriel" audio_play_sound(Talk_Toriel, 20, false);
			if Talker == "UndyneA" audio_play_sound(Talk_Undyne, 20, false);
			if Talker == "UndyneB" audio_play_sound(Talk_UndyneTheUndying, 20, false);
		}
		
		// Puts half a second of delay inbetween sentences.
		// USAGE: "I told you. I emptied the trash! What else do you want?"
		if (string_char_at(TextToDraw, TextLength) == "." || string_char_at(TextToDraw, TextLength) == "?" || string_char_at(TextToDraw, TextLength) == "!") {
			CurrentDelay = -30;
		}
		
		// Slight pause in the middle of a sentence.
		// USAGE: "Well, don't you have anything else? I can help, it's the least I can do."
		if (string_char_at(TextToDraw, TextLength) == ",") {
			CurrentDelay = -15;
		}
		
		// Stops writing the text
		if (TextLength >= string_length(TextToDraw)) {
			IsWriting = false;
		}
	}
	if (keyboard_check(ord("X")) || keyboard_check(ord("C"))) {
		TextLength = string_length(TextToDraw);
		IsWriting = false;
	}
}
else {
	// Moves on to the next line of text, or destroy the writer
	if ((keyboard_check_pressed(ord("Z")) || keyboard_check(ord("C"))) && CanAdvance) {
		TextLength = 0;
		TextDelay = 2;
		CurrentDelay = 0;
		
		// Checks if there is any text in the queue
		if variable_instance_exists(id, "TextQueue") {
			// Checks if the queue is exhausted
			// Without this, your game will CRASH because it's trying to look in an unknown area of memory
			if (NumInQueue >= array_length(TextQueue)) {
				instance_destroy();
				exit;
			}
			TextToDraw = TextQueue[NumInQueue];
		}
		else {
			// Sets the text to a signalling value to destroy the instance
			TextToDraw = "{end}";
		}
		
		IsWriting = true;
		if (TextToDraw == "" || TextToDraw == "{end}") {
			instance_destroy();
		}
		NumInQueue += 1;
	}
}