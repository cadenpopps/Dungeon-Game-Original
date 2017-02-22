
class Floor {


  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;
  boolean goOff = true;

  public Floor(int loc, int numSq, PVector stair) {

    //new floor stores floor number and has an Array of squares  
    floorNum = loc;
    numSquares = numSq;
    stairUp = stair.copy();

    genBoard();
    ArrayList<PVector> solution = genPaths(squares);
    for (int i = 0; i< solution.size(); i++) {
      squares[(int)solution.get(i).x][(int)solution.get(i).y].squareType = 0;
    }
    solution = genPaths(squares);
    for (int i = 0; i< solution.size(); i++) {
      squares[(int)solution.get(i).x][(int)solution.get(i).y].squareType = 0;
    }
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

  public ArrayList<PVector> genPaths(Square[][] sq) {

    int making = 0;

    ArrayList<PVector> path = new ArrayList<PVector>();

    //Square[][] tempBoard = sq;

    Square[][] tempBoard = new Square[numSquares][numSquares];
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        //copies board to tempBoard
        tempBoard[i][j] = sq[i][j].copy();
      }
    }

    PVector curSq = new PVector(stairUp.x, stairUp.y);
    PVector tarSq = new PVector(stairDown.x, stairDown.y);

    while (curSq.x != tarSq.x || curSq.y != tarSq.y) {
      tempBoard[(int)curSq.x][(int)curSq.y].squareType = 0;

      ArrayList<PVector> moves = possibleMoves(curSq);
      if (moves.size()>0) {
        print(making);
        making++;
        path.add(curSq);
        curSq = (moves.get((int)random(moves.size()-1)));
      } else {

        if (path.size()>0) {
          print("nope");
          curSq = (path.get(path.size()-1));
          path.remove(path.size()-1);
        } else {
          genBoard();
          path = new ArrayList<PVector>();

          tempBoard = new Square[numSquares][numSquares];
          for (int i = 0; i<numSquares; i++) {
            for (int j = 0; j<numSquares; j++) {
              //copies board to tempBoard
              tempBoard[i][j] = sq[i][j].copy();
            }
          }
          curSq = new PVector(stairUp.x, stairUp.y);
          tarSq = new PVector(stairDown.x, stairDown.y);
        }
      }
    }

    return path;
  }


  public ArrayList<PVector> possibleMoves(PVector pos) {
    ArrayList<PVector> moves = new ArrayList<PVector>();
    float randomDir = random(1);
    if (!goOff) {
      if (random(1)<.01) {
        goOff = true;
        randomDir = random(1);
      }
      if (pos.x<stairDown.x) {
        moves.add(new PVector(pos.x+1, pos.y));
      }
      if (pos.x>stairDown.x) {
        moves.add(new PVector(pos.x-1, pos.y));
      }
      if (pos.y<stairDown.y) {
        moves.add(new PVector(pos.x, pos.y+1));
      }
      if (pos.y>stairDown.y) {
        moves.add(new PVector(pos.x, pos.y-1));
      }
    } else {
      if (pos.x>0 && pos.x<numSquares-1 && pos.y>0 && pos.y<numSquares-1) {
        if (randomDir<.25) {
          moves.add(new PVector(pos.x+1, pos.y));
        }
        if (randomDir>=.25 && randomDir<.5) { 
          moves.add(new PVector(pos.x-1, pos.y));
        }
        if (randomDir>=.5 && randomDir<.75) {
          moves.add(new PVector(pos.x, pos.y+1));
        }
        if (randomDir>=.75 && randomDir<1) {
          moves.add(new PVector(pos.x, pos.y-1));
        }
      } else {
        if (pos.x<stairDown.x) {
          moves.add(new PVector(pos.x+1, pos.y));
        }
        if (pos.x>stairDown.x) {
          moves.add(new PVector(pos.x-1, pos.y));
        }
        if (pos.y<stairDown.y) {
          moves.add(new PVector(pos.x, pos.y+1));
        }
        if (pos.y>stairDown.y) {
          moves.add(new PVector(pos.x, pos.y-1));
        }
      }
    }
    if (random(1)<.1) {
      goOff=false;
    }
    return moves;
  }
}