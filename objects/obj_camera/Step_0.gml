curPosX = lerp(curPosX, clamp(player.x, limitX[0], limitX[1]), smooth);
curPosY = lerp(curPosY, clamp(player.y, limitY[0], limitY[1]), smooth);
camera_set_view_pos(view_camera[0], curPosX - (cameraW/2), curPosY - (cameraH/2));