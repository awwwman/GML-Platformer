velX = lerp(velX, 0, boxFrict);

var	remainder = abs(velX);
var step = sign(velX);
repeat(remainder) {
	if place_meeting(x + step, y, obj_block) || place_meeting(x + step, y, obj_spike) {
		velX = 0
		break;
	} else if place_meeting(x + step, y, obj_crate) {
		instance_place(x + step, y, obj_crate).velX += step
		break
	}
	x += step;
}

velY += boxGravity * 1/60;
var	remainder = abs(velY);
var step = sign(velY);
repeat(remainder) {
	if place_meeting(x, y + step, obj_block) || place_meeting(x, y + step, obj_spike) || place_meeting(x, y + step, obj_crate) {
		velY = 0;
		break;
	}
	y += step;
}
