
Dungeon dungeon;
int currentFloor, currentX, currentY, numSquares, squareSize;
int floors, squares;
int step = 0;
int counter = 0, genCounter = 0, time = millis()+500;
boolean delay = false;
//PButton b;

void setup() {

  size(1000, 800);
  //fullScreen(P2D, 2);

  textSize(20);
  startUp();
}

void draw() {

  //if (delay && millis()>time) {
  //  time = millis()+300;
  //  dungeon.floors.get(currentFloor).genDungeon(genCounter); 
  //  genCounter++;
  //  if (genCounter == 14) {
  //    startUp();
  //  }
  //}

  //if (counter==1) {
  //  startUp();
  //  counter = 0;
  //}
  ////counter ++;

  background(50-(currentFloor*2));

  pushMatrix();
  translate(50, 50);
  for (int i = 0; i < numSquares; i++) {
    for (int j = 0; j < numSquares; j++) {
      //current square
      Square curSquare = dungeon.floors.get(currentFloor).squares[i][j];
      //current squareType
      int curSquareType = curSquare.squareType;
      //defualt stroke
      stroke(50-(currentFloor*2), 50);
      //walls
      if (curSquareType==-1) {
        fill(50-(currentFloor*2));
        stroke(50-(currentFloor*2));
      } 
      //paths
      else if (curSquareType == 0) {
        fill(250-(currentFloor*5), 245-(currentFloor*5), 240-(currentFloor*5));
      } 
      //downStair
      else if (curSquare.squareType==-2) {
        fill(150, 0, 0);
      } 
      //upStair
      else if (curSquare.squareType ==-3) {
        fill(0, 150, 0);
      } 
      //door
      else if (curSquare.squareType == -5) {
        fill(227, 155, 57);
      }

      //draw the square
      rect(i*squareSize, j*squareSize, squareSize, squareSize);
    }
  }
  popMatrix();

  fill(255);
  text("Current Floor: " + (currentFloor+1), width-180, height-60);
}

void startUp() {

  //need random number of floors
  genCounter = 0;
  floors = (int)random(7, 15);
  squares = (int)random(30, 40);
  if (squares%2==0) {
    squares--;
  }

  numSquares = squares;
  squareSize = (height-100)/numSquares;

  currentFloor = 0;
  currentX = (int)random(squares);
  currentY = (int)random(squares);

  dungeon = new Dungeon(floors, squares, delay);
}

void mousePressed() {

  if (mouseButton == LEFT) {
    if (currentFloor<floors-1) {
      currentFloor++;
    } else {
      currentFloor = 0;
    }
    genCounter = 0;
  }

  if (mouseButton == RIGHT) {
    startUp();
  }
}