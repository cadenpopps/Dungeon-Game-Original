function Player(_x, _y) {

   //new Player with x and y location

   this.x = _x;
   this.y = _y;
   //list of squares the player can see
   this.canSee = [];
   //list of squares the player has seen
   this.hasSeen = [];
   //the furthest distance a player can see
   const radius = 20;

   //update player visibility, line of sight, etc. called on moves and on new floors

   this.update = function() {

      //if the player is on the down stair, start the nextFloorAnimation
      if (dungeon.floors[currentFloor].board[this.x][this.y].squareType == -2) {
         nextFloorAnimation = true;
      }

      //reset canSee on every update
      canSee = [];

      //brightness and mobs
      for (var i = 0; i < numSquares; i++) {
         for (var j = 0; j < numSquares; j++) {
            var distance = floor(dist(this.x, this.y, i, j));
            dungeon.floors[currentFloor].board[i][j].lightLevel = distance;
         }
      }

      //line of sight within radius. can see if not blocked, if it is the blocker, or if it's in the same region and the region is a room
      for (var i = this.x - radius; i <= this.x + radius; i++) {
         for (var j = this.y - radius; j <= this.y + radius; j++) {
            if (i >= 0 && j >= 0 && i < numSquares && j < numSquares) {
               var l = new SightLine(this.x, this.y, i, j);
               var blocked = false;
               for (var k = 0; k < l.touching.length; k++) {
                  if (blocked) {
                     //canSee.add(l.touching.get(k));
                     continue;
                  }
                  else if (l.touching.get(k).squareType == -1 || (l.touching.get(k).squareType == -5 && !l.touching.get(k).isOpen)) {
                     blocked = true;
                     if (!canSee.contains(l.touching.get(k))) {
                        canSee.add(l.touching.get(k));
                     }
                     if (!hasSeen.contains(l.touching.get(k))) {
                        hasSeen.add(l.touching.get(k));
                     }
                  }
                  else if (dungeon.floors[currentFloor].board[x][y].region != null && !dungeon.floors[currentFloor].board[x][y].region.path && l.touching.get(k).region == dungeon.floors[currentFloor].board[x][y].region) {
                     if (!canSee.contains(l.touching.get(k))) {
                        canSee.add(l.touching.get(k));
                     }
                     if (!hasSeen.contains(l.touching.get(k))) {
                        hasSeen.add(l.touching.get(k));
                     }
                  }
                  else {
                     if (!canSee.contains(l.touching.get(k))) {
                        canSee.add(l.touching.get(k));
                     }
                     if (!hasSeen.contains(l.touching.get(k))) {
                        hasSeen.add(l.touching.get(k));
                     }
                  }
               }
            }
         }
      }

      //adds all squares around visible paths to hasSeen
      for (var a = canSee.size() - 1; a >= 0; a--) {
         if (canSee.get(a).squareType != -1 && (canSee.get(a).squareType != -5 || canSee.get(a).isOpen)) {
            for (var i = canSee.get(a).locX - 1; i <= canSee.get(a).locX + 1; i++) {
               for (var j = canSee.get(a).locY - 1; j <= canSee.get(a).locY + 1; j++) {
                  if (i >= 0 && j >= 0 && i < numSquares && j < numSquares && (i != canSee.get(a).locX || j != canSee.get(a).locY)) {
                     if (!hasSeen.contains(dungeon.floors[currentFloor].board[i][j])) {
                        hasSeen.add(dungeon.floors[currentFloor].board[i][j]);
                     }
                  }
               }
            }
         }
      }
   };

   //moves the player, updates mobs
   this.move = function(dir) {

      var sucess = false;

      dungeon.floors[currentFloor].board[this.x][this.y].containsMob = false;

      switch (dir) {
         case 'u':
            if (this.y > 0 && dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType != -1 && dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType != 2 && !dungeon.floors[currentFloor].board[this.x][this.y - 1].containsMob) {
               this.y--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType != -5 || dungeon.floors[currentFloor].board[this.x][this.y - 1].isOpen) {
               this.y--;
               sucess = true;
            }

            break;
         case 'd':
            if (this.y < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != -1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != 2 && !dungeon.floors[currentFloor].board[this.x][this.y + 1].containsMob) {
               this.y++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != -5 || dungeon.floors[currentFloor].board[this.x][this.y + 1].isOpen) {
               this.y++;
               sucess = true;
            }
            break;
         case 'l':
            if (this.x > 0 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x - 1][this.y].containsMob) {
               this.x--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != -5 || dungeon.floors[currentFloor].board[this.x - 1][this.y].isOpen) {
               this.x--;
               sucess = true;
            }
            break;
         case 'r':
            if (this.x < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x + 1][this.y].containsMob) {
               this.x++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != -5 || dungeon.floors[currentFloor].board[this.x + 1][this.y].isOpen) {
               this.x++;
               sucess = true;
            }
            break;
      }

      if (sucess) {
         this.update();
         for (let m of dungeon.floors[currentFloor].mobs) {
            m.update();
         }
      }
      dungeon.floors[currentFloor].board[this.x][this.y].containsMob = true;

      return sucess;
   };

   //Opens all doors in a 3x3 square around the player
   this.openDoor = function() {
      for (var i = this.x - 1; i <= this.x + 1; i++) {
         for (var j = this.y - 1; j <= this.y + 1; j++) {
            if (i > 0 && j > 0 && i < numSquares - 1 && j < numSquares - 1 && (i != this.x || j != this.y)) {
               if (dungeon.floors[currentFloor].board[i][j].squareType == -5) {
                  dungeon.floors[currentFloor].board[i][j].isOpen = !dungeon.floors.get(currentFloor).board[i][j].isOpen;
                  update();
               }
            }
         }
      }
   };

   //kills all mobs in a 3x3 square around the player
   this.attack = function() {
      for (var i = this.x - 2; i <= this.x + 2; i++) {
         for (var j = this.y - 2; j <= this.y + 2; j++) {
            if (i > 0 && j > 0 && i < numSquares - 1 && j < numSquares - 1 && (i != this.x || j != this.y)) {
               if (dungeon.floors[currentFloor].board[i][j].containsMob) {
                  for (var a = dungeon.floors[currentFloor].mobs.size() - 1; a >= 0; a--) {
                     if (dungeon.floors[currentFloor].mobs.get(a).x == i && dungeon.floors.get(currentFloor).mobs.get(a).y == j) {
                        dungeon.floors[currentFloor].mobs.remove(a);
                        dungeon.floors[currentFloor].board[i][j].containsMob = false;
                     }
                  }
               }
            }
         }
      }
   };
}
