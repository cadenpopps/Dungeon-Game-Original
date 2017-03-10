var dungeon;
var currentFloor,
   numSquares,
   squareSize,
   numFloors,
   numSquares,
   counter,
   floorAnimationCounter,
   loading,
   nextFloorAnimation,
   firstFloorAnimation,
   moving;
var player;
var wallTextures;
var floorTextures;
var playerTexture;
var stairUpTexture;
var stairDownTexture;
const LOOT = 2;
const WALL = -1;
const PATH = 0;
const STAIRDOWN = -2;
const STAIRUP = -3;
const DOOR = -5;
const RANGE = 40;
//preload image assets
function preload() {
   wallTextures = [];
   //wallTextures.push(loadImage( "data/wallTexture0.jpg" ));
   floorTextures = [];
   //floorTextures.push(loadImage( "data/floorTexture0.jpg" ));
   //playerTexture = loadImage( "data/playerTexture.png" );
   //stairUpTexture = loadImage( "data/stairUpTexture.png" );
   //stairDownTexture = p5.Image;
}

function setup() {
   createCanvas(windowWidth, windowHeight);
   currentFloor = 0;
   numSquares = 0;
   squareSize = 0;
   numFloors = 0;
   numSquares = 0;
   floorAnimationCounter = 0;
   nextFloorAnimation = false;
   firstFloorAnimation = false;
   player = null;
   moving = ' ';
   loading = 0;
   frameRate(60);
   // textSize(30);
   noStroke();
   //stroke(255);
   load();
   //newDungeon();
}

