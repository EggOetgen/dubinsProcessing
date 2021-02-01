class Path {
  ArrayList<PVector> points;
  FloatList angles;

  double LENGTH;

  Path() {
    points = new ArrayList<PVector>();
    angles = new FloatList();
  }

  void addPoint( PVector _point, float theta ) {
    points.add(_point);
    angles.append(theta);
    //println(_point);
  }
  void clearPath() {
    if (points.size() > 0) {
      points.clear();
      angles.clear();
    }
  }

  PVector positionAtPoint(float pct) {
    //float position = pct % 1.0;
    //position = points.size() * position;
    //int positionInt = floor(position);
int position = floor(map( pct, 0, 1, 0, points.size()-1));
position = position%points.size();
    return  points.get(position);
  }

  float angleAtPoint(float pct) {
    //float position = pct % 1.1;
    
    //position = points.size() * position;
    //int positionInt = floor(position);

    int position = floor(map( pct, 0, 1, 0, points.size()-1));
    position = position%points.size();
    return  angles.get(position);
  }


  void setLength( double _length) {
    LENGTH = _length;
  }

  void display() {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(1);
    beginShape();
    for (int i = 0; i < points.size(); i ++) {
      vertex(points.get(i).x, points.get(i).y);
      noFill();
      //ellipse(points.get(i).x, points.get(i).y, 5, 5);
    }
    endShape();
  }
}
