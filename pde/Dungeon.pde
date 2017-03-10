class Dungeon {

  int numFloors, numSquares;
  ArrayList<Floor> floors;

  //new dungeon stores floors, squares per floor
  public Dungeon(int _numFloors, int _numSquares) {

    //number of floors
    numFloors = _numFloors;
    //number of squares (width and height)
    numSquares = _numSquares;
    //
    //floorSize = (height-100)/numSquares;
    floors = new ArrayList<Floor>();

    for (int i = 0; i < numFloors; i++) {
      if (i>0) {
        floors.add(new Floor(i, numSquares, numFloors, floors.get(i-1).stairDown));
      } else {
        PVector entrance = new PVector();
        entrance.x = (int)random(5,numSquares-5);
        entrance.y = (int)random(5,numSquares-5);
        floors.add(new Floor(i, numSquares, numFloors, entrance));
      }
    }
  }
}