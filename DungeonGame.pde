
Dungeon dungeon;
int currentFloor, currentX, currentY, numSquares, squareSize, numLoot;
int floors, squares;
int step = 0;
int counter = 0, genCounter = 0, time = millis()+200, floorAnimationCounter = 0;
boolean delay = false, nextFloorAnimation = false;
Player player;
char moving = ' ';
int moves= 0;
ArrayList<PImage> wallTextures;
ArrayList<PImage> floorTextures;

void setup() {

  size(1000, 800);
  //fullScreen(P2D, 2);

  wallTextures = new ArrayList<PImage>();
  wallTextures.add(loadImage("assets/wallTexture0.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture1.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture2.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture3.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture4.jpg"));

  floorTextures = new ArrayList<PImage>();
  floorTextures.add(loadImage("assets/floorTexture0.jpg"));
  //floorTextures.add(loadImage("assets/floorTexture1.jpg"));
  //floorTextures.add(loadImage("assets/floorTexture2.jpg"));

  frameRate(60);

  noStroke();
  textSize(20);
  startUp();
}

void draw() {

  //if (findPath(dungeon.floors.get(currentFloor).stairDown, dungeon.floors.get(currentFloor).stairUp, dungeon.floors.get(currentFloor).squares)) {
  //  startUp();
  //} else {
  //  print("fail");
  //  startUp();
  //}

  //if (delay && millis()>time) {
  //  time = millis()+50;
  //  dungeon.floors.get(currentFloor).genDungeon(genCounter); 
  //  genCounter++;
  //  if (genCounter == 1000) {
  //    //startUp();
  //  }
  //}   

  if (moves>0) {
    if (moves%3 ==0) {
      player.move(moving, true);
    }
    moves--;
  }

  player.update();

  background(50-(currentFloor*2));

  pushMatrix();
  translate(50, 50);
  for (int i = 0; i < numSquares; i++) {
    for (int j = 0; j < numSquares; j++) {
      //current square
      Square curSquare = dungeon.floors.get(currentFloor).board[i][j];
      //current squareType
      int curSquareType = curSquare.squareType;
      //defualt stroke
      //stroke(50-(currentFloor*2), 50);

      if (player.canSee.contains(curSquare)) {
        //walls
        if (curSquareType==-1) {
          //fill(50-(currentFloor*2));
          //stroke(50-(currentFloor*2));
          image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
        } 
        //paths
        else if (curSquareType == 0) {
          image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
          //fill(250-(currentFloor*5), 245-(currentFloor*5), 240-(currentFloor*5));
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
          fill(100, 50, 20);
        }
        //visited
        else if (curSquare.squareType == 1) {
          fill(255, 100, 100);
        }
        //loot
        else if (curSquare.squareType == 2) {
          fill(255, 50, 50);
        } 
        //mob placeHolder
        else if (curSquare.squareType == 3) {
          fill(150, 255, 50);
        }

        //draw the square
        if (curSquareType!=-1 && curSquareType!=0) {
          rect(i*squareSize, j*squareSize, squareSize, squareSize);
        } else {
          //fill(0, 100);
          //rect(i*squareSize, j*squareSize, squareSize, squareSize);
        }
        if (player.x == i && player.y == j) {
          //stroke(0);
          fill(20, 20, 20, 180);
          rect(i*squareSize+(squareSize/4), j*squareSize+(squareSize/4), squareSize/2, squareSize/2);
        } else if (curSquare.containsMob) {
          //stroke(255, 0);
          fill(255, 100, 0, 180);
          rect(i*squareSize+(squareSize/8), j*squareSize+(squareSize/8), squareSize/1.25, squareSize/1.25);
        }
      } else if (player.hasSeen.contains(curSquare)) {

        //walls
        if (curSquareType==-1) {
          image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
        } 
        //paths
        else if (curSquareType == 0) {
          image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
        } 
        //downStair
        else if (curSquare.squareType==-2) {
          fill(150, 0, 0, 100);
        } 
        //upStair
        else if (curSquare.squareType ==-3) {
          fill(0, 150, 0, 100);
        } 
        //door
        else if (curSquare.squareType == -5) {
          fill(100, 50, 20, 100);
        }
        //visited
        else if (curSquare.squareType == 1) {
          fill(255, 100, 100, 100);
        }
        //loot
        else if (curSquare.squareType == 2) {
          fill(255, 50, 50, 100);
        } 
        //mob placeHolder
        else if (curSquare.squareType == 3) {
          fill(150, 255, 50, 100);
        }

        if (curSquareType!=-1 && curSquareType!=0) {
          rect(i*squareSize, j*squareSize, squareSize, squareSize);
        } else {
          fill(0, 100);
          rect(i*squareSize, j*squareSize, squareSize, squareSize);
        }
        if (player.x == i && player.y == j) {
          //stroke(0);
          fill(200, 200, 200, 180);
          rect(i*squareSize+(squareSize/4), j*squareSize+(squareSize/4), squareSize/2, squareSize/2);
        }
      }
    }
  }
  popMatrix();

  if (nextFloorAnimation) {
    if (floorAnimationCounter<30) {
      fill(0, map(floorAnimationCounter, 0, 30, 0, 255));
      rect(0, 0, width, height);
    } else {
      if (floorAnimationCounter==31) {
        currentFloor++;
        numLoot=0;
        for (int i = 0; i<numSquares-1; i++) {
          for (int j = 0; j<numSquares-1; j++) {
            if (dungeon.floors.get(currentFloor).board[i][j].squareType==2) {
              numLoot++;
            }
          }
        }
      }
      fill(0, map(floorAnimationCounter, 30, 90, 255, 0));
      rect(0, 0, width, height);
    }
    floorAnimationCounter++;
    if (floorAnimationCounter == 90) {
      nextFloorAnimation = false;
    }
  } else {
    floorAnimationCounter = 0;
  }

  fill(255);
  text("Number Loot: " + (numLoot), width-180, height-120);
  text("Current Floor: " + (currentFloor+1), width-180, height-60);
}



