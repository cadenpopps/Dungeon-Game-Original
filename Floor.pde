
import java.util.Stack;

class Floor {

  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;
  ArrayList<Room> rooms;
  ArrayList<Region> regions;
  ArrayList<Square> connectors;
  boolean notVisited;
  boolean showCreation;
  final int roomTries = 500; 
  int maxRoomSize, minRoomSize, roomOffSet;


  //makes a new floor with a location, number of squares, an upStair, and arraylists of rooms, regions, and connectors
  public Floor(int loc, int numSq, PVector stair, boolean delay) {

    //new floor stores floor #, width/height of board, location of the up stair, and an collection of rooms
    floorNum = loc;
    numSquares = numSq;
    stairUp = stair.copy();
    rooms = new ArrayList<Room>();
    regions = new ArrayList<Region>();
    connectors = new ArrayList<Square>();
    showCreation = delay;
    maxRoomSize = (int)numSquares/4;
    minRoomSize = (int)maxRoomSize/4+1;
    roomOffSet = (int)minRoomSize/2+2;

    //generate board, only up stair and downstair rooms
    genBoard();
    //generate rest of dungeon, all rooms and passages
    if (!showCreation) {
      genDungeon();
    }
  }


  //initializes the board, and makes a new downstair
  public void genBoard() {

    //initializes a new board
    squares = new Square[numSquares][numSquares];

    //initializes every square to a wall with a difficulty
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        //needs difficulty (last param)
        squares[i][j] = new Square(i, j, 0, -1);
      }
    }

    //create down stair
    stairDown = new PVector((int)random(4, numSquares-4), (int)random(4, numSquares-4));

    //check if up and down stair too close
    while (abs(stairDown.x-stairUp.x) < numSquares/3 && abs(stairDown.y-stairUp.y) < numSquares/3) {
      stairDown.x = (int)random(4, numSquares-4);
      stairDown.y = (int)random(4, numSquares-4);
    }

    //add 3x3 rooms around stairs
    rooms.add(new Room((int)stairUp.x-(int)random(2, 4), (int)stairUp.y-(int)random(2, 4), (int)stairUp.x+(int)random(2, 4), (int)stairUp.y+(int)random(2, 4), numSquares));
    rooms.add(new Room((int)stairDown.x-(int)random(2, 4), (int)stairDown.y-(int)random(2, 4), (int)stairDown.x+(int)random(2, 4), (int)stairDown.y+(int)random(2, 4), numSquares));

    for (Room r : rooms) {
      r.addChildren(squares);
      regions.add(new Region(r.childSquares));
    }
  }


  //generates board all at once
  public void genDungeon() {

    //generate the rooms of dungeon, no overlap
    genRooms();
    genMaze();
    connectRegions();
    sparseMaze();
    removeDetours();
    removeDetours();
    //removeDetours();

    //makes sure stair locations aren't overwritten
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == 5) {
          squares[i][j].squareType = -1;
        }
      }
    }

    rooms = null;
    regions = null;
    connectors = null;
  }

  //generates board one step at a time
  public void genDungeon(int step) {

    if (step == 0) {
      genRooms();
    } else if (step == 1) {
      genMaze();
    } else if (step == 2) {
      connectRegions();
    } else if (step == 3) {
      sparseMaze();
    } else if (step == 4) {
      removeDetours();
    } else if (step == 5) {
      removeDetours();
    } else if (step == 6) {
      rooms = null;
      regions = null;
      connectors = null;
    }

    //makes sure stair locations aren't overwritten
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;
  }


  //fills in board with rooms
  public void genRooms() {

    //tries to place a room _roomTries times
    for (int i = 0; i < roomTries; i++) {

      //random top left corner location between 2 and width-2
      int rx1 = (int)random(2, numSquares-5); 
      int ry1 = (int)random(2, numSquares - 5);

      //makes room size
      int size = (int)random(minRoomSize, maxRoomSize);
      //set rx2 and ry2 to size and one randomly gets offset to make rectangle rooms
      int rx2, ry2;
      if (random(1)>=.5) {
        rx2 = rx1+size+(int)random(1, roomOffSet);
        ry2 = ry1+size;
      } else {
        rx2 = rx1+size;
        ry2 = ry1+size+(int)random(1, roomOffSet);
      }

      //create new room
      Room newRoom = new Room(rx1, ry1, rx2, ry2, numSquares);

      //boolean for overlapping, CAN BE MORE EFFICIENT?
      boolean overlaps = false;

      for (Room r : rooms) {
        if (r.overlaps(newRoom, numSquares)) {
          overlaps = true;
          r = null;
          break;
        }
      }


      //if it doens't overlap, actually add new room
      if (!overlaps) {
        rooms.add(newRoom);
        newRoom.addChildren(squares);
        regions.add(new Region(newRoom.childSquares));
      }
    }
    //add all rooms to the board
    for (Room r : rooms) {
      r.makeRoom(squares);
    }
  }


  //fill in blank squares with a "perfect" maze
  public void genMaze() {

    PVector cur = new PVector(0, 0);
    Stack moveStack = new Stack();
    notVisited = true;

    squares[(int)cur.x][(int)cur.y].squareType = 0;
    for (int x = 0; x<numSquares; x++) {
      for (int y = 0; y<numSquares; y++) {
        if (x%2==1 || y%2==1) {
          if (x>0 && y>0 && squares[x][y].squareType == -1 && squares[x][y].neighbors(squares, numSquares)<2 && squares[x-1][y].squareType == -1 && squares[x][y-1].squareType == -1) {
            ArrayList<Square> temp = new ArrayList<Square>();
            cur.x = x;
            cur.y = y;
            while (notVisited) {

              squares[(int)cur.x][(int)cur.y].squareType = 0;
              temp.add(squares[(int)cur.x][(int)cur.y]);
              ArrayList<PVector> moves = squares[(int)cur.x][(int)cur.y].moves(squares, numSquares);
              if (!moves.isEmpty()) {
                moveStack.push(cur);
                //int randomMove = (int)random(0, moves.size());
                int randomMove = (int)map(random(1), 0, 1, 0, moves.size());
                cur = moves.get(randomMove).copy();
              } else if (!moveStack.isEmpty()) {
                cur = (PVector)moveStack.peek();
                moveStack.pop();
              } else {
                break;
              }

              notVisited = false;
              for (int i = 0; i<numSquares; i++) {
                for (int j = 0; j<numSquares; j++) {
                  if (i%2==1 || j%2==1) {
                    if (squares[i][j].squareType == -1) {
                      notVisited = true;
                    }
                  }
                }
              }
            }
            regions.add(new Region(temp));
          }
        }
      }
    }
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == -1 && squares[i][j].pathNeighbors(squares, numSquares) == 2) {
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i-1][j].squareType==-1 && squares[i-2][j].squareType==0 && squares[i-2][j].region == squares[i][j].region) && random(1)<.01) {
            squares[i-1][j].squareType = 0;
            squares[i-1][j].region = squares[i][j].region;
          } 
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i+1][j].squareType==-1 && squares[i+2][j].squareType==0 && squares[i+2][j].region == squares[i][j].region) && random(1)<.01) {
            squares[i+1][j].squareType = 0;
            squares[i+1][j].region = squares[i][j].region;
          }
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i][j-1].squareType==-1 && squares[i][j-2].squareType==0 && squares[i][j-2].region == squares[i][j].region) && random(1)<.01) {
            squares[i][j-1].squareType = 0;
            squares[i][j-1].region = squares[i][j].region;
          } 
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i][j+1].squareType==-1 && squares[i][j+2].squareType==0 && squares[i][j+2].region == squares[i][j].region) && random(1)<.01) {
            squares[i][j+1].squareType = 0;
            squares[i][j+1].region = squares[i][j].region;
          }
        }
      }
    }
  }


  //connects all regions with a door
  public void connectRegions() {

    regions.get(0).connect();

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == -1 && squares[i][j].connector(regions)) {
          connectors.add(squares[i][j]);
        }
      }
    }

    boolean allConnected = false;

    while (!allConnected) {
      for (Region r : regions) {
        if (r.connected) {
          if (!connectors.isEmpty()) {
            int temp = (int) random(connectors.size());
            connectors.get(temp).squareType = -5;
            //r.connect();
            for (Region u : regions) {
              if (connectors.get(temp).adjacentTo(u)) {
                u.connect();
              }
            }
          }
          break;
        }
      }

      connectors = new ArrayList<Square>();
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].squareType == -1 && squares[i][j].connector(regions)) {
            connectors.add(squares[i][j]);
          }
        }
      }

      allConnected = true;
      for (Region r : regions) {
        if (!r.connected) {
          allConnected = false;
        }
      }
    }

    for (Region r : regions) {
      for (Square s : r.children) {
        s.region = r;
      }
    }
  }


  //removes most dead ends
  public void sparseMaze() {

    boolean deadends = true;

    while (deadends) {

      //remove all deadends (tile with 3 walls
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].deadend) {
            squares[i][j].deadend = false;
            squares[i][j].squareType = -1;
          }
        }
      }

      //find new deadends with a 1% chance to ignore one
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].squareType == 0 && squares[i][j].neighbors(squares, numSquares) < 2 && random(1)<.98) {
            squares[i][j].deadend = true;
          }
        }
      }

      //check if there are any deadends left
      deadends = false;
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].squareType == 0 && squares[i][j].deadend) {
            deadends = true;
          }
        }
      }
    }

    //delete doors that lead to nothing
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == -5 && squares[i][j].neighbors(squares, numSquares)<2) {
          squares[i][j].squareType = -1;
        }
      }
    }
  }


  //removes 3x3 detours and calls sparseMaze again
  public void removeDetours() {
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == -1 && squares[i][j].pathNeighbors(squares, numSquares) == 3 && squares[i][j].diagNeighbors(squares, numSquares)==4) {
          squares[i][j].squareType = 5;
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i-1][j].squareType==-1 || squares[i-1][j].squareType ==5)) {
            squares[i-1][j].squareType = 0;
            squares[i-1][j].region = squares[i][j].region;

            squares[i+1][j].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i+1][j].squareType==-1 || squares[i+1][j].squareType ==5)) {
            squares[i+1][j].squareType = 0;
            squares[i+1][j].region = squares[i][j].region;

            squares[i-1][j].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i][j-1].squareType==-1 || squares[i][j-1].squareType ==5)) {
            squares[i][j-1].squareType = 0;
            squares[i][j-1].region = squares[i][j].region;

            squares[i][j+1].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (squares[i][j+1].squareType==-1 || squares[i][j+1].squareType ==5)) {
            squares[i][j+1].squareType = 0;
            squares[i][j+1].region = squares[i][j].region;

            squares[i][j-1].squareType = -1;
          }
          sparseMaze();
        } else if (squares[i][j].squareType == 5) {
          squares[i][j].squareType = -1;
        }
      }
    }
  }
}