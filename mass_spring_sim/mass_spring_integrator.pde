void eulerForward(int n, float tDelta) {
  for (int i = 0; i < n; i++) {
    
    for (int j = 0; j < tempBallList.size(); j++) {
      if (draggedBallIndex != j) {
        MassBall tempBall = tempBallList.get(j);
        applyFrictionAndBounceForce(tempBall);
        
        //draw force
        /*stroke(255,0,0);
        line(tempBall.xPos, height-tempBall.yPos, tempBall.xPos+tempBall.xForce, height-tempBall.yPos);
        noStroke();
        */
        float newXAcc = tempBall.xForce;
        float newYAcc = tempBall.yForce;
        
        float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
        float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
        
        float newXPos = tempBall.xPos + (tDelta * tempBall.xVel);
        float newYPos = tempBall.yPos + (tDelta * tempBall.yVel);
        
        
        ballList.get(j).xAcc = newXAcc;
        ballList.get(j).yAcc = newYAcc;
        
        ballList.get(j).xVel = newXVel;
        ballList.get(j).yVel = newYVel;
        
        ballList.get(j).xPos = newXPos;
        ballList.get(j).yPos = newYPos;
        boundCheck(ballList.get(j));
      }
    }
    tempBallList = realCopyMassBallList(tempBallList, ballList);
  }
}

void halfStep(int n, float tDelta) {
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < tempBallList.size(); j++) {
      if (draggedBallIndex != j) {
        MassBall tempBall = tempBallList.get(j);
        
        float newXAcc = tempBall.xForce;
        float newYAcc = tempBall.yForce;
        
        float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
        float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
        
        float newXPos = tempBall.xPos + (tDelta*(tempBall.xVel + newXVel)/2.0);
        float newYPos = tempBall.yPos + (tDelta*(tempBall.yVel + newYVel)/2.0);
        
        ballList.get(j).xAcc = newXAcc;
        ballList.get(j).yAcc = newYAcc;
        
        ballList.get(j).xVel = newXVel;
        ballList.get(j).yVel = newYVel;
        
        ballList.get(j).xPos = newXPos;
        ballList.get(j).yPos = newYPos;
      }  
    }
    tempBallList = realCopyMassBallList(tempBallList, ballList);
  }
}

ArrayList<MassBall> realCopyMassBallList(ArrayList<MassBall> copiedBallList, ArrayList<MassBall> ballList) {
  copiedBallList.clear();
  for (int i = 0; i < ballList.size(); i++) {
    MassBall copiedBall = new MassBall(ballList.get(i).xPos, ballList.get(i).yPos);
    
    copiedBall.pinned = ballList.get(i).pinned;
    
    copiedBall.xForce = ballList.get(i).xForce;
    copiedBall.yForce = ballList.get(i).yForce;
    
    copiedBall.xAcc = ballList.get(i).xAcc;
    copiedBall.yAcc = ballList.get(i).yAcc;
    
    copiedBall.xVel = ballList.get(i).xVel;
    copiedBall.yVel = ballList.get(i).yVel;
    
    copiedBallList.add(copiedBall);
  }
  return copiedBallList;
}

void printMassBall(MassBall ball) {
  println("[Ball Xpos: "+ball.xPos+", Ypos: "+ball.yPos+", Xvel: "+ball.xVel+", Yvel: "+ball.yVel+"]");
}