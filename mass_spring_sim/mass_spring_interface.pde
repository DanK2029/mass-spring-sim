int mouseInsideBall() {
  for (int i = 0; i < ballList.size(); i++) {
    float ballX = ballList.get(i).xPos;
    float ballY = ballList.get(i).yPos;
    float dist = sqrt(sq(ballX - mouseX) + sq(ballY - (height-mouseY)));
    if (dist <= ballRadius) {
      ballList.get(i).dragged = true;
      return i;
    }
  }
  return -1;
}

void keyReleased() {
  if (key == 'g') {
    if (gravity == -10) {
      gravity = 0.0;
    } else {
      gravity = -10;
    }
  }
  
  if (key == 'i') {
    if (curIterator == "halfStep") {
      curIterator = "eulerForward";
    } else {
      curIterator = "halfStep";
    }
  }
    
}

void mousePressed() {
  draggedBallIndex = mouseInsideBall();
  if (draggedBallIndex != -1) {
    ballList.get(draggedBallIndex).xPos = mouseX;
    ballList.get(draggedBallIndex).yPos = height-mouseY;
  } else {
    mouseBall.xPos = mouseX;
    mouseBall.yPos = height-mouseY;
  }
}

void mouseDragged(){
  if (draggedBallIndex != -1) {
    ballList.get(draggedBallIndex).xPos = mouseX;
    ballList.get(draggedBallIndex).yPos = height-mouseY;
  } else {
    mouseBall.xPos = mouseX;
    mouseBall.yPos = height-mouseY;
  }
}

void mouseReleased(){
  float mouseXVel = (mouseX - pmouseX)/tDelta;
  float mouseYVel = ((height-mouseY) - (height-pmouseY))/tDelta;
  
  if (draggedBallIndex != -1) {
    ballList.get(draggedBallIndex).xForce = mouseXVel;
    ballList.get(draggedBallIndex).yForce = mouseYVel;
    ballList.get(draggedBallIndex).dragged = false;
    draggedBallIndex = -1;
    
  } else {
    MassBall newBall = new MassBall(mouseX, height-mouseY, 1.0);
    newBall.xForce = 5*mouseXVel;
    newBall.yForce = 30*mouseYVel;
    ballList.add(newBall);
  }
}