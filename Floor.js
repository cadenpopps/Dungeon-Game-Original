function Floor( _floorNum, _numSquares, _numFloors, _stairUp ) {

    this.floorNum = _floorNum;
    this.numSquares = _numSquares;
    this.numFloors = _numFloors;
    this.stairUp = _stairUp;
    this.rooms = [ ];
    this.regions = [ ];
    this.connectors = [ ];
    this.mobs = [ ];
    this.roomTries = numSquares * 20;
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
        // genRooms( );
        // genMaze( );
        // connectRegions( );
        // sparseMaze( );
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

        for ( r of this.rooms ) {
            r.addChildren( this.board );
            //this.regions.push(new Region( r.childSquares ));
            r.roomType = -1;
        }
    }

}
