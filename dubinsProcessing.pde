
PVector agentPos = new PVector(350, 350);
PVector prevAgentPos = new PVector(100, 200);
PVector agentPos2 = new PVector(500, 150);
PVector prevAgentPos2 = new PVector(400, 370);

float r = 40;
float startTheta = TWO_PI;
float goalTheta = TWO_PI * 0.5;
float startTheta2 = TWO_PI;
float goalTheta2 = TWO_PI * 0.2;
float theta;

dubinsCurve dub, dub2;
Path p, p2;
Boolean start = true;
float t = 0;
void setup() {
  size(700, 700);
  pixelDensity(2);
  strokeWeight(4);
  ellipseMode(RADIUS);
  rectMode(CENTER);
  noFill();

  dub = new dubinsCurve(agentPos, prevAgentPos, startTheta, goalTheta, 50, 70);
  p = new Path();
  p = dub.bestPath();
  dub2 = new dubinsCurve(agentPos2, prevAgentPos2, startTheta2, goalTheta2, 50, 70);
  p2 = new Path();
  p2 = dub2.bestPath();
  background(0);
  //rect(0,0,width,height);
}

void draw() {

  fill(0, 10);
  stroke(0);
  rect(width/2, height/2, width, height);


  p.display();
  p2.display();

  //pushMatrix()
  stroke(255);


  float pct =t;//map(mouseX+1, 0, width, 0, 1);
  pushMatrix();

  if (p.positionAtPoint(pct) ==   p.positionAtPoint(1)) generate();
  translate(p.positionAtPoint(pct).x, p.positionAtPoint(pct).y);
  rotate(p.angleAtPoint(pct));
  //rect(0, 0, 20, 20);
  triangle(0, -20, - 5, 5, 5, 5);

  popMatrix();
  pushMatrix();

  translate(p2.positionAtPoint(pct).x, p2.positionAtPoint(pct).y);
  rotate(p2.angleAtPoint(pct));
  //rect(0, 0, 20, 20);
  triangle(0, -20, - 5, 5, 5, 5);

  popMatrix();
 
  t+=0.05; 


  //noLoop
}


void generate() {
  agentPos.x = prevAgentPos.x;
  agentPos.y = prevAgentPos.y;
  prevAgentPos.x =mouseX;//random(width);
  prevAgentPos.y =mouseY;// random(height);
  t = 0;
  startTheta = goalTheta;//TWO_PI;
  goalTheta = random(TWO_PI);
  dub.update(agentPos, prevAgentPos, startTheta, goalTheta);
  p = dub.bestPath();

  agentPos2.x = prevAgentPos2.x;
  agentPos2.y = prevAgentPos2.y;
  prevAgentPos2.x =mouseX;//random(width);
  prevAgentPos2.y =mouseY;// random(height);
  t = 0;
  startTheta2 = goalTheta2;//TWO_PI;
  goalTheta2= random(TWO_PI);
  dub2.update(agentPos2, prevAgentPos2, startTheta2, goalTheta2);
  p2 = dub2.bestPath();
  //stroke(255, 0, 0);
}

void keyPressed() {
  //generate();
}
