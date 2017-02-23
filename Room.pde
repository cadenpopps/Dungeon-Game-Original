class Room {

  int x1, y1, x2, y2;
  int rwidth, rheight;
  int parentFloor;
  ArrayList<Square> childSquares = new ArrayList<Square>();

  public Room(int posx1, int posy1, int posx2, int posy2, int f) {

    x1 = posx1;
    y1 = posy1;
    x2 = posx2;
    y2 = posy2;
    rwidth = abs(x1-x2);
    rheight = abs(y1-y2);
    parentFloor = f;
  }

  public boolean overlaps(Room newRoom) {
    boolean overlaps = true;
    if ((newRoom.x1 > this.x2|| newRoom.x2<this.x1)) {
      overlaps = false;
    }
    if ((newRoom.y1 > this.y2 || newRoom.y2<this.y1)) {
      overlaps = false;
    }
    return overlaps;
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