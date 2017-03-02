class Mob {

  int x, y;

  public Mob(int _x, int _y) {

    x = _x;
    y = _y;
  }

  public void update() {
    if (dist(x, y, player.x, player.y)<10 && dungeon.floors.get(currentFloor).board[(int)x][(int)y].region == dungeon.floors.get(currentFloor).board[(int)player.x][(int)player.y].region) {

      if (x<player.x && y<player.y) {
        if (random(1)<.5) {
          if (!this.move('d', false)) {
            this.move('r', false);
          }
        } else {
          if (!this.move('r', false)) {
            this.move('d', false);
          }
        }
      } else if (x>player.x && y<player.y) {
        if (random(1)<.5) {
          if (!this.move('d', false)) {
            this.move('l', false);
          }
        } else {
          if (!this.move('l', false)) {
            this.move('d', false);
          }
        }
      } else if (x<player.x && y>player.y) {
        if (random(1)<.5) {
          if (!this.move('u', false)) {
            this.move('r', false);
          }
        } else {
          if (!this.move('r', false)) {
            this.move('u', false);
          }
        }
      } else if (x>player.x && y>player.y) {
        if (random(1)<.5) {
          if (!this.move('u', false)) {
            this.move('l', false);
          }
        } else {
          if (!this.move('l', false)) {
            this.move('u', false);
          }
        }
      }
    }
  }

  public boolean move(char dir, boolean player) {

    boolean sucess = false;

    if (player) {
      dungeon.floors.get(currentFloor).board[x][y].containsMob = false;
    }

    switch(dir) {
    case 'u':
      if (y>0 && (dungeon.floors.get(currentFloor).board[(int)x][(int)y-1].squareType!=-1 && dungeon.floors.get(currentFloor).board[(int)x][(int)y-1].squareType!=2 && !dungeon.floors.get(currentFloor).board[(int)x][(int)y-1].containsMob)) {
        if (player) {
          y--;
          sucess = true;
        } else if (dungeon.floors.get(currentFloor).board[(int)x][(int)y-1].squareType!=-5) {
          y--;
          sucess = true;
        }
      }
      break;
    case 'd':
      if (y<dungeon.floors.get(currentFloor).numSquares-1 && (dungeon.floors.get(currentFloor).board[(int)x][(int)y+1].squareType!=-1 && dungeon.floors.get(currentFloor).board[(int)x][(int)y+1].squareType!=2 && !dungeon.floors.get(currentFloor).board[(int)x][(int)y+1].containsMob)) {
        if (player) {
          y++;
          sucess = true;
        } else if (dungeon.floors.get(currentFloor).board[(int)x][(int)y+1].squareType!=-5) {
          y++;
          sucess = true;
        }
      }
      break;
    case 'l':
      if (x>0 && (dungeon.floors.get(currentFloor).board[(int)x-1][(int)y].squareType!=-1 && dungeon.floors.get(currentFloor).board[(int)x-1][(int)y].squareType!=2 && !dungeon.floors.get(currentFloor).board[(int)x-1][(int)y].containsMob)) {
        if (player) {
          x--;
          sucess = true;
        } else if (dungeon.floors.get(currentFloor).board[(int)x-1][(int)y].squareType!=-5) {
          x--;
          sucess = true;
        }
      }
      break;
    case 'r':
      if (x<dungeon.floors.get(currentFloor).numSquares-1 && (dungeon.floors.get(currentFloor).board[(int)x+1][(int)y].squareType!=-1 && dungeon.floors.get(currentFloor).board[(int)x+1][(int)y].squareType!=2 && !dungeon.floors.get(currentFloor).board[(int)x+1][(int)y].containsMob)) {
        if (player) {
          x++;
          sucess = true;
        } else if (dungeon.floors.get(currentFloor).board[(int)x+1][(int)y].squareType!=-5) {
          x++;
          sucess = true;
        }
      }
      break;
    }

    if (player && sucess) {
      dungeon.floors.get(currentFloor).board[x][y].containsMob = true;
      for (Mob m : dungeon.floors.get(currentFloor).mobs) {
        dungeon.floors.get(currentFloor).board[m.x][m.y].containsMob = false;
        m.update();
        dungeon.floors.get(currentFloor).board[m.x][m.y].containsMob = true;
      }
    } else if (player) {
      dungeon.floors.get(currentFloor).board[x][y].containsMob = true;
    }

    return sucess;
  }
}