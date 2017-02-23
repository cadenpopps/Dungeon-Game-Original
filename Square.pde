class Square {

  int locX, locY;
  int difficulty;
  int squareType;

  public Square(int x, int y, int dif, int type) {

    //new square stores location and diffifculty given by floor
    locX = x;
    locY = y;
    difficulty = dif;
    squareType = type;
  }
  
  public Square copy(){
    return(new Square(this.locX, this.locY, this.difficulty, this.squareType));
  }
  
}