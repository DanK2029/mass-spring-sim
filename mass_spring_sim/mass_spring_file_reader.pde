BufferedReader reader; 
String line;

void read_file(String fileName) {  
  try {
    reader = createReader(fileName);
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  
  while (line != null) {
    String[] words = line.split(" ");
    if (words[0].equals("massBall")) {
      float xPosition = float(words[1]);
      float yPosition = float(words[2]);
      float friction = float(words[3]);
      MassBall ball = new MassBall(xPosition, yPosition, friction);
      ballList.add(ball);
    } else if (words[0].equals("spring")) {
      float k = float(words[1]);
      float r = float(words[2]);
      float phase = float(words[3]);
      float magnitude = float(words[4]);
      MassBall ball1 = ballList.get(int(words[5]));
      MassBall ball2 = ballList.get(int(words[6]));
      Spring spring = new Spring(k, r, phase, magnitude, ball1, ball2);
      springList.add(spring);
    } else if (words[0].equals("gravity")) {
      gravity = float(words[1]);
    } else if (words[0].equals("springDampeningConst")) {
      springDampeningConst = float(words[1]);
    } else if (words[0].equals("viscousDampeningConst")) {
      viscousDampeningConst = float(words[1]);
    } else if (words[0].equals("ballRadius")) {
      ballRadius = float(words[1]);
    } else if (words[0].equals("tDelta")) {
      tDelta = float(words[1]);
    } else if (words[0].equals("floorFriction")) {
      floorFriction = float(words[1]);
    }
    
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }    
  }
}