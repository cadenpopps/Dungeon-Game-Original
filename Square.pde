class Square {

  int locX, locY;
  int difficulty;
  int squareType;
  //up, right, down, left
  boolean deadend;
  int[] regionColor;
  Region region;
  boolean containsMob;
  PImage texture;

  //new square stores location and diffifculty given by floor
  public Square(int x, int y, int dif, int type) {

    locX = x;
    locY = y;
    difficulty = dif;
    squareType = type;
    deadend = false;
    region = null;
    containsMob = false;
    texture = null;
  }


  //copies a Square
  public Square copy() {
    return(new Square(this.locX, this.locY, this.difficulty, this.squareType));
  }


  //returns an arraylist of pvectors of moves (for maze)
  public ArrayList<PVector> moves(Square[][] board) {
    ArrayList<PVector> moves = new ArrayList<PVector>();
    if (this.locX > 1 && board[locX-1][locY].squareType == -1 && (locY)%2==1 && board[locX-1][locY].numNeighbors(board)<2) {
      moves.add(new PVector(locX-1, locY));
    }
    if (this.locX < board.length-2 && board[locX+1][locY].squareType == -1 && (locY)%2==1 && board[locX+1][locY].numNeighbors(board)<2) {
      moves.add(new PVector(locX+1, locY));
    }
    if (this.locY > 1 && board[locX][locY-1].squareType == -1 && (locX)%2==1 && board[locX][locY-1].numNeighbors(board)<2) {
      moves.add(new PVector(locX, locY-1));
    }
    if (this.locY < board.length-2 && board[locX][locY+1].squareType == -1 && (locX)%2==1 && board[locX][locY+1].numNeighbors(board)<2) {
      moves.add(new PVector(locX, locY+1));
    }
    return moves;
  }


  //returns the number of neighbors, doors or paths
  public int numNeighbors(Square[][] board) {
    int neighbors = 0;

    if (locX>0 && (board[locX-1][locY].squareType == 0 || board[locX-1][locY].squareType == -5)) {
      neighbors++;
    }
    if (locX<numSquares-2 && (board[locX+1][locY].squareType == 0 || board[locX+1][locY].squareType == -5)) {
      neighbors++;
    }
    if (locY>0 && (board[locX][locY-1].squareType == 0 || board[locX][locY-1].squareType == -5)) {
      neighbors++;
    }
    if (locY<numSquares-2 && (board[locX][locY+1].squareType == 0 || board[locX][locY+1].squareType == -5)) {
      neighbors++;
    }

    return neighbors;
  }


  //returns the number of neighbors, doors or paths
  public ArrayList<Square> neighbors(Square[][] board) {

    ArrayList<Square> neighbors = new ArrayList<Square>();

    if (locX>0 && (board[locX-1][locY].squareType == 0 || board[locX-1][locY].squareType == -5 || board[locX-1][locY].squareType == -2)) {
      neighbors.add(board[locX-1][locY]);
    }
    if (locX<numSquares-2 && (board[locX+1][locY].squareType == 0 || board[locX+1][locY].squareType == -5 || board[locX+1][locY].squareType == -2)) {
      neighbors.add(board[locX+1][locY]);
    }
    if (locY>0 && (board[locX][locY-1].squareType == 0 || board[locX][locY-1].squareType == -5 || board[locX][locY-1].squareType == -2)) {
      neighbors.add(board[locX][locY-1]);
    }
    if (locY<numSquares-2 && (board[locX][locY+1].squareType == 0 || board[locX][locY+1].squareType == -5 || board[locX][locY+1].squareType == -2)) {
      neighbors.add(board[locX][locY+1]);
    }
    
    //println(neighbors.size());

    return neighbors;
  }


  //returns the number of diagonal neighbors
  public int diagNeighbors(Square[][] board, int numSquares) {
    int neighbors = 0;

    if (locX>0 && board[locX-1][locY-1].squareType == 0) {
      neighbors++;
    }
    if (locX<numSquares-2 && board[locX+1][locY+1].squareType == 0) {
      neighbors++;
    }
    if (locY>0 && board[locX+1][locY-1].squareType == 0) {
      neighbors++;
    }
    if (locY<numSquares-2 && board[locX-1][locY+1].squareType == 0) {
      neighbors++;
    }

    return neighbors;
  }


  //return the number of path neighbors
  public int pathNeighbors(Square[][] board, int numSquares) {
    int neighbors = 0;

    if (locX>0 && board[locX-1][locY].squareType == 0) {
      neighbors++;
    }
    if (locX<numSquares-2 && board[locX+1][locY].squareType == 0) {
      neighbors++;
    }
    if (locY>0 && board[locX][locY-1].squareType == 0) {
      neighbors++;
    }
    if (locY<numSquares-2 && board[locX][locY+1].squareType == 0) {
      neighbors++;
    }

    return neighbors;
  }


  //returns true if this square should be a connector
  public boolean connector(ArrayList<Region> regions) {

    for (Region r : regions) {
      if (r.connected) {
        if (this.adjacentTo(r)) {
          for (Region u : regions) {
            if (!u.connected) {
              if (this.adjacentTo(u)) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }


  //returns true if this square is adjacent to region
  public boolean adjacentTo(Region region) {
    boolean isAdjacent = false;

    for (Square s : region.children) {
      if ((locX-1 == s.locX && locY == s.locY) || (locX+1 == s.locX && locY == s.locY) || (locX == s.locX && locY-1 == s.locY) || (locX == s.locX && locY+1 == s.locY)) {
        isAdjacent = true;
      }
    }
    return isAdjacent;
  }
}