function draw() {
   if (loading >= 2) {
      textSize(100);
      textAlign(CENTER);
      fill(0);
      rect(0, 0, width, height);
      fill(255);
      text("Loading World...", 0, height / 5, width, height / 5);
      loading--;
   }
   if (loading == 1) {
      fill(0);
      rect(0, 0, width, height);
      fill(255);
      text("Loading World...", 0, height / 5, width, height / 5);
      textAlign(LEFT);
      textSize(20);
      noLoop();
      loading--;
      newDungeon();
      //firstFloorAnimation = true;
   }
   if (loading == 0) {
      background(0);
      push();
      //var s = floor((numSquares) / 15);
      scale(2);
      translate(floor((-player.x * squareSize) + (width / 4) - (squareSize / 2)), floor((-player.y * squareSize) + (height / 4) - squareSize / 2));
      for (var i = player.x - RANGE; i < player.x + RANGE; i++) {
         for (var j = player.y - RANGE; j < player.y + RANGE; j++) {
            //current square
            if (i >= 0 && j >= 0 && i <= this.numSquares - 1 && j <= this.numSquares - 1) {
               var curSquare = dungeon.floors[currentFloor].board[i][j];
               if (player.canSee.indexOf(curSquare) != -1 || player.hasSeen.indexOf(curSquare) != -1) {
                  switch (curSquare.squareType) {
                     case 0:
                        //path
                        fill(255);
                        //floor(rect(i * squareSize, j * squareSize, squareSize, squareSize);
                        //image( curSquare.texture, i * squareSize, j * squareSize, squareSize, squareSize );
                        break;
                     case -1:
                        //wall
                        fill(50);
                        //rect(i * squareSize, j * squareSize, squareSize, squareSize);
                        //image( curSquare.texture, i * squareSize, j * squareSize, squareSize, squareSize );
                        break;
                     case -2:
                        //stair down
                        fill(150, 0, 0);
                        break;
                     case -3:
                        //stair up
                        fill(0, 150, 0);
                        //image( stairTexture, i * squareSize, j * squareSize, squareSize, squareSize );
                        break;
                     case -5:
                        //door
                        if (curSquare.isOpen) {
                           fill(150, 50, 20, 100);
                        }
                        else {
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
                  //if (curSquare.squareType != -1 && curSquare.squareType !== 0) {
                  rect(i * squareSize, j * squareSize, squareSize, squareSize);
                  //}
                  //darken for light level
                  if (player.canSee.indexOf(curSquare) != -1) {
                     fill(0, 0, 10, ((curSquare.lightLevel * 5)));
                     rect(i * squareSize, j * squareSize, squareSize, squareSize);
                     if (curSquare.containsMob && (player.x != i || player.y != j)) {
                        fill(255, 100, 0, 180);
                        rect(i * squareSize + (squareSize / 8), j * squareSize + (squareSize / 8), squareSize / 1.25, squareSize / 1.25);
                     }
                  }
                  else if (player.hasSeen.indexOf(curSquare) != -1) {
                     fill(0, constrain(curSquare.lightLevel * 5, 100, 255));
                     rect(i * squareSize, j * squareSize, squareSize, squareSize);
                  }
                  //draw player
                  // } else {
                  //   fill(map(curSquare.lightLevel, 0, 10, 30, 0));
                  //   rect(i*squareSize, j*squareSize, squareSize, squareSize);
               }
            }
         }
      }
      fill(0, 200);
      //ellipse(player.x*squareSize+(squareSize/2), player.y*squareSize+(squareSize/2), 2/squareSize, 2/squareSize);
      //image( playerTexture, player.x * squareSize, player.y * squareSize, squareSize, squareSize );
      rect(player.x * squareSize + 2, player.y * squareSize + 2, squareSize - 4, squareSize - 4);
      pop();
      //fill(255, 0, 0);
      //rect(width / 2 - 20, height / 2 - 20, 40, 40);
      //up
      //rect(0, 0, 800, 50);
      ////right
      //rect(750, 0, 50, 800);
      ////down
      //rect(0, 750, 800, 50);
      ////left
      //rect(0, 0, 50, 800);
      //rect(390, 390, 20, 20);
      fill(255, 150);
      rect(width - 260, 10, 250, height - 20);
      rect(10, 10, 250, height - 20);
      fill(255);
      //text( "Mobs: " + dungeon.floors.get( currentFloor ).mobs.size( ), width - 180, height - 120 );
      text("Current Floor: " + (currentFloor + 1), width - 320, height - 50);
   }
}

function newDungeon() {
   //floors = (int)random(7, 10);
   numFloors = 3;
   numSquares = parseInt(random(30, 40));
   //numSquares = 30;
   //make numSquares odd
   if (numSquares % 2 === 0) {
      numSquares--;
   }
   //calc new squareSize
   squareSize = floor((height - 100) / RANGE);
   //reset currentFloor
   currentFloor = 0;
   //make a new dungeon
   dungeon = new Dungeon(numFloors, numSquares);
   player = new Player(dungeon.floors[0].stairUp.x, dungeon.floors[0].stairUp.y);
   for (let f of dungeon.floors) {
      // if (f.floorNum < f.numFloors - 1 && !findPath(dungeon.floors.get(f.floorNum).stairDown, dungeon.floors.get(f.floorNum).stairUp, dungeon.floors.get(f.floorNum).board)) {
      //     startUp();
      // }
      if (f.floorNum < numFloors - 1) {
         while (!player.findPath(f.floorNum, f.stairUp, f.stairDown)) {
            console.log("\n\n\n\nnew dungeon");
            //newDungeon();
         }
      }
      for (var i = 0; i < numSquares; i++) {
         for (var j = 0; j < numSquares; j++) {
            if (dungeon.floors[f.floorNum].board[i][j].squareType == -1) {
               dungeon.floors[f.floorNum].board[i][j].texture = wallTextures[(floor(random(wallTextures.length)))];
            }
            if (dungeon.floors[f.floorNum].board[i][j].squareType === 0) {
               dungeon.floors[f.floorNum].board[i][j].texture = floorTextures[(floor(random(floorTextures.length)))];
            }
         }
      }
   }
   player.update();
}

function load() {
   loading = 4;
   loop();
}

function keyTyped() {
   if (key === 'n') {
      load();
   }
   if (floorAnimationCounter === 0) {
      switch (key) {
         case 'w':
            player.move('u');
            break;
         case 'a':
            player.move('l');
            break;
         case 's':
            player.move('d');
            break;
         case 'd':
            player.move('r');
            break;
         case 'W':
            //moving = 'u';
            player.move('u');
            break;
         case 'A':
            //moving ='l';
            player.move('l');
            break;
         case 'S':
            //moving = 'd';
            player.move('d');
            break;
         case 'D':
            //moving = 'r';
            player.move('r');
            break;
         case ENTER:
            player.openDoor();
            break;
         case 'n':
            load();
            break;
      }
      switch (keyCode) {
         case UP_ARROW:
            player.move('u');
            break;
         case RIGHT_ARROW:
            player.move('r');
            break;
         case DOWN_ARROW:
            player.move('d');
            break;
         case LEFT_ARROW:
            player.move('l');
            break;
      }
   }
}

function mousePressed() {
   player.openDoor();
   player.attack();
}

function windowResized() {
   resizeCanvas(windowWidth, windowHeight);
   redraw();
}
