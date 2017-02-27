class Mob {

  int x, y;

  public Mob(int _x, int _y) {

    x = _x;
    y = _y;
  }

  public void move(char dir) {

    switch(dir) {
    case 'u':
      if (y>0 && dungeon.floors.get(currentFloor).board[(int)x][(int)y-1].squareType!=-1) {
        y--;
      }
      break;
    case 'd':
      if (y<dungeon.floors.get(currentFloor).numSquares-1 && dungeon.floors.get(currentFloor).board[(int)x][(int)y+1].squareType!=-1) {
        y++;
      }
      break;
    case 'l':
      if (x>0 && dungeon.floors.get(currentFloor).board[(int)x-1][(int)y].squareType!=-1) {
        x--;
      }
      break;
    case 'r':
      if (x<dungeon.floors.get(currentFloor).numSquares-1 && dungeon.floors.get(currentFloor).board[(int)x+1][(int)y].squareType!=-1) {
        x++;
      }
      break;
    }
  }
}