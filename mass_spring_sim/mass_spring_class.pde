class Creature {
  ArrayList<MassBall> ballList;
  ArrayList<MassBall> tempBallList = new ArrayList<MassBall>();
  
  ArrayList<Spring> springList;
  
  float fitness = 0.0;
  int id = creatureCount;
  
  Creature() {
    creatureCount++;
    this.ballList = new ArrayList<MassBall>();
    this.tempBallList = new ArrayList<MassBall>();
    this.springList = new ArrayList<Spring>();
  }
  
  Creature(ArrayList<MassBall> ballList, ArrayList<Spring> springList) {
    creatureCount++;
    this.id = creatureCount;
    this.ballList = ballList;
    for (int i = 0; i < ballList.size(); i++) {
      MassBall copiedBall = ballList.get(i).copyMassBall();
      if (tempBallList == null) {
        println("tempBallList is null");
      }
      this.tempBallList.add(copiedBall);
    }
    
    this.springList = springList;
  }
  
  Creature copyCreature() {
    ArrayList<MassBall> copiedBallList = new ArrayList<MassBall>();
    ArrayList<MassBall> copiedTempBallList = new ArrayList<MassBall>();
    ArrayList<Spring> copiedSpringList = new ArrayList<Spring>();
    
    for (int i = 0; i < this.ballList.size(); i++) {
      copiedBallList.add(this.ballList.get(i).copyMassBall());
    }
    for (int i = 0; i < this.tempBallList.size(); i++) {
      copiedTempBallList.add(this.tempBallList.get(i).copyMassBall());
    }
    for (int i = 0; i < this.springList.size(); i++) {
      copiedSpringList.add(this.springList.get(i).copySpring());
    }
    Creature copiedCreature = new Creature(copiedBallList, copiedSpringList);
    return copiedCreature;
  }
  
  void mutate() {
    // changes magnitude and phase
    for (int i = 0; i < springList.size(); i++) {
      float parameterDecider = random(0,23);
      if (parameterDecider < 11) {
        float dPhase = random(-0.1, 0.1);
        springList.get(i).phase += dPhase;
      } else {
        float dMagnitude = random(-5, 5);
        springList.get(i).magnitude += dMagnitude;
        if (springList.get(i).magnitude > 35.0) {
          springList.get(i).magnitude = 35.0;
        }
        /*if (springList.get(i).magnitude < 0.0) {
          springList.get(i).magnitude = 0.0;
        }*/
      }
    } 
  }
  
  void printCreaturePhases() {
    println();
    for (int i = 0; i < this.springList.size(); i++) {
      print(springList.get(i).phase+" ");
    }
  }
  
  void printCreatureMagnitudes() {
    println();
    for (int i = 0; i < this.springList.size(); i++) {
      print(springList.get(i).magnitude+" ");
    }
  }
  
  float evaluateCreature() {
    float score = 0.0;
    for (int i = 0; i < this.ballList.size(); i++) {
      score += this.ballList.get(i).xPos;
    }
    return (float) (score/this.ballList.size());
  }
  
  void translateCreature(float dX, float dY) {
    for (int i = 0; i < this.ballList.size(); i++) {
      this.ballList.get(i).xPos += dX;
      this.ballList.get(i).yPos += dY;
    }
  }
  
  public int compareTo(Creature c) {
    return (int) (fitness - c.fitness);
  }
  
}



class MassBall {
  
  float xForce, yForce;
  
  float xPos, yPos;
  float xVel, yVel;
  float xAcc, yAcc;
  
  boolean dragged = false;
  boolean pinned = false;
  
  float friction;
  
  color ballColor = color(0,0,0);
  
  MassBall () {
  }
  
  MassBall (float x, float y, float f) {    
    xPos = x;
    yPos = y;
    friction = f;
  }
  
  MassBall copyMassBall() {
    MassBall copiedMassBall = new MassBall(xPos, yPos, friction);
    copiedMassBall.xForce = this.xForce;
    copiedMassBall.yForce = this.yForce;
    
    copiedMassBall.xAcc = this.xAcc;
    copiedMassBall.yAcc = this.yAcc;
    
    copiedMassBall.xVel = this.xVel;
    copiedMassBall.yVel = this.yVel;
    
    return copiedMassBall;
  }
  
}

class Spring {
  float restLength;
  float springConst;
  
  float phase;
  float magnitude;
  
  float xPos;
  float yPos;
  
  int rightBallIndex;
  int leftBallIndex;
  
  float age = 0.0;
  float originalRestLength;
  
  Spring (float k, float r, float p, float mag, int lbIndex, int rbIndex) {
    springConst = k;
    rightBallIndex = rbIndex;
    leftBallIndex = lbIndex;
    restLength = r;    
    originalRestLength = r;
    phase = p;
    magnitude = mag;
  }
  
  Spring copySpring() {
    Spring copiedSpring = new Spring(springConst, restLength, phase, magnitude, rightBallIndex, leftBallIndex);
    return copiedSpring;
  }
}