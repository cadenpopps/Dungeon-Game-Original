class Room {

  int x, y;
  int rwidth, rheight;
  ArrayList<Square> childSquares = new ArrayList<Square>();

  public Room(int posx, int posy, int recwidth, int recheight, int floor) {

    x = posx;
    y = posy;
    rwidth = recwidth;
    rheight = recheight;

    for (int i = x; i<x+rwidth; i++) {
      for (int j = y; j<y+rheight; j++) {
        childSquares.add(dungeon.floors.get(floor).squares[i][j]);
      }
    }
  }
}