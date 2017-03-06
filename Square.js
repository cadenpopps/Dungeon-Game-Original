function Square( _x, _y, _difficulty, _squareType ) {

    this.x = _x;
    this.y = _y;
    this.difficulty = _difficulty;
    this.squareType = _squareType;
    this.lightLevel = 0;
    this.deadend = false;
    this.containsMob = false;
    this.isOpen = false;
    this.region = null;
    this.texture = null;

}
