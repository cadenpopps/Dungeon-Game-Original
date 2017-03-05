import java.util.Collections;
import java.util.Comparator;


class SightLine {

  int startx, starty, endx, endy;
  boolean straight;
  ArrayList<Square> touching;

  public SightLine(int sx, int sy, int ex, int ey) {

    straight = false;
    touching = new ArrayList<Square>();

    startx = sx;
    starty = sy;
    endx = ex;
    endy = ey;
    if (sx == ex) {
      straight = true;
    }
    if (sy == ey) {
      straight = true;
    }

    if (!straight) {
      findTouching();
    } else {
      findStraightTouching();
    }
  }


  void findTouching() {

    double deltax = startx - endx;
    double deltay = starty - endy;
    double deltaerr = abs((float)(deltay / deltax));  
    double error = deltaerr - 0.5;
    int j = starty;
    if (startx<endx) {
      for (int i = startx; i<=endx; i++) {
        touching.add(dungeon.floors.get(currentFloor).board[i][j]);
        error = error + deltaerr;
        if (error >= 0.5) { 
          if (starty<endy) {
            j = j + 1;
          } else {
            j = j - 1;
          }
          error = error - 1.0;
        }
      }
    } else {
      for (int i = startx; i>=endx; i--) {
        touching.add(dungeon.floors.get(currentFloor).board[i][j]);
        error = error + deltaerr;
        if (error >= 0.5) { 
          if (starty<endy) {
            j = j + 1;
          } else {
            j = j - 1;
          }
          error = error - 1.0;
        }
      }
    }

    deltax = startx - endx;
    deltay = starty - endy;
    deltaerr = abs((float)(deltax / deltay));  
    error = deltaerr - 0.5;
    int a = startx;
    if (starty<endy) {
      for (int b = starty; b<=endy; b++) {
        touching.add(dungeon.floors.get(currentFloor).board[a][b]);
        error = error + deltaerr;
        if (error >= 0.5) { 
          if (startx<endx) {
            a = a + 1;
          } else {
            a = a - 1;
          }
          error = error - 1.0;
        }
      }
    } else {
      for (int b = starty; b>=endy; b--) {
        touching.add(dungeon.floors.get(currentFloor).board[a][b]);
        error = error + deltaerr;
        if (error >= 0.5) { 
          if (startx<endx) {
            a = a + 1;
          } else {
            a = a - 1;
          }
          error = error - 1.0;
        }
      }
    }
  }

  void findStraightTouching() {

    if (startx == endx) {
      if (starty<endy) {
        for (int i = starty; i<=endy; i++) {
          touching.add(dungeon.floors.get(currentFloor).board[startx][i]);
        }
      } else {
        for (int i = starty; i>=endy; i--) {
          touching.add(dungeon.floors.get(currentFloor).board[startx][i]);
        }
      }
    } else if (starty == endy) {
      if (startx<endx) {
        for (int i = startx; i<=endx; i++) {
          touching.add(dungeon.floors.get(currentFloor).board[i][starty]);
        }
      } else {
        for (int i = startx; i>=endx; i--) {
          touching.add(dungeon.floors.get(currentFloor).board[i][starty]);
        }
      }
    }
  }
}