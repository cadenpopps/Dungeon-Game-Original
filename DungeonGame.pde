Dungeon dungeon;
int currentFloor, numSquares, squareSize, numLoot;
int floors, squares;
int floorAnimationCounter = 0;
boolean delay = false, nextFloorAnimation = false, firstFloorAnimation = false;
Player player;
char moving = ' ';
int moves= 0;
int loading = 0;
int moveCooldown;
ArrayList<PImage> wallTextures;
ArrayList<PImage> floorTextures;
PImage playerTexture;
PImage stairTexture;

//grass restricts vision, breaks when you walk on it, has loot?
//food- turn based, steps deduct food value
//treasure chests for loot
//monsters or treassure chests drop food

void setup() {

  size(1000, 800);
  //fullScreen(P2D, 2);

  wallTextures = new ArrayList<PImage>();
  wallTextures.add(loadImage("data/wallTexture0.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture1.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture2.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture3.jpg"));
  //wallTextures.add(loadImage("assets/wallTexture4.jpg"));

  floorTextures = new ArrayList<PImage>();
  floorTextures.add(loadImage("data/floorTexture0.jpg"));
  //floorTextures.add(loadImage("assets/floorTexture1.jpg"));
  //floorTextures.add(loadImage("assets/floorTexture2.jpg"));

  playerTexture = loadImage("data/playerTexture.png");

  stairTexture = loadImage("data/stairTexture.png");


  frameRate(60);

  loading = 10;
}

