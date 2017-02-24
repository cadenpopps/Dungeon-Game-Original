class Square {

  int locX, locY;
  int difficulty;
  int squareType;
  //up, right, down, left
  boolean[] walls;
  int[] regionColor;

  public Square(int x, int y, int dif, int type) {

    //new square stores location and diffifculty given by floor
    locX = x;
    locY = y;
    difficulty = dif;
    squareType = type;
    regionColor = new int[3];
    regionColor[0] = 255;
    regionColor[1] = 255;
    regionColor[2] = 255;
  }

  public Square copy() {
    return(new Square(this.locX, this.locY, this.difficulty, this.squareType));
  }

  public ArrayList<PVector> moves(Square[][] squares) {
    ArrayList<PVector> moves = new ArrayList<PVector>();
    if (this.locX > 1 && squares[locX-1][locY].squareType == -1 && (locY)%2==1 && squares[locX-1][locY].neighbors(squares)<2) {
      moves.add(new PVector(locX-1, locY));
    }
    if (this.locX < squares.length-2 && squares[locX+1][locY].squareType == -1 && (locY)%2==1 && squares[locX+1][locY].neighbors(squares)<2) {
      moves.add(new PVector(locX+1, locY));
    }
    if (this.locY > 1 && squares[locX][locY-1].squareType == -1 && (locX)%2==1 && squares[locX][locY-1].neighbors(squares)<2) {
      moves.add(new PVector(locX, locY-1));
    }
    if (this.locY < squares.length-2 && squares[locX][locY+1].squareType == -1 && (locX)%2==1 && squares[locX][locY+1].neighbors(squares)<2) {
      moves.add(new PVector(locX, locY+1));
    }
    return moves;
  }

  public int neighbors(Square[][] squares) {
    int neighbors = 0;

    if (locX>0 && squares[locX-1][locY].squareType == 0) {
      neighbors++;
    }
    if (locX<squares.length-1 && squares[locX+1][locY].squareType == 0) {
      neighbors++;
    }
    if (locY>0 && squares[locX][locY-1].squareType == 0) {
      neighbors++;
    }
    if (locY<squares.length-1 && squares[locX][locY+1].squareType == 0) {
      neighbors++;
    }

    return neighbors;
  }

  public boolean connector(Square[][] squares, ArrayList<Region> regions, int numSquares) {
    Region r1= null;
    if (locX>1 && squares[locX-1][locY].squareType == 0) {
      for (Region r : regions) {
        for (Square s : r.children) {
          if (s.equals(squares[locX-1][locY])) {
            r1 = r;
          }
        }
      }
    }
    if (locX < numSquares-1 && squares[locX+1][locY].squareType == 0) {
      for (Region r : regions) {
        for (Square s : r.children) {
          if (r1!=null) {
            if (s.equals(squares[locX+1][locY])) {
              if (r1!=r) {
                return true;
              }
            }
          }
          if (s.equals(squares[locX+1][locY])) {
            r1 = r;
          }
        }
      }
    }
    if (locY > 0 && squares[locX][locY-1].squareType == 0) {
      for (Region r : regions) {
        for (Square s : r.children) {
          if (r1!=null) {
            if (s.equals(squares[locX][locY-1])) {
              if (r1!=r) {
                return true;
              }
            }
          }
          if (s.equals(squares[locX][locY-1])) {
            r1 = r;
          }
        }
      }
    }
    if (locY < numSquares-1 && squares[locX][locY+1].squareType == 0) {
      for (Region r : regions) {
        for (Square s : r.children) {
          if (r1!=null) {
            if (s.equals(squares[locX][locY+1])) {
              if (r1!=r) {
                return true;
              }
            }
          }
          if (s.equals(squares[locX][locY+1])) {
            r1 = r;
          }
        }
      }
    }

    return false;
  }
}