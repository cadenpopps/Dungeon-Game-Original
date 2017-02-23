
class Floor {

  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;
  ArrayList<Room> rooms;
  final int roomTries = 40, maxRoomSize=10;

  public Floor(int loc, int numSq, PVector stair) {

    //new floor stores floor #, width/height of board, location of the up stair, and an collection of rooms
    floorNum = loc;
    numSquares = numSq;
    stairUp = stair.copy();
    rooms = new ArrayList<Room>();

    //generate board, only up stair and downstair rooms
    genBoard();
    //generate rest of dungeon, all rooms and passages
    genDungeon();
    //makes sure stair locations aren't overwritten
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;
  }

  public void genBoard() {

    //initializes a new board
    squares = new Square[numSquares][numSquares];

    //initializes every square to a wall with a difficulty
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        //needs difficulty (last param)
        squares[i][j] = new Square(i, j, 0, -1);
      }
    }

    //create down stair
    stairDown = new PVector((int)random(2, numSquares-2), (int)random(2, numSquares-2));

    //check if up and down stair too close
    while (abs(stairDown.x-stairUp.x) < 10 && abs(stairDown.y-stairUp.y) < 10) {
      stairDown.x = (int)random(2, numSquares-2);
      stairDown.y = (int)random(2, numSquares-2);
    }

    //add 3x3 rooms around stairs
    rooms.add(new Room((int)stairUp.x-1, (int)stairUp.y-1, (int)stairUp.x+2, (int)stairUp.y+2, floorNum));
    rooms.add(new Room((int)stairDown.x-1, (int)stairDown.y-1, (int)stairDown.x+2, (int)stairDown.y+2, floorNum));
  }

  public void genDungeon() {

    //generate the rooms of dungeon, no overlap
    genRooms();
    //fill in rest of spaces with maze
    genMaze();
    //make maze sparse

    //connect regions

    //populate?
  }

  public void genRooms() {

    for (int i = 0; i < roomTries; i++) {
      int rx1 = (int)random(3, numSquares - maxRoomSize); 
      int ry1 = (int)random(3, numSquares - maxRoomSize);

      if (rx1%2==0) {
        rx1++;
      }
      if (ry1%2==0) {
        ry1++;
      }

      int rx2 = (int)random(rx1+2, rx1+maxRoomSize); 
      int ry2 = (int)random(ry1+2, ry1+maxRoomSize);

      if (rx2%2==1) {
        rx2++;
      }
      if (ry2%2==1) {
        ry2++;
      }

      Room newRoom = new Room(rx1, ry1, rx2, ry2, floorNum);
 
      boolean overlaps = false;

      for (Room r : rooms) {
        if (r.overlaps(newRoom)) {
          overlaps = true;
          break;
        }
      }

      if (!overlaps) {
        rooms.add(newRoom);
      }
    }
    for (Room r : rooms) {
      r.makeRoom(squares);
    }
  }
  
  public void genMaze(){
    //generate maze :)
  }
}