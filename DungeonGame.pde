
Dungeon dungeon;
int currentFloor, currentX, currentY;
int floors, squares;

void setup() {

  size(1000, 800);
  //fullScreen(P2D, 2);

  textSize(20);
  stroke(50);
  startUp();
}

void draw() {

  background(200);

  fill(255);
  int numSquares = dungeon.floors.get(currentFloor).numSquares;
  int squareSize = (height-100)/numSquares;
  pushMatrix();
  translate(50, 50);
  for (int i = 0; i < numSquares; i++) {
    for (int j = 0; j < numSquares; j++) {
      Square curSquare = dungeon.floors.get(currentFloor).squares[i][j];
      int curSquareType = curSquare.squareType;
      if (curSquareType==-1) {
        fill(50);
      } else if (curSquareType == 0) {
        fill(255-(4*currentFloor));
      } else if (curSquare.squareType==-2) {
        fill(150, 0, 0);
      } else if (curSquare.squareType ==-3) {
        fill(0, 150, 0);
      }

      rect(i*squareSize, j*squareSize, squareSize, squareSize);
    }
  }
  popMatrix();

  fill(255);
  text("Current Floor: " + (currentFloor+1), width-200, height-60);
}

void startUp() {

  //need random number of floors
  
  floors = 4;
  squares = (int)random(35, 45);

  currentFloor = 0;
  currentX = (int)random(squares);
  currentY = (int)random(squares);

  dungeon = new Dungeon(floors, squares);
}

void mousePressed() {

  if (mouseButton == LEFT) {
    if (currentFloor<floors-1) {
      currentFloor++;
    } else {
      currentFloor = 0;
    }
  }

  if (mouseButton == RIGHT) {
    startUp();
  }
}