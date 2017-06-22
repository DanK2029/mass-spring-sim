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
}

class Spring {
  float restLength;
  float springConst;
  
  float phase;
  float magnitude;
  
  float xPos;
  float yPos;
  
  MassBall rightBall;
  MassBall leftBall;
  
  float age = 0.0;
  float originalRestLength;
  
  Spring (float k, float r, float p, float mag, MassBall rb, MassBall lb) {
    springConst = k;
    rightBall = rb;
    leftBall = lb;
    restLength = r;    
    originalRestLength = r;
    phase = p;
    magnitude = mag;
  }
}