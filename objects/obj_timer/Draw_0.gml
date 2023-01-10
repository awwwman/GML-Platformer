switch(room) {
	case rm_victory:
		draw_set_halign(fa_center);
		var c = c_yellow;
		draw_text_transformed_color(room_width/2, 100, "YOU FINISHED!", 3, 3, 0, c, c, c, c, 1);
		draw_text(room_width/2, 200, "Your total time:");
		c = c_white
		draw_text_transformed_color(room_width/2, 250, string(totalSeconds) + " seconds", 2, 2, 0, c, c, c, c, 1);
		draw_text(room_width/2, 350, "Press ENTER to retry");
		draw_set_halign(fa_left);
		break;
}