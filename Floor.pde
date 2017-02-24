
import java.util.Stack;

class Floor {

  int floorNum, numSquares;
  Square[][] squares;
  PVector stairDown, stairUp;
  ArrayList<Room> rooms;
  ArrayList<Region> regions;
  ArrayList<Square> connectors;
  boolean notVisited = true;
  final int roomTries = 300, maxRoomSize = 9, minRoomSize = 4, roomOffSet = 3;

  public Floor(int loc, int numSq, PVector stair) {

    //new floor stores floor #, width/height of board, location of the up stair, and an collection of rooms
    floorNum = loc;
    numSquares = numSq;
    stairUp = stair.copy();
    rooms = new ArrayList<Room>();
    regions = new ArrayList<Region>();
    connectors = new ArrayList<Square>();

    //generate board, only up stair and downstair rooms
    genBoard();
    //generate rest of dungeon, all rooms and passages
    //genDungeon();
    //makes sure stair locations aren't overwritten
    squares[(int)stairUp.x][(int)stairUp.y].squareType = -3;
    squares[(int)stairDown.x][(int)stairDown.y].squareType = -2;
  }

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
    while (abs(stairDown.x-stairUp.x) < 10 && abs(stairDown.y-stairUp.y) < 10) {
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

  public void genDungeon(int step) {

    //generate the rooms of dungeon, no overlap
    if (step ==0)
      genRooms();
    //fill in rest of spaces with maze
    if (step ==1)
      genMaze();
    //connect regions
    if (step ==2)
      connectRegions();
    //make maze sparse
    if (step ==3)
      sparseMaze();
    //populate?
  }

  public void genRooms() {

    //tries to place a room _roomTries times
    for (int i = 0; i < roomTries; i++) {

      //random top left corner location between 2 and width-2
      int rx1 = (int)random(1, numSquares-3); 
      int ry1 = (int)random(1, numSquares - 3);

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
        if (r.overlaps(newRoom)) {
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

  public void genMaze() {
    //generate maze :)

    PVector cur = new PVector(0, 0);
    Stack moveStack = new Stack();

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
        if (i==numSquares-1 || j==numSquares-1 || i==0 || j==0) {
          //squares[i][j].squareType = -1;
        }
      }
    }
    /*for (int i = 1; i<numSquares-1; i++) {
     for (int j = 1; j<numSquares-1; j++) {
     if (squares[i][j].squareType ==0 && squares[i][j].neighbors(squares, numSquares)==2 && random(1)<.005) {
     //squares[i][j].squareType = -1;
     }
     }
     }*/
  }

  public void connectRegions() {

    for (int i = 0; i<numSquares; i++) {
      for (int j = 0; j<numSquares; j++) {
        if (squares[i][j].squareType == -1 && squares[i][j].connector(squares, regions, numSquares)) {
          connectors.add(squares[i][j]);
          squares[i][j].squareType = 5;
        }
      }
    }

    boolean allConnected = false;
    ArrayList<Square> curSquare;

    while (!allConnected) {
      for (Region r : regions) {
        if (!r.connected) {
          ArrayList<Square> adjacent = new ArrayList<Square>();
          curSquare = new ArrayList<Square>();
          for (Square c : connectors) {
            
            if (c.adjacentTo(r) && !r.connected) {
              
              adjacent.add(c);
              curSquare.add(c);
            }
          }
          if (!adjacent.isEmpty()) {
            connectors.remove(curSquare);
            int temp = (int) random(adjacent.size());
            adjacent.get(temp).squareType = -5;
            adjacent.get(temp).region = r;
            r.connect();
            for (Square s : connectors) {
              if (s.adjacentTo(r)) {
                connectors.remove(s);
              }
            }
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
  }

  public void sparseMaze() {

    boolean deadends = true;

    while (deadends) {

      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].deadend) {
            squares[i][j].deadend = false;
            squares[i][j].squareType = -1;
          }
        }
      }

      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].squareType == 0 && squares[i][j].neighbors(squares, numSquares) < 2 && random(1)<.99) {
            squares[i][j].deadend = true;
          }
        }
      }

      deadends = false;
      for (int i = 0; i<numSquares; i++) {
        for (int j = 0; j<numSquares; j++) {
          if (squares[i][j].squareType == 0 && squares[i][j].deadend) {
            deadends = true;
          }
        }
      }
    }
  }
}