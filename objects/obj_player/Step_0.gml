function handleControls() {
	// Handling horizontal movement
	moveDir = keyboard_check(ord("A")) ? -1 : 0;
	moveDir += keyboard_check(ord("D")) ? 1 : 0;

	// Decide whether to apply friction or acceleration based on the distance of the movement direction
	if (abs(moveDir) > 0) {
		velX = lerp(velX, moveDir * driverSpeed * 1/60, driverAccel);
		if (moveDir) > 0 {
			facing = 1
		} else {
			facing = -1;	
		}
	} else {
		velX = lerp(velX, 0, driverFrict);	
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
	}
	
	if (abs(moveDir) > 0 && grounded) {
		drawAnim = spr_player_walk;
	} else if (!grounded) {
		drawAnim = spr_player_air;	
	} else {
		drawAnim = spr_player_idle;	
	}
}

if (hurtBounce) {
	spinny += 20;	
} else {
	spinny = 0;
	handleControls();
}

// Handling collision points separately for each axis
var	remainder = abs(velX)
var step = sign(velX)
var collided = false;
repeat(remainder) {
	for (var i = 0; i < array_length(collision_objs); i++) {
		if place_meeting(x + step, y, collision_objs[i]) {
			if (collision_objs[i] == obj_spike) {
				if (!hurtBounce) {
					hurtBounce = true;
					velY = -15;
					velX = sign(velX) * -2;
					health -= 10;
					alarm[0] = hurtTime;
				}	
			} else {
				velX = 0;
				onWall = step;
				hasJumped = false;
			}
			collided = true;
			break;
		}
	}
	if collided break; 
	x += step;
	onWall = 0;
}

// Apply gravity and then reset to zero if there is a collision point
if (abs(onWall) > 0 && wallBounceLeft > 0 && !grounded && velY > 0) {
	velY = 0
} else {
	velY += driverGravity * 1/60	
}

var	remainder = abs(velY)
var step = sign(velY)
var collided = false;
repeat(remainder) {
	for (var i = 0; i < array_length(collision_objs); i++) {
		if place_meeting(x, y + step, collision_objs[i]) {
			if (collision_objs[i] == obj_spike) {
				if (!hurtBounce) {
					hurtBounce = true;
					velY = -15;
					velX = sign(velX) * -2;
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
