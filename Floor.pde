
class Floor {


  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;
  ArrayList<Room> rooms;
  final int roomTries = 10, avgRoomSize=5;

  public Floor(int loc, int numSq, PVector stair) {

    //new floor stores floor number and has an Array of squares  
    floorNum = loc;
    numSquares = numSq;
    stairUp = stair.copy();

    genBoard();
    genDungeon(squares);
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
  }

  public void genBoard() {
    squares = new Square[numSquares][numSquares];

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {

        //needs difficulty (last param)

        squares[i][j] = new Square(i, j, 0, -1);
      }
    }

    //generates new down stair, copies up stair

    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    stairDown = new PVector();
    stairDown.x = (int)random(2, numSquares-2);
    stairDown.y = (int)random(2, numSquares-2);
    while (abs(stairDown.x-stairUp.x) < 8 && abs(stairDown.y-stairUp.y) < 8) {
      stairDown.x = (int)random(2, numSquares-2);
      stairDown.y = (int)random(2, numSquares-2);
    }
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;

    //Need 1 or more paths from stairUp to stairDown
  }

  public void genDungeon(Square[][] sq) {

    ArrayList<PVector> path = new ArrayList<PVector>();
    rooms = new ArrayList<Room>();
    Square[][] tempBoard = sq;

    for (int i = 0; i < roomTries; i++) {
      int x = (int)random(0, numSquares); 
      int y = (int)random(0, numSquares);
      int rwidth = (int)random(avgRoomSize-2, avgRoomSize-2); 
      int rheight = (int)random(avgRoomSize-2, avgRoomSize-2);
      rooms.add(new Room(x,y,constrain(x+rwidth, 0, numSquares-1),constrain(y+rheight, 0, numSquares-1), floorNum));
      
      for(int j = 0; j<rooms.size()-2; j++){ 
        if(rooms.get(j).overlaps(rooms.get(rooms.size()-1))){
           rooms.remove(rooms.size()-1); 
        }
      }
    }


    PVector curSq = new PVector(stairUp.x, stairUp.y);
    PVector tarSq = new PVector(stairDown.x, stairDown.y);
  }
}