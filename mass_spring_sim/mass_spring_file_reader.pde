import java.nio.file.Path;
import java.nio.file.Paths;
BufferedReader reader; 
String line;
Creature currentCreature;

void readCreatureFile(String fileName) {  
  try {
    reader = createReader(fileName);
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }

  while (line != null) {
    String[] words = line.split(" ");
    if (words[0].equals("creature")) {
      currentCreature = new Creature();
    } else if (words[0].equals("createCreature")) {
      creatureList.add(currentCreature);
      currentCreature = null;
    } else if (words[0].equals("massBall")) {
      float xPosition = float(words[1]);
      float yPosition = float(words[2]);
      float friction = float(words[3]);
      MassBall ball = new MassBall(xPosition, yPosition, friction);
      currentCreature.ballList.add(ball);
    } else if (words[0].equals("spring")) {
      float k = float(words[1]);
      float r = float(words[2]);
      float phase = float(words[3]);
      float magnitude = float(words[4]);
      int leftBallIndex = int(words[5]);
      int rightBallIndex = int(words[6]);  
      Spring spring = new Spring(k, r, phase, magnitude, leftBallIndex, rightBallIndex);
      currentCreature.springList.add(spring);
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
    } else if (words[0].equals("fitness")) {
      currentCreature.fitness = float(words[1]);
    }
    
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }    
  }
}

void writeCreatureFile(Creature c, String fileName) {
  
  //String structureFilePath =  "~/structures/";
  
  try{
    Path currentRelativePath = Paths.get("");
    String pathString = currentRelativePath.toAbsolutePath().toString();
    File fileWrite = new File(pathString + "\\..\\projects\\mass_spring_sim\\mass_spring_sim\\structures\\" + fileName + ".txt");
    //File fileWrite = new File("C:\\Users\\Daniel Kane\\Documents\\Processing\\Projects\\mass_spring_sim\\mass_spring_sim\\structures\\" + fileName + ".txt");
    PrintWriter writer = new PrintWriter(fileWrite);
    writer.println("creature");
    
    writer.println("gravity " + gravity);
    writer.println("springDampeningConst " + springDampeningConst);
    writer.println("viscousDampeningConst " + viscousDampeningConst);
    writer.println("floorFriction " + floorFriction);
    writer.println("ballRadius " + ballRadius);
    writer.println("fitness " + c.fitness);
    
    for (int i = 0; i < c.ballList.size(); i++) {
      MassBall mb = c.ballList.get(i);
      writer.println("massBall " + mb.xPos + " " + mb.yPos + " " + mb.friction);
    }
    
    for (int i = 0; i < c.springList.size(); i++) {
      Spring sp = c.springList.get(i);
      writer.println("spring " + sp.springConst + " " + sp.originalRestLength + " " + sp.phase + " " + sp.magnitude + " " + sp.rightBallIndex + " " + sp.leftBallIndex);
    }
    
    writer.println("createCreature");
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}