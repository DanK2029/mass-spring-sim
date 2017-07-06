void eulerForward(int n, float tDelta, ArrayList<Creature> creatureList) {
  
  for (int c = 0; c < creatureList.size(); c++) {
    
    for (int i = 0; i < n; i++) {
      
      creatureList.get(c).tempBallList = realCopyMassBallList(creatureList.get(c).ballList);    
      
      for (int j = 0; j < creatureList.get(c).tempBallList.size(); j++) {
        //println(iterStep);
        //iterStep++;
        MassBall tempBall = creatureList.get(c).tempBallList.get(j);
        
        applyFrictionAndBounceForce(tempBall);
        
        float newXAcc = tempBall.xForce;
        float newYAcc = tempBall.yForce;
        
        float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
        float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
        
        float newXPos = tempBall.xPos + (tDelta * tempBall.xVel);
        float newYPos = tempBall.yPos + (tDelta * tempBall.yVel);
        
        
        
        creatureList.get(c).ballList.get(j).xAcc = newXAcc;
        creatureList.get(c).ballList.get(j).yAcc = newYAcc;
        
        creatureList.get(c).ballList.get(j).xVel = newXVel;
        creatureList.get(c).ballList.get(j).yVel = newYVel;
        
        creatureList.get(c).ballList.get(j).xPos = newXPos;
        creatureList.get(c).ballList.get(j).yPos = newYPos;
        
        boundCheck(creatureList.get(c).ballList.get(j));
      }
    }
  }
}

void halfStep(int n, float tDelta, ArrayList<Creature> creatureList) {
  for (int c = 0; c < creatureList.size(); c++) {
    for (int i = 0; i < n; i++) {
      creatureList.get(c).tempBallList = realCopyMassBallList(creatureList.get(c).ballList);
      for (int j = 0; j < creatureList.get(c).tempBallList.size(); j++) {
        
        if (draggedBallIndex != j) {
          MassBall tempBall = creatureList.get(c).tempBallList.get(j);
          applyFrictionAndBounceForce(tempBall);
        
          float newXAcc = tempBall.xForce;
          float newYAcc = tempBall.yForce;
          
          float newXVel = tempBall.xVel + (tDelta * tempBall.xAcc);
          float newYVel = tempBall.yVel + (tDelta * tempBall.yAcc);
          
          float newXPos = tempBall.xPos + (tDelta*(tempBall.xVel + newXVel)/2.0);
          float newYPos = tempBall.yPos + (tDelta*(tempBall.yVel + newYVel)/2.0);
          
          creatureList.get(c).ballList.get(j).xAcc = newXAcc;
          creatureList.get(c).ballList.get(j).yAcc = newYAcc;
          
          creatureList.get(c).ballList.get(j).xVel = newXVel;
          creatureList.get(c).ballList.get(j).yVel = newYVel;
          
          creatureList.get(c).ballList.get(j).xPos = newXPos;
          creatureList.get(c).ballList.get(j).yPos = newYPos;
          boundCheck(creatureList.get(c).ballList.get(j));
        }
      }  
    }
  }
}

ArrayList<MassBall> realCopyMassBallList(ArrayList<MassBall> ballList) {
  ArrayList<MassBall> copiedBallList = new ArrayList<MassBall>();
  for (int i = 0; i < ballList.size(); i++) {
    MassBall copiedBall = ballList.get(i).copyMassBall();
    copiedBallList.add(copiedBall);
  }
  return copiedBallList;
}