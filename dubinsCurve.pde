class dubinsCurve {
  PVector pos = new PVector(width/2, height/2);
  PVector goal = new PVector(500, 400);
  final double DELTA = 0.05; 
  float r = 60;
  float startTheta = TWO_PI;
  float goalTheta = TWO_PI;
  int resolution = 100;

  PVector leftStart, rightStart, leftGoal, rightGoal;

  dubinsCurve() {
    leftStart = new PVector(0, 0);
    rightStart = new PVector(0, 0);
    leftGoal = new PVector(0, 0);
    rightGoal = new PVector(0, 0);

    update(pos, goal, startTheta, goalTheta);
  }

  dubinsCurve( PVector _pos, PVector _goal, float _startTheta, float _goalTheta, int _resolution, float _r) {
    leftStart = new PVector(0, 0);
    rightStart = new PVector(0, 0);
    leftGoal = new PVector(0, 0);
    rightGoal = new PVector(0, 0);

    resolution = _resolution;
    r = _r;
    update(_pos, _goal, _startTheta, _goalTheta);
  }

  void update( PVector _pos, PVector _goal, float _startTheta, float _goalTheta) {

    pos = _pos;
    goal = _goal;
    startTheta = _startTheta;
    goalTheta = _goalTheta;

    theta = startTheta;
    theta += PI/2.0;
    if (theta > PI)
      theta -= 2.0*PI;
    rightStart.set(pos.x + r * cos(theta), pos.y+ r * sin(theta));

    theta = startTheta;
    theta -= PI/2.0;
    if (theta < -PI)
      theta += 2.0*PI;
    leftStart.set(pos.x + r * cos(theta), pos.y + r * sin(theta));

    theta = goalTheta;
    theta += PI/2.0;
    if (theta > PI)
      theta -= 2.0*PI;
    rightGoal.set(goal.x + r * cos(theta), goal.y+ r * sin(theta));

    theta = goalTheta;
    theta -= PI/2.0;
    if (theta < -PI)
      theta += 2.0*PI;
    leftGoal.set(goal.x + r * cos(theta), goal.y + r * sin(theta));
  }

  Path bestPath() {

    Path bestCandidate = new Path();
    Path CSCCandidate = CSC();
    Path CCCCandidate = CCC();
    //bestCandidate = RLRCandidate.LENGTH < LRLCandidate.LENGTH ? RLRCandidate : LRLCandidate;

    if (CSCCandidate.LENGTH < CCCCandidate.LENGTH) {
      println("CSC");
      bestCandidate = CSCCandidate;
    } else {
      println("CCC");
      bestCandidate = CCCCandidate;
    }

    return bestCandidate;
  }
  Path CSC() {

    PVector[] LR = findTangents(leftStart, rightGoal, r, r)[0];
    PVector[] LL = findTangents(leftStart, leftGoal, r, r)[1]; 
    PVector[] RR = findTangents(rightStart, rightGoal, r, r)[2];
    PVector[] RL = findTangents(rightStart, leftGoal, r, r)[3];

    Path bestCandidate = new Path();
    Path RSRcandidate = RSR(RR);
    bestCandidate = RSRcandidate;
    Path LSLcandidate = LSL(LL);
    if (LSLcandidate.LENGTH < bestCandidate.LENGTH) bestCandidate =LSLcandidate;
    Path RSLcandidate = RSL(RL);
    if (RSLcandidate.LENGTH < bestCandidate.LENGTH) bestCandidate =RSLcandidate;
    Path LSRcandidate = LSR(LR);
    if (LSRcandidate.LENGTH < bestCandidate.LENGTH) bestCandidate =LSRcandidate;

    return bestCandidate;
  }

  Path chooseCSC(int picker) {

    PVector[] LR = findTangents(leftStart, rightGoal, r, r)[0];
    PVector[] LL = findTangents(leftStart, leftGoal, r, r)[1]; 
    PVector[] RR = findTangents(rightStart, rightGoal, r, r)[2];
    PVector[] RL = findTangents(rightStart, leftGoal, r, r)[3];

    Path bestCandidate = new Path();
    Path RSRcandidate = RSR(RR);
    bestCandidate = RSRcandidate;
    Path LSLcandidate = LSL(LL);
    if (picker == 0) bestCandidate =LSLcandidate;
    Path RSLcandidate = RSL(RL);
    if (picker == 1) bestCandidate =RSLcandidate;
    Path LSRcandidate = LSR(LR);
    if (picker == 2) bestCandidate =LSRcandidate;

    return bestCandidate;
  }
  Path CCC() {

    Path bestCandidate = new Path();
    Path RLRCandidate = RLR();
    Path LRLCandidate = LRL();
    //bestCandidate = RLRCandidate.LENGTH < LRLCandidate.LENGTH ? RLRCandidate : LRLCandidate;

    println(RLRCandidate.LENGTH);
    if (RLRCandidate.LENGTH < LRLCandidate.LENGTH) {
      println("RLR");
      bestCandidate = RLRCandidate;
    } else {
      println("LRL");
      bestCandidate = LRLCandidate;
    }

    return bestCandidate;
  }


  Path LRL() {
    float D = 0.f;
    float angleP3;
    PVector p3 = new PVector(0, 0);
    double L =0;
    Path P = new Path();

    D = sqrt( (( leftGoal.x - leftStart.x) * ( leftGoal.x - leftStart.x)) + 
      (( leftGoal.y - leftStart.y) * ( leftGoal.y - leftStart.y)) 
      );
    if (D < 4.0*r) {
      angleP3 = acos( D / ( 4 * r) );
      angleP3 = atan2(leftGoal.y - leftStart.y, leftGoal.x -leftStart.x) - angleP3;

      p3.x = leftStart.x + (2*r) * cos(angleP3);
      p3.y = leftStart.y + (2*r) * sin(angleP3);

      PVector tangA = new PVector((p3.x + leftStart.x) /2, (p3.y + leftStart.y) /2);
      PVector tangB = new PVector((p3.x + leftGoal.x) /2, (p3.y + leftGoal.y) /2);



      double[] arcA =  arcLength(  leftStart, pos, tangA, false, r);
      double D1 = arcA[0];
      L = D1;

      double[] arcB = arcLength(  p3, tangA, tangB, true, r);
      double D2 = arcB[0];
      L += D2;

      double[] arcC = arcLength(  leftGoal, tangB, goal, false, r);
      double D3 = arcC[0];
      L +=D3;


      //println( "L :" + L);
      //println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
      //println( "resolution :" + resolution);
      //println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
      //println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
      //println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

      double theta = arcA[1];
      double steps = resolution / (L / D1);
      double th = theta /  steps;

      for (int i = 0; i <=  steps; i ++) {
        float angle =startTheta+ (float)th * i  + PI/2;
        float x = leftStart.x + r * cos(angle);
        float y = leftStart.y + r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }


      steps = resolution / (L / D2);
      println("steps :" + steps);

      th = (float)arcB[1] / steps;

      for (int i = 0; i <= steps; i ++) {
        float angle = angleP3 + (float)th * i;
        float x = p3.x - r * cos(angle);
        float y = p3.y - r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }


      steps = resolution / (L / D3);

      th = (float)arcC[1] / steps;

      for (int i = 0; i <= steps; i ++) {
        float angle = goalTheta - (float)arcC[1] + (float)th * i  + PI/2;
        float x = leftGoal.x + r * cos( angle);
        float y = leftGoal.y + r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }
    } else {
      L = Double.MAX_VALUE;
    }
    P.setLength(L);
    return(P);
  }

  Path RLR() {
    float D = 0.f;
    float angleP3;
    PVector p3 = new PVector(0, 0);
    Path P = new Path();
    double L =0;

    D = sqrt( (( rightGoal.x - rightStart.x) * ( rightGoal.x - rightStart.x)) + 
      (( rightGoal.y - rightStart.y) * ( rightGoal.y - rightStart.y)) 
      );
    if (D < 4.0*r) {

      angleP3 = acos( D / ( 4 * r) );
      angleP3 = atan2(rightGoal.y - rightStart.y, rightGoal.x -rightStart.x) + angleP3;

      p3.x = rightStart.x + (2*r) * cos(angleP3);
      p3.y = rightStart.y + (2*r) * sin(angleP3);

      PVector tangA = new PVector((p3.x + rightStart.x) /2, (p3.y + rightStart.y) /2);
      PVector tangB = new PVector((p3.x + rightGoal.x) /2, (p3.y + rightGoal.y) /2);





      double[] arcA =  arcLength(  rightStart, pos, tangA, true, r);
      double D1 = arcA[0];
      L = D1;

      double[] arcB = arcLength(  p3, tangA, tangB, false, r);
      double D2 = arcB[0];
      L += D2;

      double[] arcC = arcLength(  rightGoal, tangB, goal, true, r);
      double D3 = arcC[0];
      L +=D3;


      //println( "L :" + L);
      //println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
      //println( "resolution :" + resolution);
      //println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
      //println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
      //println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

      double theta = arcA[1];
      double steps = resolution / (L / D1);
      double th = theta /  steps;

      for (int i = 0; i <=   steps; i ++) {
        float angle = startTheta+ (float)th * i  + PI/2;
        float x = rightStart.x - r * cos(angle);
        float y = rightStart.y - r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }

      steps = resolution / (L / D2);
      th = (float)arcB[1] / steps;
      //th = ( angleP3 - ( atan2(p3.y - p2.y, p3.x - p2.x) - acos( D / ( 4 * r1) ))) / steps;
      //float midTheta = -atan2(p3.y - tangB.y, p3.x - tangB.x);
      for (int i = 0; i <= steps; i ++) {
        float angle = angleP3 + (float)th * i;
        float x = p3.x - r * cos(angle);
        float y = p3.y - r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }

      steps = resolution / (L / D3);

      th = (float)arcC[1] / steps;
      //th = ( angleP3 - ( atan2(p3.y - p2.y, p3.x - p2.x) - acos( D / ( 4 * r1) ))) / steps;
      //float midTheta = -atan2(p3.y - tangB.y, p3.x - tangB.x);
      for (int i = 0; i <= steps; i ++) {
        float angle =  goalTheta - (float)arcC[1] + (float)th * i  + PI/2;
        float x = rightGoal.x - r * cos(angle);
        float y = rightGoal.y - r * sin(angle);
        PVector newPoint = new PVector(x, y);
        P.addPoint(newPoint, angle);
      }
    } else {
      L = Double.MAX_VALUE;
    }
    P.setLength(L);
    println("L :" + L);
    return(P);
  }

  Path RSR(PVector[] tangents) {
    //   startTheta = map(mouseX, 0, width, 0, TWO_PI);
    //goalTheta =  map(mouseY, 0, height, 0, TWO_PI);
    double timesteps;
    double L;
    Path P = new Path();
    double[] arcA = arcLength(rightStart, pos, tangents[0], true, r);
    double D1 = arcA[0];
    L = D1;

    double D2 = PVector.dist(tangents[0], tangents[1]);
    L += D2;

    double[] arcB =  arcLength(rightGoal, tangents[1], goal, true, r);
    double D3 = arcB[0];
    L +=D3;


    //println( "L :" + L);
    //println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
    //println( "resolution :" + resolution);
    //println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
    //println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
    //println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

    double theta = arcA[1];
    double steps = resolution / (L / D1);
    double th = theta /  steps;

    float initTheta = startTheta;
    initTheta += PI/2.0;
    if (initTheta > PI)
      initTheta -= 2.0*PI;
    for (int i = 0; i <= steps; i++) {
      float angle =  initTheta + ( i * (float)th);
      PVector newPoint = new PVector(rightStart.x - r * cos( angle), 
        rightStart.y - r * sin(angle ));
      P.addPoint( newPoint, angle);
    }
    steps = resolution / (L / D2);

    double incAmt = D2 / steps;
    for (int i = 0; i <= steps; i++) {

      float amt = i * (float)incAmt;
      PVector newPoint = new PVector(map(i, 0, (float)steps, tangents[0].x, tangents[1].x), 
        map(i, 0, (float)steps, tangents[0].y, tangents[1].y));

      P.addPoint( newPoint, initTheta + (float)theta);
    }

    steps = resolution / (L / D3);
    theta = arcB[1];
    th = theta /  steps;
    initTheta =  goalTheta-(float)theta;
    initTheta -= PI/2.0;
    if (initTheta < -PI)
      initTheta += 2.0*PI;

    for (int i = 0; i <= steps; i++) {
    float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(rightGoal.x + r * cos( angle), 
        rightGoal.y + r * sin( angle));//, initTheta + ( i * (float)th) + PI);
      //PVector newPoint = new PVector(rightGoal.x + r * cos( initTheta ), 
      // rightGoal.y + r * sin( initTheta ));
      P.addPoint( newPoint, angle + PI);
    }
    L +=D3;

    P.setLength(L);

    return P;
  }

  Path RSL(PVector[] tangents) {
    //   startTheta = map(mouseX, 0, width, 0, TWO_PI);
    //goalTheta =  map(mouseY, 0, height, 0, TWO_PI);
    double timesteps;
    double L;
    Path P = new Path();
    double[] arcA = arcLength(rightStart, pos, tangents[0], true, r);
    double D1 = arcA[0];
    L = D1;

    double D2 = PVector.dist(tangents[0], tangents[1]);
    L += D2;

    double[] arcB =  arcLength(leftGoal, tangents[1], goal, false, r);
    double D3 = arcB[0];
    L +=D3;


    //println( "L :" + L);
    //println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
    //println( "resolution :" + resolution);
    //println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
    //println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
    //println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

    double theta = arcA[1];
    double steps = resolution / (L / D1);
    double th = theta /  steps;

    float initTheta = startTheta;
    initTheta += PI/2.0;
    if (initTheta > PI)
      initTheta -= 2.0*PI;
    for (int i = 0; i <= steps; i++) {
      float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(rightStart.x - r * cos( angle), 
        rightStart.y - r * sin( initTheta + ( i * (float)th)));
      P.addPoint( newPoint, angle);
    }


    steps = resolution / (L / D2);
    double incAmt = D2 / steps;
    for (int i = 0; i <= steps; i++) {

      float amt = i * (float)incAmt;
      PVector newPoint = new PVector(map(i, 0, (float)steps, tangents[0].x, tangents[1].x), 
        map(i, 0, (float)steps, tangents[0].y, tangents[1].y));

      P.addPoint( newPoint,  initTheta + (float)theta);
    }

    steps = resolution / (L / D3);
    theta = arcB[1];

    th = theta /  steps;
    initTheta =  goalTheta-(float)theta;
    initTheta -= PI/2.0;
    if (initTheta < -PI)
      initTheta += 2.0*PI;

    for (int i = 0; i <= steps; i++) {
  float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(leftGoal.x - r * cos(angle ), 
        leftGoal.y - r * sin( initTheta + ( i * (float)th) ));// initTheta + ( i * (float)th) + PI);
      P.addPoint( newPoint, angle + PI);
    }


    P.setLength(L);

    return P;
  }

  Path LSL(PVector[] tangents) {
    //   startTheta = map(mouseX, 0, width, 0, TWO_PI);
    //goalTheta =  map(mouseY, 0, height, 0, TWO_PI);
    double timesteps;
    double L;
    Path P = new Path();

    double[] arcA = arcLength(leftStart, pos, tangents[0], false, r);
    double D1 = arcA[0];
    L = D1;

    double D2 = PVector.dist(tangents[0], tangents[1]);
    L += D2;

    double[] arcB =  arcLength(leftGoal, tangents[1], goal, false, r);
    double D3 = arcB[0];
    L +=D3;

    //    println( "L :" + L);
    //    println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
    //    println( "resolution :" + resolution);
    //    println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
    //    println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
    //    println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

    double theta = arcA[1];
    double steps = resolution / (L / D1);
    double th = theta /  steps;

    float initTheta = startTheta;
    initTheta += PI/2.0;
    if (initTheta > PI)
      initTheta -= 2.0*PI;
    for (int i = 0; i <=steps; i++) {
      float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(leftStart.x + r * cos( angle), 
        leftStart.y + r * sin( angle ));
      P.addPoint( newPoint, angle);
    }

    steps = resolution / (L / D2);
    double incAmt = D2 / steps;
    for (int i = 0; i <= steps; i++) {

      float amt = i * (float)incAmt;
      PVector newPoint = new PVector(map(i, 0, (float)steps, tangents[0].x, tangents[1].x), 
        map(i, 0, (float)steps, tangents[0].y, tangents[1].y));

      P.addPoint( newPoint, initTheta + (float)theta);
    }

    steps = resolution / (L / D3);

    theta = arcB[1];
    th = theta /  steps;
    initTheta =  goalTheta-(float)theta;
    initTheta -= PI/2.0;
    if (initTheta < -PI)
      initTheta += 2.0*PI;

    for (int i = 0; i <= steps; i++) {
float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(leftGoal.x - r * cos( angle), 
        leftGoal.y - r * sin(angle ));//, initTheta + ( i * (float)th) + PI);
      P.addPoint( newPoint, angle + PI);
    }

    P.setLength(L);

    return P;
  }

  Path LSR(PVector[] tangents) {
    //   startTheta = map(mouseX, 0, width, 0, TWO_PI);
    //goalTheta =  map(mouseY, 0, height, 0, TWO_PI);
    double timesteps;
    double L;
    Path P = new Path();


    double[] arcA = arcLength(leftStart, pos, tangents[0], false, r);
    double D1 = arcA[0];
    L = D1;

    double D2 = PVector.dist(tangents[0], tangents[1]);
    L += D2;

    double[] arcB =  arcLength(rightGoal, tangents[1], goal, true, r);
    double D3 = arcB[0];
    L +=D3;

    //println( "L :" + L);
    //println( "D1 :" + D1 + " -- D2 :" + D2 + " -- D3 :" + D3);
    //println( "resolution :" + resolution);
    //println("L / D1 :" + (L/D1) + " -- resolution / (L / D1) :" + (resolution / (L / D1)));
    //println("L / D2 :" + (L/D2) + " -- resolution / (L / D2) :" + (resolution / (L / D2)));
    //println("L / D3 :" + (L/D3) + " -- resolution / (L / D3) :" + (resolution / (L / D3)));

    double theta = arcA[1];
    double steps = resolution / (L / D1);
    double th = theta /  steps;


    float initTheta = startTheta;
    initTheta += PI/2.0;
    if (initTheta > PI)
      initTheta -= 2.0*PI;
    for (int i = 0; i <= steps; i++) {
      float angle = initTheta + ( i * (float)th);
      PVector newPoint = new PVector(leftStart.x + r * cos( angle), 
        leftStart.y + r * sin( angle ));
      P.addPoint( newPoint,angle);
    }

    steps = resolution / (L / D2);
    double incAmt = D2 / steps;
    for (int i = 0; i <= steps; i++) {

      float amt = i * (float)incAmt;
      PVector newPoint = new PVector(map(i, 0, (float)steps, tangents[0].x, tangents[1].x), 
        map(i, 0, (float)steps, tangents[0].y, tangents[1].y));

      P.addPoint( newPoint, initTheta + (float)theta);
    }

    steps = resolution / (L / D3);

    theta = arcB[1];
    th = theta /  steps;
    initTheta =  goalTheta-(float)theta;
    initTheta -= PI/2.0;
    if (initTheta < -PI)
      initTheta += 2.0*PI;

    for (int i = 0; i <= steps; i++) {
float angle =  initTheta + ( i * (float)th);
      PVector newPoint = new PVector(rightGoal.x + r * cos( angle), 
        rightGoal.y + r * sin(angle));//, initTheta + ( i * (float)th) + PI);
      P.addPoint( newPoint, angle + PI);
    }
    L +=D3;

    P.setLength(L);

    return P;
  }

  void display() {
    stroke(0);
    ellipse(rightStart.x, rightStart.y, r, r);
    //ellipse(leftStart.x, leftStart.y, r, r);
    ellipse(rightGoal.x, rightGoal.y, r, r);
    //ellipse(leftGoal.x, leftGoal.y, r, r);

    stroke(0, 0, 255);
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(startTheta + PI/2);
    line(0, 0, 0, -40);
    popMatrix();

    stroke(0, 0, 255);
    strokeWeight(2);
    pushMatrix();
    translate(goal.x, goal.y);
    rotate(goalTheta + PI/2);
    line(0, 0, 0, -40);
    popMatrix();
  }
}
