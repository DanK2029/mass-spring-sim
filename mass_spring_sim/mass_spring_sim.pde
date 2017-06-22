ArrayList<MassBall> ballList = new ArrayList<MassBall>();
ArrayList<MassBall> tempBallList = new ArrayList<MassBall>();
ArrayList<Spring> springList = new ArrayList<Spring>();

MassBall mouseBall = new MassBall();

float gravity = -10;
float springDampeningConst = 0.1;
float viscousDampeningConst = 0.3;
float ballRadius = 10;
float tDelta = 0.0025;
float time = 0;
String curIterator = "eulerForward";
float floorFriction = 0.4;

boolean halfStepFirstIter = true;
boolean halfStepFirstIterSpring = true;
int draggedBallIndex = -1;

void setup(){
  size(600, 600);
  frameRate(1000);
  String structureFileName = "line";
  //String structureFileName = "hexegon";
  //String structureFileName = "equilateral_triangle";
  //String structureFileName = "box";
  //String structureFileName = "wheel";
  read_file("structures/" + structureFileName + ".txt");
  tempBallList = realCopyMassBallList(tempBallList, ballList);
}

void draw(){  //START OF DRAW ---------------------------------------------------------
  background(255);
  fill(0);
  text("Gravity: "+str(gravity), 10, 10);
  text("Spring Dampening Constant: "+str(springDampeningConst), 10, 25);
  text("Viscous Dampening Constant: "+str(viscousDampeningConst), 10, 40);
  text(curIterator, 10, 55);
  
  
  if (mousePressed && draggedBallIndex == -1) {
    noStroke();
    ellipse(mouseBall.xPos, height-mouseBall.yPos, 2*ballRadius, 2*ballRadius);
    stroke(ballRadius/3.0);
  }
  
  //calculate and draw springs
  for (int i = 0; i < springList.size(); i++) {
    Spring spring = springList.get(i);
    MassBall lb = spring.leftBall;
    MassBall rb = spring.rightBall;
    //calculate springs
    springForceCalc(spring);
    readjustSpringRestLength(spring);
    spring.age += tDelta;
    //draw springs
    strokeWeight(ballRadius/3.0);
    fill(0,0,0);
    line(lb.xPos, height-lb.yPos, rb.xPos, height-rb.yPos);
  }
  
  //apply forces to balls
  for (int i = 0; i < ballList.size(); i++) {
    MassBall ball = ballList.get(i);
    ball.yForce += gravity;
    ball.xForce -= viscousDampeningConst * ball.xVel;
    ball.yForce -= viscousDampeningConst * ball.yVel;
    
  }
  
  //calculate ball physics
  if (curIterator == "halfStep") {
    halfStep(4, tDelta);
  } else if (curIterator == "eulerForward") {
    eulerForward(4, tDelta);
  }
  
  for (int i = 0; i < ballList.size(); i++) {
    MassBall ball = ballList.get(i);
    float xBall = ball.xPos;
    float yBall = ball.yPos;
    fill(ball.ballColor);
    noStroke();
    ellipse(xBall, height-yBall, 2*ballRadius, 2*ballRadius);
    stroke(ballRadius/3.0);
  }
  
  //reset forces
  for (int i = 0; i < ballList.size(); i++) {
    ballList.get(i).xForce = 0.0;
    ballList.get(i).yForce = 0.0;
  } 
  time += tDelta;
}
//END OF DRAW----------------------------------------------------------------------------



//SPRING FORCE CLACULATIONS START--------------------------------------------------------
void readjustSpringRestLength(Spring spring){
  float frequency = 5;
  float phase = spring.phase;
  float magnitude = spring.magnitude;
  spring.restLength = spring.originalRestLength + magnitude*sin(time*frequency + phase);
}

void springForceCalc(Spring spring) {
  float Ks = spring.springConst;
  float Kd = springDampeningConst;
  float r = spring.restLength;
  MassBall rightBall = spring.rightBall;
  MassBall leftBall = spring.leftBall;
  float springLength = sqrt(sq(rightBall.xPos - leftBall.xPos) + sq(rightBall.yPos - leftBall.yPos));
  
  float ballXPosDif = (leftBall.xPos - rightBall.xPos);
  float ballYPosDif = (leftBall.yPos - rightBall.yPos);
  
  float ballXVelDif = (leftBall.xVel - rightBall.xVel);
  float ballYVelDif = (leftBall.yVel - rightBall.yVel);
  
  float ballPosDotVel = (ballXPosDif * ballXVelDif) + (ballYPosDif * ballYVelDif); 
  
  float fx = -((Ks * (r - springLength)) + (Kd * (ballPosDotVel)/springLength)) * (ballXPosDif/springLength);
  float fy = -((Ks * (r - springLength)) + (Kd * (ballPosDotVel)/springLength)) * (ballYPosDif/springLength);

  rightBall.xForce += fx;
  rightBall.yForce += fy;
  
  leftBall.xForce -= fx;
  leftBall.yForce -= fy;
  
}
//SPRING FORCE CALCULATION END-----------------------------------------------------------


//BOUNDARY AND FRICTION FORCE START------------------------------------------------------
void applyFrictionAndBounceForce(MassBall ball) {
  if (ball.yPos-ballRadius <= 0.0) {
    if (ball.yVel <= 0.0) {
      ball.yVel = -0.7 * ball.yVel;
      if (ball.xVel < 0.0) {
        float fricForce = (floorFriction + ball.friction) * abs(gravity);
        if (abs(fricForce) > abs(ball.xForce)) {
          fricForce = -ball.xForce;
        }
        ball.xForce += fricForce;
      } 
      if (ball.xVel > 0.0) {
        float fricForce = (floorFriction + ball.friction) * abs(gravity);
        if (abs(fricForce) > abs(ball.xForce)) {
          fricForce = -ball.xForce;
        }
        ball.xForce += fricForce;
      }
    }
  }
  
  if (ball.xPos+ballRadius >= width) {
    if (ball.xVel >= 0.0) {
      ball.xVel = -0.7 * ball.xVel;
    }
  }
  
  if (ball.xPos-ballRadius <= 0.0) {
    if (ball.xVel <= 0.0) {
      ball.xVel = -0.7 * ball.xVel;
    }
  }
}


void boundCheck(MassBall ball) {
  
  if (ball.yPos-ballRadius <= 0.0) {
    ball.yPos = ballRadius;
  }
  
  if (ball.xPos+ballRadius > width) {
    ball.xPos = width - ballRadius;
  }
  
  if (ball.xPos-ballRadius < 0.0) {
    ball.xPos = ballRadius;
  }
}
//BOUNDARY AND FRICTION FORCE END-------------------------------------------------------