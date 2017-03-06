function Floor( _floorNum, _numSquares, _numFloors, _stairUp ) {

    this.floorNum = _floorNum;
    this.numSquares = _numSquares;
    this.numFloors = _numFloors;
    this.stairUp = _stairUp;
    this.rooms = [ ];
    this.regions = [ ];
    this.connectors = [ ];
    this.mobs = [ ];
    this.roomTries = numSquares*10;
    this.maxRoomSize = 13;
    this.minRoomSize = floor( this.maxRoomSize / 4 ) + 1;
    this.roomOffSet = floor( this.minRoomSize / 2 ) + 2;
    this.mobCap = 10 + ( this.floorNum * 2 );

    //generates floor, called after floor is created by parent dungeon
    this.buildFloor = function( ) {
        this.genBoard( );
        this.genDungeon( );
    }

    //generate board, fill with empty squares
    this.genBoard = function( ) {

        this.board = new Array( numSquares );
        for ( var i = 0; i < numSquares; i++ ) {
            this.board[i] = new Array( numSquares );
            for ( var j = 0; j < numSquares; j++ ) {
                this.board[i][j ] = new Square( i, j, this.floorNum, -1 );
            }
        }
    }

    //generate rest of dungeon
    this.genDungeon = function( ) {

        this.genStairs( );
        this.genRooms( );
        this.genMaze( );
        this.connectRegions( );
        this.sparseMaze( );
        // for ( var i = 0; i < floor( numSquares / 20 + 1 ); i++ ) {
        //     removeDetours( );
        // }
        // populate( );
        //
        // //makes sure stair locations aren't overwritten
        // this.board[stairUp.x][stairUp.y ].squareType = -3;
        // if ( this.floorNum < this.numFloors - 1 ) {
        //     this.board[stairDown.x][stairDown.y ].squareType = -2;
        // }
        //
        // for ( var i = 0; i < this.numSquares; i++ ) {
        //     for ( var j = 0; j < this.numSquares; j++ ) {
        //         if ( this.board[i][j ].squareType == 5) {
        //             this.board[i][j ].squareType = -1;
        //         }
        //     }
        // }
        //
        // rooms = null;
        // regions = null;
        // connectors = null;
    }

    //generate stairs and stair rooms
    this.genStairs = function( ) {

        //create down stair
        if ( this.floorNum < this.numFloors - 1 ) {
            this.stairDown = createVector(floor(random( 4, this.numSquares - 4 )), floor(random( 4, this.numSquares - 4 )));

            //check if up and down stair too close
            while ( abs( this.stairDown.x - this.stairUp.x ) < this.numSquares / 3 && abs( this.stairDown.y - this.stairUp.y ) < this.numSquares / 3 ) {
                this.stairDown.x = floor(random( 4, this.numSquares - 4 ));
                this.stairDown.y = floor(random( 4, this.numSquares - 4 ));
            }
            this.rooms.push(new Room(this.stairDown.x - floor(random( 2, 4 )), this.stairDown.y - floor(random( 2, 4 )), this.stairDown.x + floor(random( 2, 4 )), this.stairDown.y + floor( random( 2, 4 ), this.numSquares )));
        }

        //add 3x3 rooms around stairs
        this.rooms.push(new Room( this.stairUp.x - floor(random( 2, 4 )), this.stairUp.y - floor(random( 2, 4 )), this.stairUp.x + floor(random( 2, 4 )), this.stairUp.y + floor(random( 2, 4 )), this.numSquares ));

        for ( let r of this.rooms ) {
            r.addChildren( this.board );
            //this.regions.push(new Region( r.childSquares ));
            r.roomType = -1;
        }
    }

    //generate rooms, non overlapping
    this.genRooms = function() {

      //tries to place a room _roomTries times
      for (var i = 0; i < this.roomTries; i++) {

        //random top left corner location between 2 and width-2
        var rx1 = floor(random(0, numSquares-3));
        var ry1 = floor(random(0, numSquares-3));

        //makes room size
        var size = floor(random(this.minRoomSize, this.maxRoomSize));
        //set rx2 and ry2 to size and one randomly gets offset to make rectangle rooms
        var rx2, ry2;
        if (random(1)>=.5) {
          rx2 = rx1+size+floor(random(1, this.roomOffSet));
          ry2 = ry1+size;
        } else {
          rx2 = rx1+size;
          ry2 = ry1+size+floor(random(1, this.roomOffSet));
        }

        //create new room
        var newRoom = new Room(rx1, ry1, rx2, ry2, this.numSquares);

        //boolean for overlapping
        var overlaps = false;

        //if too small
        if(newRoom.notRoom()){
          overlaps = true;
        }

        for (let r of this.rooms) {
          if (newRoom.overlaps(r)) {
            overlaps = true;
            r = null;
            break;
          }
        }


        //if it doens't overlap, actually add new room
        if (!overlaps) {
          this.rooms.push(newRoom);
          newRoom.addChildren(this.board);
          this.regions.push(new Region(newRoom.childSquares));
        }
      }
      //add all rooms to the board
      for (let r of this.rooms) {
        r.makeRoom(this.board);
      }
    }

    //generate perfect maze to fill rest of squares
    this.genMaze = function(){

        var cur = createVector(0, 0);
        var moveStack = [];
        var notVisited = true;

        //this.board[cur.x][cur.y].squareType = 0;
        for (var x = 0; x<this.numSquares; x++) {
          for (var y = 0; y<this.numSquares; y++) {
            if (x%2==1 || y%2==1) {
              if (x>0 && y>0 && this.board[x][y].squareType == -1 && this.board[x][y].numNeighbors(this.board)<2 && this.board[x-1][y].squareType == -1 && this.board[x][y-1].squareType == -1) {
                var temp = [];
                cur.x = x;
                cur.y = y;
                while (notVisited) {

                  this.board[cur.x][cur.y].squareType = 0;
                  temp.push(this.board[cur.x][cur.y]);
                  var moves = this.board[cur.x][cur.y].moves(this.board);
                  if (moves.length!=0) {
                    moveStack.push(cur);
                    //int randomMove = (int)random(0, moves.size());
                    var randomMove = floor(map(random(1), 0, 1, 0, moves.length));
                    cur = moves[randomMove];
                  } else if (moveStack.length!=0) {
                    cur = moveStack[moveStack.length-1];
                    moveStack.pop();
                  } else {
                    break;
                  }

                  notVisited = false;
                  for (var i = 0; i<this.numSquares; i++) {
                    for (var j = 0; j<this.numSquares; j++) {
                      if (i%2==1 || j%2==1) {
                        if (this.board[i][j].squareType == -1) {
                          notVisited = true;
                        }
                      }
                    }
                  }
                }
                var r = new Region(temp);
                r.path = true;
                this.regions.push(r);
              }
            }
          }
        }
        for (let r of this.regions) {
          for (let s of r.children) {
            s.region = r;
          }
        }

        //
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].squareType == 0 && this.board[i][j].pathNeighbors(this.board, this.numSquares) == 2) {
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i-1][j].squareType==-1 && this.board[i-2][j].squareType==0 && this.board[i-2][j].region == this.board[i][j].region) && random(1)<.02) {
                this.board[i-1][j].squareType = 0;
                this.board[i-1][j].region = this.board[i][j].region;
              }
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i+1][j].squareType==-1 && this.board[i+2][j].squareType==0 && this.board[i+2][j].region == this.board[i][j].region) && random(1)<.02) {
                this.board[i+1][j].squareType = 0;
                this.board[i+1][j].region = this.board[i][j].region;
              }
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i][j-1].squareType==-1 && this.board[i][j-2].squareType==0 && this.board[i][j-2].region == this.board[i][j].region) && random(1)<.02) {
                this.board[i][j-1].squareType = 0;
                this.board[i][j-1].region = this.board[i][j].region;
              }
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i][j+1].squareType==-1 && this.board[i][j+2].squareType==0 && this.board[i][j+2].region == this.board[i][j].region) && random(1)<.02) {
                this.board[i][j+1].squareType = 0;
                this.board[i][j+1].region = this.board[i][j].region;
              }
            }
          }
        }

        //
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].squareType == -1 && this.board[i][j].pathNeighbors(this.board, this.numSquares) == 2) {
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i-1][j].squareType==0 && this.board[i+1][j].squareType==0 && this.board[i-1][j].region == this.board[i+1][j].region) && random(1)<.02) {
                this.board[i][j].squareType = 0;
                this.board[i][j].region = this.board[i][j].region;
              }
              if (i>1 && j>1 && i<this.numSquares-2 && j<this.numSquares-2 && (this.board[i][j-1].squareType==0 && this.board[i][j+1].squareType==0 && this.board[i][j-1].region == this.board[i][j+1].region) && random(1)<.02) {
                this.board[i][j].squareType = 0;
                this.board[i][j].region = this.board[i][j].region;
              }
            }
          }
        }
    }

    //connects all regions with a door
   this.connectRegions = function() {

      this.regions[0].connect();

      for (var i = 0; i<this.numSquares; i++) {
        for (var j = 0; j<this.numSquares; j++) {
          if (this.board[i][j].squareType == -1 && this.board[i][j].connector(this.regions)) {
            this.connectors.push(this.board[i][j]);
          }
        }
      }

      var allConnected = false;

      while (!allConnected) {
        for (let r of this.regions) {
          if (r.connected) {
            if (this.connectors.length!=0) {
              var temp = floor(random(this.connectors.length));
              this.connectors[temp].squareType = -5;
              for (let u of this.regions) {
                if (this.connectors[temp].adjacentTo(u) && random(1)<.90) {
                  u.connect();
                }
              }
            }
            break;
          }
        }

        this.connectors = [];
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].squareType == -1 && this.board[i][j].connector(this.regions)) {
              this.connectors.push(this.board[i][j]);
            }
          }
        }

        allConnected = true;
        for (let r of this.regions) {
          if (!r.connected) {
            allConnected = false;
          }
        }
      }

      for (let r of this.regions) {
        for (let s of r.children) {
          s.region = r;
        }
      }
    }

    //removes most dead ends
    this.sparseMaze = function() {

      var deadends = true;

      while (deadends) {

        //remove all deadends (tile with 3 walls
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].deadend) {
              this.board[i][j].deadend = false;
              this.board[i][j].squareType = -1;
            }
          }
        }

        //find new deadends with a 3% chance to ignore one
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].squareType == 0 && this.board[i][j].numNeighbors(this.board) < 2 && random(1)<.97) {
              this.board[i][j].deadend = true;
            }
          }
        }

        //check if there are any deadends left
        deadends = false;
        for (var i = 0; i<this.numSquares; i++) {
          for (var j = 0; j<this.numSquares; j++) {
            if (this.board[i][j].squareType == 0 && this.board[i][j].deadend) {
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

}
