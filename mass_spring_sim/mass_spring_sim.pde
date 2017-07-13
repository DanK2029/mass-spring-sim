ArrayList<Creature> creatureList = new ArrayList<Creature>();

float gravity = -300;
float springDampeningConst = -0.3;
float viscousDampeningConst = 1;
float ballRadius = 10;
float tDelta = 0.0025;
float time = 0;
String curIterator = "eulerForward";
float floorFriction = 0.4;
int creatureCount = 0;

boolean halfStepFirstIter = true;
boolean halfStepFirstIterSpring = true;
int draggedBallIndex = -1;

boolean singleStep = false;

int iterStep = 0;

void setup(){
  size(600, 600);
  frameRate(1000);
  background(255);
  //String structureFileName = "line";
  //String structureFileName = "hexegon";
  //String structureFileName = "equilateral_triangle";
  //String structureFileName = "box";
  //String structureFileName = "wheel";
  //read_file("structures/" + structureFileName + ".txt");
  
  ArrayList<MassBall> cBallList = new ArrayList<MassBall>();
  MassBall ball1 = new MassBall(100, 20, 3);
  MassBall ball2 = new MassBall(200, 20, 3);
  MassBall ball3 = new MassBall(150, 106.6, 3);
  MassBall ball4 = new MassBall(125, 45, 30);
  cBallList.add(ball1);
  cBallList.add(ball2);
  cBallList.add(ball3);
  cBallList.add(ball4);
  
  ArrayList<Spring> cSpringList = new ArrayList<Spring>();
  Spring spring1 = new Spring(31, 100, 0, 0, 0, 1);
  Spring spring2 = new Spring(31, 100, 0, 0, 1, 2);
  Spring spring3 = new Spring(31, 100, 0, 0, 2, 0);
  Spring spring4 = new Spring(31, 80, 0, 20, 3, 2);
  Spring spring5 = new Spring(31, 80, 0, 20, 3, 1);
  cSpringList.add(spring1);
  cSpringList.add(spring2);
  cSpringList.add(spring3);
  cSpringList.add(spring4);
  cSpringList.add(spring5);
  
  Creature baseCreature = new Creature(cBallList, cSpringList);
  
  Creature finishedCreature = geneticAlgorithm(10, baseCreature);
  println("done with genetic algorithm");
  creatureList.add(finishedCreature);
  finishedCreature.printCreatureMagnitudes();
  creatureList.add(baseCreature);
  
}

void draw() {
  if (singleStep) {
    simStep(creatureList);
  }
  drawCreatures();
}

void drawCreature(Creature c) {
  // draw creature's springs
  for (int j = 0; j < c.springList.size(); j++) {
    Spring spring = c.springList.get(j);
    MassBall lb = c.ballList.get(spring.leftBallIndex);
    MassBall rb = c.ballList.get(spring.rightBallIndex);
    strokeWeight(ballRadius/3.0);
    fill(0,0,0);
    line(lb.xPos, height-lb.yPos, rb.xPos, height-rb.yPos);
  }
  // draw creature's balls
  for (int j = 0; j < c.ballList.size(); j++) {
      MassBall ball = c.ballList.get(j);
      float xBall = ball.xPos;
      float yBall = ball.yPos;
      fill(ball.ballColor);
      noStroke();
      ellipse(xBall, height-yBall, 2*ballRadius, 2*ballRadius);
      stroke(ballRadius/3.0);      
    }
}

void drawCreatures() {
  //draw creatures
  for (int i = 0; i < creatureList.size(); i++) {
    drawCreature(creatureList.get(i));
  }

}

void simStep(ArrayList<Creature> creatureList) {
  //println("sim step"+iterStep);
  //iterStep++;
  background(255);
  fill(0);
  text("Gravity: "+str(gravity), 10, 10);
  text("Spring Dampening Constant: "+str(springDampeningConst), 10, 25);
  text("Viscous Dampening Constant: "+str(viscousDampeningConst), 10, 40);
  text(curIterator, 10, 55);
  
  
  //calculate springs
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).springList.size(); j++) {
      Spring spring = creatureList.get(i).springList.get(j);
      springForceCalc(creatureList.get(i), j);
      readjustSpringRestLength(creatureList.get(i), j);
      spring.age += tDelta;      
    }
  }
  
  //apply forces to balls
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).ballList.size(); j++) {
      MassBall ball = creatureList.get(i).ballList.get(j);
      ball.yForce += gravity;
      ball.xForce -= viscousDampeningConst * ball.xVel;
      ball.yForce -= viscousDampeningConst * ball.yVel;
    }
  }
  
  //calculate ball physics
  if (curIterator == "halfStep") {
    halfStep(1, tDelta, creatureList);
  } else if (curIterator == "eulerForward") {
    eulerForward(1, tDelta, creatureList);
  }
  
  //reset forces
  for (int i = 0; i < creatureList.size(); i++) {
    for (int j = 0; j < creatureList.get(i).ballList.size(); j++) {
      creatureList.get(i).ballList.get(j).xForce = 0.0;
      creatureList.get(i).ballList.get(j).yForce = 0.0;
    }
  }
  time += tDelta;
}

void readjustSpringRestLength(Creature creature, int springIndex){
  float frequency = 5;
  float phase = creature.springList.get(springIndex).phase;
  float magnitude = creature.springList.get(springIndex).magnitude;
  
  creature.springList.get(springIndex).restLength = creature.springList.get(springIndex).originalRestLength + magnitude*sin(time*frequency + phase*(2*PI));
}

void springForceCalc(Creature creature, int springIndex) {
  float Ks = creature.springList.get(springIndex).springConst;
  float Kd = springDampeningConst;
  float r = creature.springList.get(springIndex).restLength;
  
  MassBall rightBall = creature.ballList.get(creature.springList.get(springIndex).rightBallIndex);
  MassBall leftBall = creature.ballList.get(creature.springList.get(springIndex).leftBallIndex);
  
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

void applyFrictionAndBounceForce(MassBall ball) {
  if (ball.yPos-ballRadius <= 0.0) {
    if (ball.yVel <= 0.0) {
      ball.yVel = -0.7 * ball.yVel;
    }
  }
  
  if (ball.yPos < ballRadius+0.5) {
    if (ball.xVel < 0.0) {
      float fricForce = -(floorFriction + ball.friction) * ball.xVel;
      
      ball.xForce += fricForce;
    } else {
      float fricForce = -(floorFriction + ball.friction) * ball.xVel;
      
      ball.xForce += fricForce;
    }
  }
  
  /*if (ball.xPos+ballRadius >= width) {
    if (ball.xVel >= 0.0) {
      ball.xVel = -0.7 * ball.xVel;
    }
  }*/
  
  
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
  
  /*if (ball.xPos+ballRadius > width) {
    ball.xPos = width - ballRadius;
  }*/
  
  if (ball.xPos-ballRadius < 0.0) {
    ball.xPos = ballRadius;
  }
}