
Dungeon dungeon;
int currentFloor, currentX, currentY;

void setup() {

  size(1000, 800);
  //fullScreen(P2D, 2);

  startUp();
}

void draw() {

  background(51);

  fill(255);
  int numSquares = dungeon.floors.get(currentFloor).numSquares;
  int squareSize = (height-100)/numSquares;
  pushMatrix();
  translate(50, 50);
  for (int i = 0; i < numSquares; i++) {
    for (int j = 0; j < numSquares; j++) {
      Square curSquare = dungeon.floors .get(currentFloor).squares[i][j];
      int curSquareType = curSquare.squareType;
      if (curSquare.squareType==-2) {
        fill(150, 0, 0);
      } else if (curSquare.squareType ==-3) {
        fill(0, 150, 0);
      }

      rect(i*squareSize, j*squareSize, squareSize, squareSize);
    }
  }
  popMatrix();
}

void startUp() {

  int floors, squares;
  floors = (int)random(8, 13);
  squares = (int)random(17, 23);

  currentFloor = 0;
  currentX = (int)random(squares);
  currentY = (int)random(squares);

  dungeon = new Dungeon(floors, squares);
}