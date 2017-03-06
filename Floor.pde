
import java.util.Stack;

class Floor {

  int floorNum, numSquares, numFloors;
  Square[][] board;
  PVector stairDown, stairUp;
  ArrayList<Room> rooms;
  ArrayList<Region> regions;
  ArrayList<Square> connectors;
  boolean notVisited;
  int roomTries, maxRoomSize, minRoomSize, roomOffSet;
  ArrayList<Mob> mobs;
  final int mobCap;


  //makes a new floor with a location, number of squares, an upStair, and arraylists of rooms, regions, and connectors
  public Floor(int _floorNum, int _numSquares, int _numFloors, PVector _stairUp) {

    //new floor stores floor #, width/height of board, location of the up stair, and a collection of rooms
    floorNum = _floorNum;
    numSquares = _numSquares;
    numFloors = _numFloors;
    stairUp = _stairUp.copy();
    rooms = new ArrayList<Room>();
    regions = new ArrayList<Region>();
    connectors = new ArrayList<Square>();
    mobs = new ArrayList<Mob>();
    roomTries = numSquares*20;
    maxRoomSize = 13;
    minRoomSize = (int)maxRoomSize/4+1;
    roomOffSet = (int)minRoomSize/2+2;
    mobCap = 10+(floorNum*2);

    //generate board, only up stair and downstair rooms
    genBoard();
    //generate rest of dungeon, all rooms and passages
    genDungeon();
  }