boolean findPath(PVector down, PVector up, Square[][] board) {
  PVector start = up;
  PVector goal = down;

  //println(board[(int)start.x][(int)start.y].squareType);
  //println(board[(int)goal.x][(int)goal.y].squareType);

  ArrayList<Square> closedSet = new ArrayList<Square>();
  ArrayList<Square> openSet = new ArrayList<Square>();

  HashMap<Square, Square> cameFrom = new HashMap<Square, Square>((int)Math.pow(squares, 2));
  HashMap<Square, Float> gScore = new HashMap<Square, Float>((int)Math.pow(squares, 2));
  HashMap<Square, Float> fScore = new HashMap<Square, Float>((int)Math.pow(squares, 2));

  for (int i = 0; i<dungeon.floors.get(currentFloor).numSquares; i++) {
    for (int j = 0; j<dungeon.floors.get(currentFloor).numSquares; j++) {
      gScore.put(board[i][j], 1000.0);
    }
  }

  gScore.put(board[(int)start.x][(int)start.y], 0.0);
  fScore.put(board[(int)start.x][(int)start.y], heuristic(start, goal));

  openSet.add(board[(int)start.x][(int)start.y]);

  while (!openSet.isEmpty()) {
    Square current = board[(int)start.x][(int)start.y];
    float lowest = 1000;
    for (Square s : openSet) {
      if (fScore.get(s)<lowest) {
        lowest = fScore.get(s);
        current = s;
      }
    }
    if (current.locX == goal.x && current.locY == goal.y) {
      while (cameFrom.containsKey(current)) {
        current = cameFrom.get(current);
        //current.squareType = 1;
      }
      board[(int)start.x][(int)start.y].squareType = -3;
      return true;
    }
    openSet.remove(current);
    closedSet.add(current);
    for (Square s : current.neighbors(board)) {
      if (closedSet.contains(s)) {
      } else {

        float tempG = gScore.get(current) + 1;
        if (!openSet.contains(s)) {
          openSet.add(s);
        } 
        if (tempG < gScore.get(s)) {

          cameFrom.put(s, current);
          gScore.put(s, tempG);
          fScore.put(s, gScore.get(s) + heuristic(new PVector(s.locX, s.locY), goal));
        }
      }
    }
  }

  return false;
}

float heuristic(PVector start, PVector goal) {
  float heuristic = dist(start.x, start.y, goal.x, goal.y);
  return heuristic;
}


void startUp() {

  //need random number of floors
  genCounter = 0;
  //floors = (int)random(7, 10);
  floors = 9;
  //squares = (int)random(100, 150);
  squares = 20;
  if (squares%2==0) {
    squares--;
  }
  numLoot = 0;

  numSquares = squares;
  squareSize = (height-100)/numSquares;

  currentFloor = 0;
  currentX = (int)random(squares);
  currentY = (int)random(squares);

  dungeon = new Dungeon(floors, squares, delay);
  for (Floor f : dungeon.floors) {
    if (f.floorNum<f.numFloors-1 && !findPath(dungeon.floors.get(f.floorNum).stairDown, dungeon.floors.get(f.floorNum).stairUp, dungeon.floors.get(f.floorNum).board)) {
      startUp();
    }
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (dungeon.floors.get(f.floorNum).board[i][j].squareType==-1) {
          dungeon.floors.get(f.floorNum).board[i][j].texture = wallTextures.get((int)random(wallTextures.size()));
        }
        if (dungeon.floors.get(f.floorNum).board[i][j].squareType==0) {
          dungeon.floors.get(f.floorNum).board[i][j].texture = floorTextures.get((int)random(floorTextures.size()));
        }
      }
    }
  }

  for (int i = 0; i<numSquares-1; i++) {
    for (int j = 0; j<numSquares-1; j++) {
      if (dungeon.floors.get(currentFloor).board[i][j].squareType==2) {
        numLoot++;
      }
    }
  }

  player = new Player((int)dungeon.floors.get(0).stairUp.x, (int)dungeon.floors.get(0).stairUp.y);
}

void keyPressed() {
  if (key != CODED) {
    switch(key) {
    case 'w': 
      player.move('u', true);
      break;
    case 'a': 
      player.move('l', true);
      break;
    case 's': 
      player.move('d', true);
      break;
    case 'd': 
      player.move('r', true);
      break;

    case 'W': 
      moving = 'u';
      moves = 6;
      break;
    case 'A': 
      moving ='l';
      moves = 6;
      break;
    case 'S': 
      moving = 'd';
      moves = 6;
      break;
    case 'D': 
      moving = 'r';
      moves = 6;
      break;
    }
  } else {
    switch(keyCode) {
    case UP: 
      player.move('u', true);
      break;
    case RIGHT: 
      player.move('r', true);
      break;
    case DOWN: 
      player.move('d', true);
      break;
    case LEFT: 
      player.move('l', true);
      break;
    }
  }
}


void mousePressed() {

  if (mouseButton == LEFT) {
    //if (currentFloor<floors-1) {
    //  nextFloorAnimation = true;
    //} else {
    //  currentFloor = 0;
    //}
    //genCounter = 0;
  }

  if (mouseButton == RIGHT) {
    startUp();
  }
}