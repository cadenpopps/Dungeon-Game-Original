function Mob(_x, _y) {

   this.x = _x;
   this.y = _y;

   this.update = function() {
      if ((abs(this.x - player.x) < 7 && abs(this.y - player.y) < 7) || dungeon.floors[currentFloor].board[this.x][this.y].region == dungeon.floors[currentFloor].board[player.x][player.y].region) {


         if (this.x <= player.x && this.y <= player.y) {
            if (random(1) < .5) {
               if (!this.move('d')) {
                  this.move('r');
               }
            }
            else {
               if (!this.move('r')) {
                  this.move('d');
               }
            }
         }
         else if (this.x > player.x && this.y < player.y) {
            if (random(1) < .5) {
               if (!this.move('d')) {
                  this.move('l');
               }
            }
            else {
               if (!this.move('l')) {
                  this.move('d');
               }
            }
         }
         else if (this.x <= player.x && this.y >= player.y) {
            if (random(1) < .5) {
               if (!this.move('u')) {
                  this.move('r');
               }
            }
            else {
               if (!this.move('r')) {
                  this.move('u');
               }
            }
         }
         else if (this.x > player.x && this.y > player.y) {
            if (random(1) < .5) {
               if (!this.move('u')) {
                  this.move('l');
               }
            }
            else {
               if (!this.move('l')) {
                  this.move('u');
               }
            }
         }
      }
   };

   this.move = function(dir) {

      var sucess = false;

      dungeon.floors[currentFloor].board[this.x][this.y].containsMob = false;


      switch (dir) {
         case 'u':
            if (this.y > 0 && dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType != -1 && dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType != 2 && !dungeon.floors[currentFloor].board[this.x][this.y - 1].containsMob) {
               this.y--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == -5 && dungeon.floors[currentFloor].board[this.x][this.y - 1].isOpen) {
               this.y--;
               sucess = true;
            }

            break;
         case 'd':
            if (this.y < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != -1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != 2 && !dungeon.floors[currentFloor].board[this.x][this.y + 1].containsMob) {
               this.y++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == -5 && dungeon.floors[currentFloor].board[this.x][this.y + 1].isOpen) {
               this.y++;
               sucess = true;
            }
            break;
         case 'l':
            if (this.x > 0 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x - 1][this.y].containsMob) {
               this.x--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == -5 && dungeon.floors[currentFloor].board[this.x - 1][this.y].isOpen) {
               this.x--;
               sucess = true;
            }
            break;
         case 'r':
            if (this.x < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x + 1][this.y].containsMob) {
               this.x++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != -5 && dungeon.floors[currentFloor].board[this.x + 1][this.y].isOpen) {
               this.x++;
               sucess = true;
            }
            break;
      }

      dungeon.floors[currentFloor].board[this.x][this.y].containsMob = true;

      return sucess;
   };
}
