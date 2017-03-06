class Room {

  int x1, y1, x2, y2;
  int rwidth, rheight;
  int roomType;
  ArrayList<Square> childSquares;


  //makes a new room that has a position for top left corner and bottom right corner
  public Room(int _x1, int _y1, int _x2, int _y2, int numSquares) {

    roomType = 0;
    
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    childSquares = new ArrayList<Square>();

    //push x1 and y2 to odd squares
    if (x1%2==0) {
      x1 ++;
    }
    if (y1%2==0) {
      y1 ++;
    }

    //push x2 and y2 to even squares
    if (x2%2==1) {
      x2 ++;
    }
    if (y2%2==1) {
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
  public boolean overlaps(Room tempRoom) {
    boolean overlaps = true;

    //if room 1 is to the left or right of room 2, they don't overlap
    if ((tempRoom.x1 > this.x2|| tempRoom.x2<this.x1)) {
      overlaps = false;
    }

    //if room 2 is to above or below room 2, they don't overlap
    if ((tempRoom.y1 > this.y2 || tempRoom.y2<this.y1)) {
      overlaps = false;
    }

    

    return overlaps;
  }

  public boolean notRoom(){
    //if the room is too small, it shouldn't be a room
    if (abs(this.rwidth-this.rheight)>3 || this.rheight<2 || this.rwidth <2) {
      return true;
    }
    return false;
  }

  //add all the child squares to childSquares
  public void addChildren(Square[][] board) {

    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        childSquares.add(board[i][j]);
      }
    }
  }


  //set all child squares to 0
  public void makeRoom(Square[][] board) {

    for (int i = x1; i<x2; i++) {
      for (int j = y1; j<y2; j++) {
        board[i][j].squareType = 0;
      }
    }
  }
}