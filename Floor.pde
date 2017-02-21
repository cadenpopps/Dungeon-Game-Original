class Floor {

  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;

  public Floor(int loc, int numSq, PVector stair) {

    //new floor stores floor number and has an Array of squares  
    floorNum = loc;
    numSquares = numSq;

    squares = new Square[numSquares][numSquares];

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        
        //needs difficulty (last param)
        
        squares[i][j] = new Square(i, j, 0);
      }
    }

    //generates new down stair, copies up stair

    stairUp = stair.copy();
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    stairDown = new PVector();
    stairDown.x = (int)random(numSquares);
    stairDown.y = (int)random(numSquares);
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;
  }
}