class Dungeon {

  int numFloors, floorSize, numSquares;
  ArrayList<Floor> floors;

  public Dungeon(int f, int squares) {

    numFloors = f;
    numSquares = squares;
    floorSize = (height-100)/numSquares;
    floors = new ArrayList<Floor>();

    for (int i = 0; i < numFloors; i++) {
      if (i>0) {
        floors.add(new Floor(i, numSquares, floors.get(i-1).stairDown));
      } else {
        floors.add(new Floor(i, numSquares, new PVector(10, 10)));
      }
    }
  }
}