player = instance_find(obj_player, 0);
cameraW = camera_get_view_width(view_camera[0]);
cameraH = camera_get_view_height(view_camera[0]);
curPosX = 0;
curPosY = 0;
smooth = 0.3;
limitX = [0, room_width];
limitY = [0, room_height];