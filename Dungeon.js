//new dungeon stores floors, squares per floor
function Dungeon( _numFloors, _numSquares ) {

    // number of floors
    this.numFloors = _numFloors;
    //number of squares (width and height)
    this.numSquares = _numSquares;
    //ArrayList of floors
    this.floors = [ ];

    for ( var i = 0; i < this.numFloors; i++ ) {
        if ( i > 0 ) {
            var f = new Floor( i, numSquares, numFloors, this.floors[i - 1].stairDown )
            f.buildFloor( );
            this.floors.push( f );
        } else {
            var entrance = createVector(floor(random( 5, this.numSquares - 5 )), floor(random( 5, this.numSquares - 5 )));
            var f = new Floor( i, numSquares, numFloors, entrance );
            f.buildFloor( );
            this.floors.push( f );

        }
    }
}
