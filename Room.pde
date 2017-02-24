class Room {

  int x1, y1, x2, y2;
  int rwidth, rheight;
  int parentFloor;
  ArrayList<Square> childSquares = new ArrayList<Square>();

  public Room(int posx1, int posy1, int posx2, int posy2, int numSquares) {

    x1 = posx1;
    y1 = posy1;
    x2 = posx2;
    y2 = posy2;

    if (posx1%2==0) {
      x1 ++;
    }
    if (posy1%2==0) {
      y1 ++;
    }
    if (posx2%2==1) {
      x2 ++;
    }
    if (posy2%2==1) {
      y2 ++;
    }

    if (x2>numSquares-1) {
      x2 = numSquares-1;
    }
    if (y2>numSquares-1) {
      y2 = numSquares-1;
    }
    if (x2==numSquares-1) {
      x2 = numSquares-1;
    }
    if (y2==numSquares-1) {
      y2 = numSquares-1;
    }

    rwidth = abs(x1-x2);
    rheight = abs(y1-y2);
  }

  public boolean overlaps(Room newRoom) {
    boolean overlaps = true;
    if ((newRoom.x1 > this.x2|| newRoom.x2<this.x1)) {
      overlaps = false;
    }
    if ((newRoom.y1 > this.y2 || newRoom.y2<this.y1)) {
      overlaps = false;
    }
    if (abs(newRoom.rwidth-newRoom.rheight)>2 || newRoom.rheight<2 || newRoom.rwidth <2) {
      overlaps = true;
    }
    return overlaps;
  }

  public void addChildren(Square[][] squares) {
    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        childSquares.add(squares[i][j]);
      }
    }
  }

  public void makeRoom(Square[][] squares) {

    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        childSquares.add(squares[i][j]);
        squares[i][j].squareType = 0;
      }
    }
  }
}