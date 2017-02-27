class Dungeon {

  int numFloors, floorSize, numSquares;
  ArrayList<Floor> floors;

  //new dungeon stores floors, squares per floor
  public Dungeon(int f, int squares, boolean delay) {

    numFloors = f;
    numSquares = squares;
    floorSize = (height-100)/numSquares;
    floors = new ArrayList<Floor>();

    for (int i = 0; i < numFloors; i++) {
      if (i>0) {
        floors.add(new Floor(i, numSquares, floors.get(i-1).stairDown, delay, numFloors));
      } else {
        PVector entrance = new PVector();
        entrance.x = (int)random(5,numSquares-5);
        entrance.y = (int)random(5,numSquares-5);
        floors.add(new Floor(i, numSquares, entrance, delay, numFloors));
      }
    }
  }
}