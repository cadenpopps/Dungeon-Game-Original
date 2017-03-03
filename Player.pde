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
    for (int a = 0; a<8; a++) {
      for (int i = 0; i<=4; i++) {
        //PVector oct = octant(i, 0, a);
        for (int j = 0; j<=i; j++) {
          PVector oct = octant(i, j, a);
          int tempX = constrain(x+(int)oct.x, 0, numSquares-1);
          int tempY = constrain(y-(int)oct.y, 0, numSquares-1);


          //var projection = projectTile(row, col);

          //// Set the visibility of this tile.
          boolean visible = canSee(dungeon.floors.get(currentFloor).board[tempX][tempY]);
          if (visible) {
            canSee.add(dungeon.floors.get(currentFloor).board[tempX][tempY]);
          }

          //// Add any opaque tiles to the shadow map.
          //if (visible && tiles[pos].isWall) {
          //  line.add(projection);
          //  fullShadow = line.isFullShadow;
          //}
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

  public boolean canSee(Square tar) {

    double deltax = tar.locX - this.x;
    double deltay = tar.locY - this.y;
    double deltaerr = abs((float)(deltay / deltax))  ;  
    double error = deltaerr - 0.5;
    int j = this.x;
    for (int i = this.x; i<tar.locX; i++) {
      if (dungeon.floors.get(currentFloor).board[i][j].squareType==-1) {
        return false;
      }
      error = error + deltaerr;
      if (error >= 0.5) { 
        j = j + 1;
        error = error - 1.0;
      }
    }
    return true;
  }
}