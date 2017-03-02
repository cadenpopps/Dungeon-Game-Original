class Player extends Mob {

  ArrayList<Square> canSee;
  ArrayList<Square> hasSeen;
  public Player(int x, int y) {
    super(x, y);
    canSee = new ArrayList<Square>();
    hasSeen = new ArrayList<Square>();
  }

  public void update() {

    if (dungeon.floors.get(currentFloor).board[(int)x][(int)y].squareType==-2) {
      nextFloorAnimation = true;
    }

    canSee = new ArrayList<Square>();

    //line of sight
    for (int i = 0; i<dungeon.floors.get(currentFloor).numSquares; i++) {
      for (int j = 0; j<dungeon.floors.get(currentFloor).numSquares; j++) {
        if (dist(x, y, i, j)<4) {
          canSee.add(dungeon.floors.get(currentFloor).board[i][j]);
          hasSeen.add(dungeon.floors.get(currentFloor).board[i][j]);
        }
      }
    }
  }
}