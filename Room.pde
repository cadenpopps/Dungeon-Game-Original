class Room {

  int x1, y1, x2, y2;
  int rwidth, rheight;
  int parentFloor;
  ArrayList<Square> childSquares;


  //makes a new room that has a position for top left corner and bottom right corner
  public Room(int posx1, int posy1, int posx2, int posy2, int numSquares) {

    x1 = posx1;
    y1 = posy1;
    x2 = posx2;
    y2 = posy2;
    childSquares = new ArrayList<Square>();

    //push x1 and y2 to odd squares
    if (posx1%2==0) {
      x1 ++;
    }
    if (posy1%2==0) {
      y1 ++;
    }

    //push x2 and y2 to even squares
    if (posx2%2==1) {
      x2 ++;
    }
    if (posy2%2==1) {
      y2 ++;
    }

    //constrain x2 and y2 to numSquares -1
    if (x2>=numSquares-1) {
      x2 = numSquares-1;
    }
    if (y2>=numSquares-1) {
      y2 = numSquares-1;
    }

    //width and height
    rwidth = abs(x1-x2);
    rheight = abs(y1-y2);
  }


  //returns true if this room overlaps with a newRoom
  public boolean overlaps(Room newRoom, int numSquares) {
    boolean overlaps = true;

    //if room 1 is to the left or right of room 2, they don't overlap
    if ((newRoom.x1 > this.x2|| newRoom.x2<this.x1)) {
      overlaps = false;
    }

    //if room 2 is to above or below room 2, they don't overlap
    if ((newRoom.y1 > this.y2 || newRoom.y2<this.y1)) {
      overlaps = false;
    }

    //if the room is too small, it shouldn't be a room
    if (abs(newRoom.rwidth-newRoom.rheight)>3 || newRoom.rheight<2 || newRoom.rwidth <2) {
      overlaps = true;
    }

    //if the room is too close to the center, it should't be a room
    if (abs(newRoom.x1 - (numSquares/2))<3 && abs(newRoom.y1 - (numSquares/2))<3 && random(1)<.7) {
      overlaps = true;
    }
    if (abs(newRoom.x2 - (numSquares/2))<3 && abs(newRoom.y2 - (numSquares/2))<3 && random(1)<.7) {
      overlaps = true;
    }

    return overlaps;
  }


  //add all the child squares to childSquares
  public void addChildren(Square[][] squares) {

    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        childSquares.add(squares[i][j]);
      }
    }
  }


  //set all child squares to 0
  public void makeRoom(Square[][] squares) {

    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        squares[i][j].squareType = 0;
      }
    }
  }
}