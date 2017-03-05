class Player extends Mob {

  ArrayList<Square> canSee;
  ArrayList<Square> hasSeen;
  Square[][] tempBoard;
  final int radius = 20;
  public Player(int x, int y) {
    super(x, y);
    canSee = new ArrayList<Square>();
    hasSeen = new ArrayList<Square>();
    tempBoard = new Square[numSquares][numSquares];
  }

  public void update() {

    if (dungeon.floors.get(currentFloor).board[(int)x][(int)y].squareType==-2) {
      nextFloorAnimation = true;
    }

    canSee = new ArrayList<Square>();
    //brightness and mobs
    for (int i = 0; i < numSquares; i++) {
      for (int j = 0; j < numSquares; j++) {
        float distance = dist(player.x, player.y, i, j);
        dungeon.floors.get(currentFloor).board[i][j].lightLevel = (int) distance;
      }
    }

    //line of sight

    for (int i = x-radius; i <= x+radius; i++) {
      for (int j = y-radius; j <= y+radius; j++) {
        if (i>=0 && j>=0 && i<numSquares && j<numSquares) {
          SightLine l = new SightLine(x, y, i, j);
          boolean blocked = false;
          for (int k = 0; k<l.touching.size(); k++) {
            if (blocked) {
              //canSee.add(l.touching.get(k));
              continue;
            } else if (l.touching.get(k).squareType==-1 || (l.touching.get(k).squareType==-5 && !l.touching.get(k).isOpen)) {
              blocked = true;
              canSee.add(l.touching.get(k));
              if (!hasSeen.contains(l.touching.get(k))) {
                hasSeen.add(l.touching.get(k));
              }
            } else if (dungeon.floors.get(currentFloor).board[x][y].region != null && !dungeon.floors.get(currentFloor).board[x][y].region.path && l.touching.get(k).region == dungeon.floors.get(currentFloor).board[x][y].region) {
              canSee.add(l.touching.get(k));
              if (!hasSeen.contains(l.touching.get(k))) {
                hasSeen.add(l.touching.get(k));
              }
            } else {
              canSee.add(l.touching.get(k));
              if (!hasSeen.contains(l.touching.get(k))) {
                hasSeen.add(l.touching.get(k));
              }
            }
          }
        }
      }
    }

    for (int a = canSee.size()-1; a>=0; a--) {
      if (canSee.get(a).squareType == 0) {
        for (int i = canSee.get(a).locX-1; i<=canSee.get(a).locX+1; i++) {
          for (int j = canSee.get(a).locY-1; j<=canSee.get(a).locY+1; j++) {
            if (i>0 && j>0 && i<numSquares-1 && j<numSquares-1 && (i!=canSee.get(a).locX || j!=canSee.get(a).locY)) {
              //if (dungeon.floors.get(currentFloor).board[i][j].squareType == -1 || dungeon.floors.get(currentFloor).board[i][j].squareType == -5) {
                if (!hasSeen.contains(dungeon.floors.get(currentFloor).board[i][j])) {
                  hasSeen.add(dungeon.floors.get(currentFloor).board[i][j]);
                }
             // }
            }
          }
        }
      }
    }
  }

  //public PVector octant(int row, int col, int oct) {
  //  switch (oct) {
  //  case 0: 
  //    return new PVector( col, -row);
  //  case 1: 
  //    return new PVector( row, -col);
  //  case 2: 
  //    return new PVector( row, col);
  //  case 3: 
  //    return new PVector( col, row);
  //  case 4: 
  //    return new PVector(-col, row);
  //  case 5: 
  //    return new PVector(-row, col);
  //  case 6: 
  //    return new PVector(-row, -col);
  //  case 7: 
  //    return new PVector(-col, -row);
  //  }
  //  return null;
  //}

  public void openDoor() {
    for (int i = x-1; i<=x+1; i++) {
      for (int j = y-1; j<=y+1; j++) {
        if (i>0 && j>0 && i<numSquares-1 && j<numSquares-1 && (i!=x || j!=y)) {
          if (dungeon.floors.get(currentFloor).board[i][j].squareType == -5) {
            dungeon.floors.get(currentFloor).board[i][j].isOpen = !dungeon.floors.get(currentFloor).board[i][j].isOpen;
          }
        }
      }
    }
  }

  public void attack() {
    for (int i = x-2; i<=x+2; i++) {
      for (int j = y-2; j<=y+2; j++) {
        if (i>0 && j>0 && i<numSquares-1 && j<numSquares-1 && (i!=x || j!=y)) {
          if (dungeon.floors.get(currentFloor).board[i][j].containsMob) {
            for (int a = dungeon.floors.get(currentFloor).mobs.size()-1; a>=0; a--) {
              if (dungeon.floors.get(currentFloor).mobs.get(a).x == i && dungeon.floors.get(currentFloor).mobs.get(a).y == j) {
                dungeon.floors.get(currentFloor).mobs.remove(a);
                dungeon.floors.get(currentFloor).board[i][j].containsMob = false;
              }
            }
          }
        }
      }
    }
  }
}