  //initializes the board, and makes a new downstair
  public void genBoard() {

    //initializes a new board
    board = new Square[numSquares][numSquares];

    //initializes every square to a wall with a difficulty
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        //needs difficulty (last param)
        board[i][j] = new Square(i, j, 0, -1);
      }
    }
  }


  //generates board all at once
  public void genDungeon() {

    //generate the rooms of dungeon, no overlap
    genStairs();
    genRooms();
    genMaze();
    connectRegions();
    sparseMaze();
    for (int i = 0; i<(int)numSquares/20+1; i++) {
      removeDetours();
    }
    populate();

    //makes sure stair locations aren't overwritten
    board[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    if (floorNum<numFloors-1) {
      board[(int)stairDown.x][(int)stairDown.y].squareType = -2;
    }

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == 5) {
          board[i][j].squareType = -1;
        }
      }
    }

    rooms = null;
    regions = null;
    connectors = null;
  }

  //generate stairs and stair rooms
  public void genStairs() {

    //create down stair
    if (floorNum < numFloors-1) {
      stairDown = new PVector((int)random(4, numSquares-4), (int)random(4, numSquares-4));

      //check if up and down stair too close
      while (abs(stairDown.x-stairUp.x) < numSquares/3 && abs(stairDown.y-stairUp.y) < numSquares/3) {
        stairDown.x = (int)random(4, numSquares-4);
        stairDown.y = (int)random(4, numSquares-4);
      }
      rooms.add(new Room((int)stairDown.x-(int)random(2, 4), (int)stairDown.y-(int)random(2, 4), (int)stairDown.x+(int)random(2, 4), (int)stairDown.y+(int)random(2, 4), numSquares));
    }

    //add 3x3 rooms around stairs
    rooms.add(new Room((int)stairUp.x-(int)random(2, 4), (int)stairUp.y-(int)random(2, 4), (int)stairUp.x+(int)random(2, 4), (int)stairUp.y+(int)random(2, 4), numSquares));

    for (Room r : rooms) {
      r.addChildren(board);
      regions.add(new Region(r.childSquares));
      r.roomType = -1;
    }
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
      for (int i = 0; i<(int)numSquares/20+1; i++) {
        removeDetours();
      }
    } else if (step == 6) {
      populate();
    } else if (step == 7) {
      rooms = null;
      regions = null;
      connectors = null;
    }

    //makes sure stair locations aren't overwritten
    board[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    board[(int)stairDown.x][(int)stairDown.y].squareType = -2;
  }


  //fills in board with rooms
  public void genRooms() {

    //tries to place a room _roomTries times
    for (int i = 0; i < roomTries; i++) {

      //random top left corner location between 2 and width-2
      int rx1 = (int)random(0, numSquares-3); 
      int ry1 = (int)random(0, numSquares-3);

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
      boolean notRoom = false;

      if (newRoom.notRoom()) {
        notRoom = true;
      }

      for (Room r : rooms) {
        if (newRoom.overlaps(r)) {
          notRoom = true;
          r = null;
          break;
        }
      }


      //if it doens't overlap, actually add new room
      if (!notRoom) {
        rooms.add(newRoom);
        newRoom.addChildren(board);
        regions.add(new Region(newRoom.childSquares));
      }
    }
    //add all rooms to the board
    for (Room r : rooms) {
      r.makeRoom(board);
    }
  }


  //fill in blank squares with a "perfect" maze
  public void genMaze() {

    PVector cur = new PVector(0, 0);
    Stack moveStack = new Stack();
    notVisited = true;

    board[(int)cur.x][(int)cur.y].squareType = 0;
    for (int x = 0; x<numSquares; x++) {
      for (int y = 0; y<numSquares; y++) {
        if (x%2==1 || y%2==1) {
          if (x>0 && y>0 && board[x][y].squareType == -1 && board[x][y].numNeighbors(board)<2 && board[x-1][y].squareType == -1 && board[x][y-1].squareType == -1) {
            ArrayList<Square> temp = new ArrayList<Square>();
            cur.x = x;
            cur.y = y;
            while (notVisited) {

              board[(int)cur.x][(int)cur.y].squareType = 0;
              temp.add(board[(int)cur.x][(int)cur.y]);
              ArrayList<PVector> moves = board[(int)cur.x][(int)cur.y].moves(board);
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
                    if (board[i][j].squareType == -1) {
                      notVisited = true;
                    }
                  }
                }
              }
            }
            Region r = new Region(temp);
            r.path = true;
            regions.add(r);
          }
        }
      }
    }
    for (Region r : regions) {
      for (Square s : r.children) {
        s.region = r;
      }
    }
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == 0 && board[i][j].pathNeighbors(board, numSquares) == 2) {
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i-1][j].squareType==-1 && board[i-2][j].squareType==0 && board[i-2][j].region == board[i][j].region) && random(1)<.02) {
            board[i-1][j].squareType = 0;
            board[i-1][j].region = board[i][j].region;
          } 
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i+1][j].squareType==-1 && board[i+2][j].squareType==0 && board[i+2][j].region == board[i][j].region) && random(1)<.02) {
            board[i+1][j].squareType = 0;
            board[i+1][j].region = board[i][j].region;
          }
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i][j-1].squareType==-1 && board[i][j-2].squareType==0 && board[i][j-2].region == board[i][j].region) && random(1)<.02) {
            board[i][j-1].squareType = 0;
            board[i][j-1].region = board[i][j].region;
          } 
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i][j+1].squareType==-1 && board[i][j+2].squareType==0 && board[i][j+2].region == board[i][j].region) && random(1)<.02) {
            board[i][j+1].squareType = 0;
            board[i][j+1].region = board[i][j].region;
          }
        }
      }
    }
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == -1 && board[i][j].pathNeighbors(board, numSquares) == 2) {
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i-1][j].squareType==0 && board[i+1][j].squareType==0 && board[i-1][j].region == board[i+1][j].region) && random(1)<.02) {
            board[i][j].squareType = 0;
            board[i][j].region = board[i][j].region;
          } 
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i][j-1].squareType==0 && board[i][j+1].squareType==0 && board[i][j-1].region == board[i][j+1].region) && random(1)<.02) {
            board[i][j].squareType = 0;
            board[i][j].region = board[i][j].region;
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
        if (board[i][j].squareType == -1 && board[i][j].connector(regions)) {
          connectors.add(board[i][j]);
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
            for (Region u : regions) {
              if (connectors.get(temp).adjacentTo(u) && random(1)<.90) {
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
          if (board[i][j].squareType == -1 && board[i][j].connector(regions)) {
            connectors.add(board[i][j]);
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
          if (board[i][j].deadend) {
            board[i][j].deadend = false;
            board[i][j].squareType = -1;
          }
        }
      }

      //find new deadends with a 3% chance to ignore one
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (board[i][j].squareType == 0 && board[i][j].numNeighbors(board) < 2 && random(1)<.97) {
            board[i][j].deadend = true;
          }
        }
      }

      //check if there are any deadends left
      deadends = false;
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (board[i][j].squareType == 0 && board[i][j].deadend) {
            deadends = true;
          }
        }
      }
    }

    //delete doors that lead to nothing
    //for (int i = 0; i<numSquares; i++) {
    //  for (int j = 0; j<numSquares; j++) {
    //    if (board[i][j].squareType == -5 && board[i][j].numNeighbors(board)<2) {
    //      board[i][j].squareType = -1;
    //    }
    //    if (board[i][j].squareType == -5 && random(1)<.1) {
    //      board[i][j].squareType = 0;
    //    }
    //  }
    //}
  }


  //removes 3x3 detours and calls sparseMaze again
  public void removeDetours() {
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == -1 && board[i][j].pathNeighbors(board, numSquares) == 3 && board[i][j].diagNeighbors(board, numSquares)==4) {
          board[i][j].squareType = 5;
          if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i-1][j].squareType==-1 || board[i-1][j].squareType ==5)) {
            board[i-1][j].squareType = 0;
            board[i-1][j].region = board[i][j].region;

            board[i+1][j].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i+1][j].squareType==-1 || board[i+1][j].squareType ==5)) {
            board[i+1][j].squareType = 0;
            board[i+1][j].region = board[i][j].region;

            board[i-1][j].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i][j-1].squareType==-1 || board[i][j-1].squareType ==5)) {
            board[i][j-1].squareType = 0;
            board[i][j-1].region = board[i][j].region;

            board[i][j+1].squareType = -1;
          } else if (i>1 && j>1 && i<numSquares-2 && j<numSquares-2 && (board[i][j+1].squareType==-1 || board[i][j+1].squareType ==5)) {
            board[i][j+1].squareType = 0;
            board[i][j+1].region = board[i][j].region;

            board[i][j-1].squareType = -1;
          }
        } else if (board[i][j].squareType == 5) {
          board[i][j].squareType = -1;
        }
      }
    }
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == -1 && board[i][j].pathNeighbors(board, numSquares) == 4 && board[i][j].diagNeighbors(board, numSquares)==4 && random(1)<.8) {
          ArrayList<Square> n = board[i][j].neighbors(board);
          int temp = (int)random(0, n.size());
          n.get(temp).squareType=-1;
        }
      }
    }
    sparseMaze();
  }

  public void populate() {
    int lootMax, mobMax;
    //int numLoot, numMobs;
    for (Room r : rooms) {
      if (r.roomType == -1) {
        continue;
      }
      lootMax = constrain((int)random(floorNum+2), 0, r.rwidth/3);
      mobMax = constrain((int)random(floorNum+2), 0, r.rwidth/3);
      //numLoot = 0;
      //numMobs = 0;

      for (int a = 0; a<lootMax; a++) {
        Square randomSquare = r.childSquares.get((int)random(r.childSquares.size()-1));
        while (!(randomSquare.locX==r.x1 || randomSquare.locY==r.y1 || randomSquare.locX==r.x2 || randomSquare.locY==r.y2)) {
          randomSquare = r.childSquares.get((int)random(r.childSquares.size()-1));
        }
        boolean create = true;
        for (int i = randomSquare.locX-1; i<= randomSquare.locX+1; i++) {
          for (int j = randomSquare.locY-1; j<=randomSquare.locY+1; j++) {
            if (board[i][j].squareType==-5) {
              create = false;
            }
          }
        }
        if (create) {
          randomSquare.squareType = 2;
        }
      }

      for (int a = 0; a<mobMax; a++) {
        Square randomSquare = r.childSquares.get((int)random(r.childSquares.size()-1));
        boolean create = true;
        for (int i = randomSquare.locX-1; i<= randomSquare.locX+1; i++) {
          for (int j = randomSquare.locY-1; j<=randomSquare.locY+1; j++) {
            if (board[i][j].squareType==-5) {
              create = false;
            }
          }
        }
        if (create) {
          mobs.add(new Mob(randomSquare.locX, randomSquare.locY));
          randomSquare.containsMob = true;
        }
      }
    }

    //delete doors that lead to nothing
    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (board[i][j].squareType == -5 && board[i][j].numNeighbors(board)<2) {
          board[i][j].squareType = -1;
        }
        if (board[i][j].squareType == -5 && random(1)<.15) {
          board[i][j].squareType = 0;
        }
        if (board[i][j].squareType == -1 && board[i][j].pathNeighbors(board, numSquares)>2) {
          board[i][j].squareType = 0;
        }
        if (board[i][j].squareType == -5) {
          for (int a = i-1; a<=i+1; a++) {
            for (int b = j-1; b<=j+1; b++) {
              if (a>0 && b>0 && a<numSquares-1 && b<numSquares-1 && (a!=i || b!=j)) {
                if (board[a][b].squareType == -5 && random(1)<.9) {
                  board[a][b].squareType = -1;
                }
              }
            }
          }
        }
      }
    }
  }
}