void draw() {

  if (loading >= 2) {
    textSize(100);
    textAlign(CENTER);
    fill(map(loading, 10, 2, 50, 0));
    rect(0, 0, width, height);
    fill(255);
    text("Loading...", 0, height/2-100, width, height/2);
    loading--;
  }
  if (loading == 1) {
    noStroke();
    fill(map(loading, 10, 2, 50, 0));
    rect(0, 0, width, height);
    fill(255);
    text("Loading...", 0, height/2-100, width, height/2);
    textAlign(LEFT);
    textSize(20);
    startUp();
    loading--;
    firstFloorAnimation = true;
  }
  if (loading == 0) {

    if (moveCooldown>0) {
      moveCooldown--;
    }

    background(0);

    pushMatrix();
    float scale = (numSquares)/15;
    scale(scale);
    translate((-player.x*squareSize) + (width/scale/2) - (230/scale/2), (-player.y*squareSize)+(height/scale/2) - (30/scale/2));
    for (int i = 0; i < numSquares; i++) {
      for (int j = 0; j < numSquares; j++) {
        //current square
        Square curSquare = dungeon.floors.get(currentFloor).board[i][j];
        //current squareType
        if (player.canSee.contains(curSquare) || player.hasSeen.contains(curSquare)) {
          switch(curSquare.squareType) {
          case 0:
            //path
            image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
            break;
          case -1: 
            //wall
            image(curSquare.texture, i*squareSize, j*squareSize, squareSize, squareSize);
            break;
          case -2: 
            //stair down
            fill(150, 0, 0);
            break;
          case -3:
            //stair up
            image(stairTexture, i*squareSize, j*squareSize, squareSize, squareSize);
            //fill(0, 150, 0);
            break;
          case -5: 
            //door
            if (curSquare.isOpen) {
              fill(150, 50, 20, 100);
            } else {
              fill(100, 50, 20);
            }
            break;
          case 1: 
            //?
            fill(255, 100, 100);
            break;
          case 2: 
            //loot
            fill(255, 50, 50);
            break;
          case 3: 
            //mob
            fill(150, 255, 50);
            break;
          }

          //draw the square
          if (curSquare.squareType!=-1 && curSquare.squareType!=0) {
            rect(i*squareSize, j*squareSize, squareSize, squareSize);
          } 
          //darken for light level
          if (player.canSee.contains(curSquare)) {
            fill(0, 0, 10, constrain(curSquare.lightLevel*15, 0, 255));
            rect(i*squareSize, j*squareSize, squareSize, squareSize);
            if (curSquare.containsMob && (player.x!=i || player.y!=j)) {
              fill(255, 100, 0, 180);
              rect(i*squareSize+(squareSize/8), j*squareSize+(squareSize/8), squareSize/1.25, squareSize/1.25);
            }
          } else if (player.hasSeen.contains(curSquare)) {
            fill(0, constrain(curSquare.lightLevel*15, 100, 255));
            rect(i*squareSize, j*squareSize, squareSize, squareSize);
          }

          //draw player
        } else {
          fill(map(curSquare.lightLevel, 0, 15, 15, 0));
          //fill(0);
          rect(i*squareSize, j*squareSize, squareSize, squareSize);
        }
      }
    }

    //fill(255, 200, 200, 10);
    //ellipse(player.x*squareSize+(squareSize/2), player.y*squareSize+(squareSize/2), 2/squareSize, 2/squareSize);
    image(playerTexture, player.x*squareSize, player.y*squareSize, squareSize, squareSize);

    popMatrix();


    //up
    //rect(0, 0, 800, 50);
    ////right
    //rect(750, 0, 50, 800);
    ////down
    //rect(0, 750, 800, 50);
    ////left
    //rect(0, 0, 50, 800);
    //rect(390, 390, 20, 20);

    fill(255, 230, 210, 150);
    rect(810, 10, 180, height-20);

    noStroke();

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
              if (dungeon.floors.get(currentFloor).board[i][j].containsMob) {
                numLoot++;
              }
            }
          }
          player.update();
        }
        fill(0, map(floorAnimationCounter, 30, 90, 255, 0));
        rect(0, 0, width, height);
      }
      floorAnimationCounter++;
      if (floorAnimationCounter == 90) {
        nextFloorAnimation = false;
        floorAnimationCounter = 0;
      }
    }

    fill(255);
    text("Mobs: " + dungeon.floors.get(currentFloor).mobs.size(), width-180, height-120);
    text("Current Floor: " + (currentFloor+1), width-180, height-60);

    if (firstFloorAnimation) {

      numLoot=0;
      for (int i = 0; i<numSquares-1; i++) {
        for (int j = 0; j<numSquares-1; j++) {
          if (dungeon.floors.get(currentFloor).board[i][j].containsMob) {
            numLoot++;
          }
        }
      }
      fill(0, map(floorAnimationCounter, 0, 60, 255, 0));
      rect(0, 0, width, height);
      if (floorAnimationCounter < 15) {
        textSize(100);
        textAlign(CENTER);
        fill(255, map(floorAnimationCounter, 0, 15, 255, 0));
        text("Loading...", 0, height/2-100, width, height/2);
      }
      textSize(20);
      textAlign(LEFT);
      floorAnimationCounter++;
      if (floorAnimationCounter == 60) {
        firstFloorAnimation = false;
        floorAnimationCounter = 0;
      }
    }
  }
}

void startUp() {

  //floors = (int)random(7, 10);
  floors = 10;
  //squares = (int)random(100, 150);
  squares = 50;
  if (squares%2==0) {
    squares--;
  }
  numLoot = 0;

  numSquares = squares;
  squareSize = (height-100)/numSquares;

  currentFloor = 0;

  dungeon = new Dungeon(floors, squares);
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
  player.update();
}

void keyPressed() {
  if (floorAnimationCounter==0) {
    if (moveCooldown==0) {
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
          //moving = 'u';
          player.move('u', true);
          break;
        case 'A': 
          //moving ='l';
          player.move('l', true);
          break;
        case 'S': 
          //moving = 'd';
          player.move('d', true);
          break;
        case 'D': 
          //moving = 'r';
          player.move('r', true);
          break;

        case ENTER: 
          player.openDoor();
          break;
        case 'n': 
          loading = 10;          
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
      moveCooldown = 3;
    }
  }
}


void mousePressed() {

  if (mouseButton == LEFT) {
    player.attack();
    player.openDoor();
  }

  if (mouseButton == RIGHT) {
  }
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