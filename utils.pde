PVector[][] findTangents(PVector P1, PVector P2, float R1, float R2) {

  float C;
  float D = P1.dist(P2);
  float R3; 
  PVector N = new PVector(0, 0);
  //PVector[] result = new PVector[2];

  PVector[][] result = new PVector[4][2];
  PVector V1 = PVector.sub(P2, P1);

  R3 = R1 + R2;

  C = (R3 / D);

  PVector vNorm =new PVector (V1.x, V1.y);
  vNorm.normalize();
  N.set(  (vNorm.x * C - vNorm.y * sqrt( 1 - (C * C) ) ), 
    ( vNorm.x * sqrt( 1 - (C * C)) + vNorm.y * C)
    );

  PVector V2;  
  V2 = PVector.sub(V1, PVector.mult(N, R3));

  result[0][0] = new PVector(P1.x + (N.x * R1), 
    P1.y + (N.y * R1)
    );
  result[0][1] = new PVector(P1.x + (N.x * R1) + V2.x, 
    P1.y+ (N.y *R1)  + V2.y);

  C *= -1;

  N.set(  (vNorm.x * C - vNorm.y * sqrt( 1 - (C * C) ) ), 
    ( vNorm.x * sqrt( 1 - (C * C)) + vNorm.y * C)
    );
  V2 = PVector.add(V1, PVector.mult(N, R3));
  result[3][0] = new PVector(P1.x - (N.x * R1), 
    P1.y - (N.y * R1)
    );
  result[3][1] = new PVector( P1.x - (N.x * R1) + V2.x, 
    P1.y- (N.y * R1) + V2.y);

  R3 = R1 - R2;
  C = (R3 / D);

  N.set(  (vNorm.x * C - vNorm.y * sqrt( 1 - (C * C) ) ), 
    ( vNorm.x * sqrt( 1 - (C * C)) + vNorm.y * C)
    );
  V2 = PVector.sub(V1, PVector.mult(N, R3));
  result[1][0] = new PVector(P1.x + (N.x * R1), 
    P1.y + (N.y * R1)
    );
  result[1][1] = new PVector(P1.x + (N.x * R1) + V2.x, 
    P1.y+ (N.y *R1)  + V2.y);


  result[2][0] = new PVector(P1.x - (N.x * R1), 
    P1.y - (N.y * R1)
    );
  result[2][1] = new PVector( P1.x - (N.x * R1) + V2.x, 
    P1.y- (N.y * R1) + V2.y);

  return result;
}


double[] arcLength(PVector p1_, PVector p2_, PVector p3_, Boolean left, float r) {

  PVector V1 = PVector.sub(p2_, p1_);
  PVector V2 = PVector.sub(p3_, p1_);
double [] result = new double [2]; 
  float theta = atan2(V2.y, V2.x) - atan2(V1.y, V1.x);

  if ( theta < 0 && left)
    theta+= TWO_PI;
  else if ( theta >0 && !left)
    theta-=TWO_PI;
result[0] = abs(theta * r);
result[1] = theta;
  return result;
}
