class Player extends Mob {

  ArrayList<Square> canSee;

  public Player(int x, int y) {
    super(x, y);
    canSee = new ArrayList<Square>();
  }

  public void update() {

    if (dungeon.floors.get(currentFloor).board[(int)x][(int)y].squareType==-2) {

      nextFloorAnimation = true;
    }

    canSee = new ArrayList<Square>();

    for (int i = 0; i<dungeon.floors.get(currentFloor).numSquares; i++) {
      for (int j = 0; j<dungeon.floors.get(currentFloor).numSquares; j++) {
        if (abs(x-i) <5 && abs(y-j)<5) {
          canSee.add(dungeon.floors.get(currentFloor).board[i][j]);
        }
      }
    }
  }
}