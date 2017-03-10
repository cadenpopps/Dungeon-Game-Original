function Room(_x1, _y1, _x2, _y2, numSquares) {
   //makes a new room that has a position for top left corner and bottom right corner
   this.x1 = _x1;
   this.y1 = _y1;
   this.x2 = _x2;
   this.y2 = _y2;
   //push x1 and y2 to odd squares
   if (this.x1 % 2 === 0) {
      this.x1++;
   }
   if (this.y1 % 2 === 0) {
      this.y1++;
   }
   //push x2 and y2 to even squares
   if (this.x2 % 2 == 1) {
      this.x2++;
   }
   if (this.y2 % 2 == 1) {
      this.y2++;
   }
   //constrain x2 and y2 to numSquares -1
   if (this.x2 >= numSquares - 1) {
      this.x2 = numSquares - 1;
   }
   if (this.y2 >= numSquares - 1) {
      this.y2 = numSquares - 1;
   }
   //width and height
   this.rwidth = abs(this.x1 - this.x2);
   this.rheight = abs(this.y1 - this.y2);
   //not a special room
   this.roomType = 0;
   //list of children
   this.childSquares = [];
   //returns true if new room overlaps with a tempRoom
   this.overlaps = function(tempRoom) {
      //if room 1 is to the left or right of room 2, they don't overlap
      if (tempRoom.x1 > this.x2 || tempRoom.x2 < this.x1) {
         return false;
      }
      //if room 2 is to above or below room 2, they don't overlap
      if (tempRoom.y1 > this.y2 || tempRoom.y2 < this.y1) {
         return false;
      }
      return true;
   }
   this.notRoom = function() {
      //if the room is too small or weirdly shaped, it shouldn't be a room
      if (abs(this.rwidth - this.rheight) > 3 || this.rheight < 2 || this.rwidth < 2) {
         return true;
      }
      return false;
   }
   //add all the child squares to childSquares
   this.addChildren = function(board) {
      for (var i = this.x1; i < this.x2; i++) {
         for (var j = this.y1; j < this.y2; j++) {
            this.childSquares.push(board[i][j]);
         }
      }
   }
   //set all child squares to 0
   this.makeRoom = function(board) {
      for (var i = this.x1; i < this.x2; i++) {
         for (var j = this.y1; j < this.y2; j++) {
            board[i][j].squareType = 0;
         }
      }
   }
   //returns edges of room
   this.getEdges = function(board) {
      var edges = [];
      for (let s of this.childSquares) {
         if (s.x == this.x1 || s.y == this.y1 || s.x == this.x2 || s.y == this.y2) {
            edges.push(s);
         }
      }
      return edges;
   }
}
