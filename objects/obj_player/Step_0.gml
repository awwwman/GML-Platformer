function handleControls() {
	// Handling horizontal movement
	moveDir = keyboard_check(ord("A")) ? -1 : 0;
	moveDir += keyboard_check(ord("D")) ? 1 : 0;

	// Decide whether to apply friction or acceleration based on the distance of the movement direction
	if (!wallBouncing) {
		if (abs(moveDir) > 0) {
			velX = lerp(velX, moveDir * driverSpeed * 1/60, driverAccel);
			if (moveDir) > 0 {
				image_xscale = 1
			} else {
				image_xscale = -1;	
			}
		} else {
			velX = lerp(velX, 0, driverFrict);	
		}
	}
	
	if (abs(onWall) == 0 && grounded && keyboard_check_pressed(vk_space)) {
		velY = -driverJumpMax;
		hasJumped = true;
	} else if (velY < -driverJumpMin && keyboard_check_released(vk_space)) {
		velY = -driverJumpMin;
	}
	
	if (abs(onWall) > 0 && !grounded && keyboard_check_pressed(vk_space) && wallBounceLeft > 0) {
		velY = -driverJumpMax;
		velX = driverBounceAmount * -onWall;
		wallBounceLeft -= 1
		hasJumped = true;
		wallBouncing = true;
		image_xscale = -image_xscale;
		alarm[2] = driverBounceLength;
	}
	
	if (keyboard_check_pressed(ord("1"))) {
		driverSlot = driverSlot > 0 ? 0 : 1
	}
	if (mouse_check_button_pressed(mb_left)) {
		switch driverSlot { 
			case 1:
				var shuriken_instance = instance_create_layer(x, y - 25, "Instances", obj_shuriken);
				shuriken_instance.direction = point_direction(x, y - 25, mouse_x, mouse_y);
				break;
		}
	}
	
	// DRAW EVENT: draw_sprite_ext(drawAnim, frame, x, y, facing, 1, spinny, c_white, 1);
	if (abs(moveDir) > 0 && grounded) {
		sprite_index = spr_player_walk;
	} else if (!grounded) {
		sprite_index = spr_player_air;	
	} else {
		sprite_index = spr_player_idle;	
	}
}

if (hurtBounce) {
	spinny += 20;	
} else {
	spinny = 0;
	handleControls();
}

if (health <= 0 || y > 2660) {
	room_restart();	
}

// Handling collision points separately for each axis
var	remainder = abs(velX);
var step = sign(velX);
var collided = false;
repeat(remainder) {
	for (var i = 0; i < array_length(collision_objs); i++) {
		if place_meeting(x + step, y, collision_objs[i]) {
			if (collision_objs[i] == obj_spike) {
				if (!hurtBounce) {
					hurtBounce = true;
					velY = -15 * (velX == 0 ? 1.5 : 1);
					velX = step * -2;
					health -= 10;
					alarm[0] = hurtTime;
				}	
			} else if (collision_objs[i] == obj_crate) {
				var obj = instance_place(x + step, y, collision_objs[i]);
				obj.velX += step * obj.boxWeight;
			} else {
				velX = 0;
			}
			onWall = step;
			hasJumped = false;
			collided = true;
			break;
		}
	}
	if collided break; 
	x += step;
	onWall = 0;
}

// Apply gravity and then reset to zero if there is a collision point
if (abs(onWall) > 0 && velY > 0 && abs(moveDir) > 0) {
	velY = 0;
} else if (abs(onWall) > 0 && wallBouncing && abs(moveDir) > 0) {
	velY += driverWallFriction * 1/60;
} else {
	velY += driverGravity * 1/60;	
}

var	remainder = abs(velY);
var step = sign(velY);
var collided = false;
repeat(remainder) {
	for (var i = 0; i < array_length(collision_objs); i++) {
		if place_meeting(x, y + step, collision_objs[i]) {
			if (collision_objs[i] == obj_spike) {
				if (!hurtBounce) {
					hurtBounce = true;
					velY = -15 * (velX == 0 ? 1.5 : 1);
					velX = sign(velX) * -5;
					health -= 10;
					alarm[0] = hurtTime;
				}	
			} else {
				velY = 0;
				if (step > 0) {
					grounded = true;
					wasGrounded = true;
					hasJumped = false;
					wallBounceLeft = driverBounceMax;
				}
			}
			collided = true;
			break;
		}
	}
	if collided break
	if (!hasJumped) {
		if (wasGrounded && velY > 0) {
			alarm[1] = coyoteTime;	
			wasGrounded = false;
			continue;
		} else if (grounded && alarm[1] != -1) {
			velY = 0;
			continue;
		}
	}
	grounded = false;
	y += step;
}
