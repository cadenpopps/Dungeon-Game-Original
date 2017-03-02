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
    boolean fullShadow = false;
    //line of sight

    for (int a = 0; a<8; a++) {
      for (int i = 0; i<=4; i++) {
        //PVector oct = octant(i, 0, a);
        for (int j = 0; j<=i; j++) {
          PVector oct = octant(i, j, a);
          int tempX = constrain(x+(int)oct.x, 0, numSquares-1);
          int tempY = constrain(y-(int)oct.y, 0, numSquares-1);

          if (!fullShadow) {
            canSee.add(dungeon.floors.get(currentFloor).board[tempX][tempY]);
            if (!hasSeen.contains(dungeon.floors.get(currentFloor).board[tempX][tempY])) {
              hasSeen.add(dungeon.floors.get(currentFloor).board[tempX][tempY]);
            }
          } else {
            var projection = projectTile(row, col);

            // Set the visibility of this tile.
            var visible = !line.isInShadow(projection);
            tiles[pos].isVisible = visible;

            // Add any opaque tiles to the shadow map.
            if (visible && tiles[pos].isWall) {
              line.add(projection);
              fullShadow = line.isFullShadow;
            }
          }
        }
      }
    }
  }


  public PVector octant(int row, int col, int oct) {
    switch (oct) {
    case 0: 
      return new PVector( col, -row);
    case 1: 
      return new PVector( row, -col);
    case 2: 
      return new PVector( row, col);
    case 3: 
      return new PVector( col, row);
    case 4: 
      return new PVector(-col, row);
    case 5: 
      return new PVector(-row, col);
    case 6: 
      return new PVector(-row, -col);
    case 7: 
      return new PVector(-col, -row);
    }
    return null;
  }
}