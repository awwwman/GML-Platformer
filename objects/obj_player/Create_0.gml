// driver physics properties
collision_objs = [obj_block, obj_crate, obj_spike];
driverScaleX = 16;
driverScaleY = 28;
driverGravity = 64;

// driver movement properties
driverSpeed = 360;
driverAccel = 0.15;
driverFrict = 0.2;
driverJumpMax = 20;
driverJumpMin = 2.5;
driverBounceAmount = 15;
driverBounceMax = 5;
driverBounceLength = 5;
driverWallFriction = 4;

// driver movement variables
velX = 0;
velY = 0;
moveDir = 0;
grounded = false;
health = 50;
healthMax = 100;
hurtBounce = false;
hurtTime = 30;
hasJumped = false;
coyoteTime = 5;
wasGrounded = false;
onWall = 0;
wallBouncing = false;
wallBounceLeft = 2;

// driver draw variables
facing = 1;
spinny = 0;
drawAnim = spr_player_idle;
frame = 0;

driverSlot = 1;
