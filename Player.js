function Player(_x, _y) {
   //new Player with x and y location
   this.x = _x;
   this.y = _y;
   //list of squares the player can see
   this.canSee = [];
   //list of squares the player has seen
   this.hasSeen = [];
   //the furthest distance a player can see
   const RADIUS = 20;
   //update player visibility, line of sight, etc. called on moves and on new floors
   this.update = function() {
      //if the player is on the down stair, start the nextFloorAnimation
      if (dungeon.floors[currentFloor].board[this.x][this.y].squareType == STAIRDOWN) {
         nextFloorAnimation = true;
      }
      //reset canSee on every update
      this.canSee = [];
      //brightness and mobs?
      for (var i = 0; i < numSquares; i++) {
         for (var j = 0; j < numSquares; j++) {
            var distance = floor(dist(this.x, this.y, i, j));
            dungeon.floors[currentFloor].board[i][j].lightLevel = distance;
         }
      }
      //line of sight within RADIUS. can see if not blocked, if it is the blocker, or if it's in the same region and the region is a room
      for (var i = this.x - RADIUS; i <= this.x + RADIUS; i++) {
         for (var j = this.y - RADIUS; j <= this.y + RADIUS; j++) {
            if (i >= 0 && j >= 0 && i < numSquares && j < numSquares) {
               var l = new SightLine(this.x, this.y, i, j);
               if (!l.straight) {
                  l.findTouching();
               }
               else {
                  l.findStraightTouching();
               }
               var blocked = false;
               for (var k = 0; k < l.touching.length; k++) {
                  if (blocked) {
                     //this.canSee.push(l.touching.get(k));
                     continue;
                  }
                  else if (l.touching[k].squareType == WALL || (l.touching[k].squareType == DOOR && !l.touching[k].isOpen)) {
                     blocked = true;
                     if (this.canSee.indexOf(l.touching[k]) == -1) {
                        this.canSee.push(l.touching[k]);
                     }
                     if (this.hasSeen.indexOf(l.touching[k]) == -1) {
                        this.hasSeen.push(l.touching[k]);
                     }
                  }
                  else if (dungeon.floors[currentFloor].board[this.x][this.y].region !== null && !dungeon.floors[currentFloor].board[this.x][this.y].region.path && l.touching[k].region == dungeon.floors[currentFloor].board[this.x][this.y].region) {
                     if (this.canSee.indexOf(l.touching[k]) == -1) {
                        this.canSee.push(l.touching[k]);
                     }
                     if (this.hasSeen.indexOf(l.touching[k]) == -1) {
                        this.hasSeen.push(l.touching[k]);
                     }
                  }
                  else {
                     if (this.canSee.indexOf(l.touching[k]) == -1) {
                        this.canSee.push(l.touching[k]);
                     }
                     if (this.hasSeen.indexOf(l.touching[k]) == -1) {
                        this.hasSeen.push(l.touching[k]);
                     }
                  }
               }
            }
         }
      }
      //pushs all squares around visible paths to this.hasSeen
      for (var a = this.canSee.length - 1; a >= 0; a--) {
         if (this.canSee[a].squareType != WALL && !(this.canSee[a].squareType == DOOR && this.canSee[a].isOpen)) {
            for (var i = this.canSee[a].x - 1; i <= this.canSee[a].x + 1; i++) {
               for (var j = this.canSee[a].y - 1; j <= this.canSee[a].y + 1; j++) {
                  if (i >= 0 && j >= 0 && i < numSquares && j < numSquares && (i != this.canSee[a].x || j != this.canSee[a].y)) {
                     if (this.hasSeen.indexOf((dungeon.floors[currentFloor].board[i][j])) == -1) {
                        this.hasSeen.push(dungeon.floors[currentFloor].board[i][j]);
                     }
                  }
               }
            }
         }
      }
      redraw();
   };
   //moves the player, updates mobs
   this.move = function(dir) {
      var sucess = false;
      dungeon.floors[currentFloor].board[this.x][this.y].containsMob = false;
      switch (dir) {
         case 'u':
            if (this.y > 0 && ((dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == PATH || dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == STAIRUP || dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == STAIRDOWN) && !dungeon.floors[currentFloor].board[this.x][this.y - 1].containsMob)) {
               this.y--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == DOOR && dungeon.floors[currentFloor].board[this.x][this.y - 1].isOpen) {
               this.y--;
               sucess = true;
            }
            break;
         case 'd':
            if (this.y < dungeon.floors[currentFloor].numSquares - 1 && ((dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == PATH || dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == STAIRUP || dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == STAIRDOWN) && !dungeon.floors[currentFloor].board[this.x][this.y + 1].containsMob)) {
               this.y++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == DOOR && dungeon.floors[currentFloor].board[this.x][this.y + 1].isOpen) {
               this.y++;
               sucess = true;
            }
            break;
         case 'l':
            if (this.x > 0 && ((dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == PATH || dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == STAIRUP || dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == STAIRDOWN) && !dungeon.floors[currentFloor].board[this.x - 1][this.y].containsMob)) {
               this.x--;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == DOOR && dungeon.floors[currentFloor].board[this.x - 1][this.y].isOpen) {
               this.x--;
               sucess = true;
            }
            break;
         case 'r':
            if (this.x < dungeon.floors[currentFloor].numSquares - 1 && ((dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType == PATH || dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType == STAIRUP || dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType == STAIRDOWN) && !dungeon.floors[currentFloor].board[this.x + 1][this.y].containsMob)) {
               this.x++;
               sucess = true;
            }
            else if (dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType == DOOR && dungeon.floors[currentFloor].board[this.x + 1][this.y].isOpen) {
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
   /*this.findPath = function(g) {
      var start = createVector(this.x, this.y);
      var goal = g;
      //println(board[(int)start.x][(int)start.y].squareType);
      //println(board[(int)goal.x][(int)goal.y].squareType);
      var closedSet = [];
      var openSet = [];
      var cameFrom = [];
      var gScore = [];
      var fScore = [];

      for (var i = 0; i < numSquares; i++) {
         for (var j = 0; j < numSquares; j++) {
            gScore.push({ dungeon.floors[currentFloor].board[i][j], 10000 });
         }
      }
      gScore.push({ dungeon.floors[currentFloor].board[start.x][start.y], 0.0 });
      fScore.push({
         dungeon.floors[currentFloor].board[start.x][start.y],
         this.heuristic(start, goal)
      });
      openSet.push(dungeon.floors[currentFloor].board[start.x][start.y]);
      while (openSet.length > 0) {
         var current = dungeon.floors[currentFloor].board[start.x][start.y];
         var lowest = 10001;
         for (let s of openSet) {
            if (fScore[s] < lowest) {
               lowest = fScore[s];
               current = s;
            }
         }
         if (current.x == goal.x && current.y == goal.y) {
            /*while ( cameFrom.indexOf( current ) != 0 ) {
                current = cameFrom.get( current );
                //current.squareType = 1;
            }
            //dungeon.floors[currentFloor].board[start.x][start.y ].squareType = -3;
            return true;
         }
         openSet.pop(current);
         closedSet.push(current);
         var neighbors = current.neighbors(dungeon.floors[currentFloor].board)
         for (let s of neighbors) {
            if (closedSet.includes(s)) {
               continue;
            }
            else {
               var tempG = gScore.get(current) + 1;
               if (!openSet.includes(s)) {
                  openSet.push(s);
               }
               if (tempG < gScore[s]) {
                  cameFrom.push({ s, current });
                  gScore.push({ s, tempG });
                  fScore.push({
                     s,
                     gScore[s] + this.heuristic(createVector(s.x, s.y), goal)
                  });
               }
            }
         }
      }
      return false;
   };*/

   this.findPath = function(f, _start, _goal) {
         var start = _start;
         var goal = _goal;
         //println(board[(int)start.x][(int)start.y].squareType);
         //println(board[(int)goal.x][(int)goal.y].squareType);
         var closedSet = [];
         var openSet = [];
         var cameFrom = [];
         var gScore = [];
         var fScore = [];

         for (var i = 0; i < numSquares; i++) {
            for (var j = 0; j < numSquares; j++) {
               gScore.push(new { dungeon.floors[f].board[i][j], 10000 });
            }
         }

         gScore.push({ dungeon.floors[f].board[start.x][start.y], 0 });
         fScore.push({ dungeon.floors[f].board[start.x][start.y], this.heuristic(start, goal) });
         openSet.push(dungeon.floors[f].board[start.x][start.y]);
         while (openSet.length > 0) {
            var current = dungeon.floors[f].board[start.x][start.y];
            var lowest = 10001;
            for (let s of openSet) {
               if (fScore[s][1] < lowest) {
                  console.log("lower");
                  lowest = fScore[s[1]; current = s;
                  }
               }
               if (current.x == goal.x && current.y == goal.y) {
                  /*while ( cameFrom.indexOf( current ) != 0 ) {
                      current = cameFrom.get( current );
                      //current.squareType = 1;
                  }*/
                  //dungeon.floors[f].board[start.x][start.y ].squareType = -3;
                  return true;
               }
               openSet.splice(openSet.indexOf(current));
               closedSet.push(current);
               var neighbors = current.neighbors(dungeon.floors[f].board);
               for (let s of neighbors) {
                  if (closedSet.includes(s)) {
                     continue;
                  }
                  else {
                     var tempG = gScore.get(current)[1] + 1;
                     if (!openSet.includes(s)) {
                        openSet.push(s);
                     }
                     if (tempG < gScore[s[1]) {
                           cameFrom.set(s, current);
                           gScore.set(s, tempG);
                           fScore.set(s, gScore[s] + this.heuristic(createVector(s.x, s.y), goal));
                        }
                     }
                  }
               }
               return false;
            };

            //dist from player to goal
            this.heuristic = function(start, goal) {
               return dist(start.x, start.y, goal.x, goal.y);
            };

            //Opens all doors in a 3x3 square around the player
            this.openDoor = function() {
               for (var i = this.x - 1; i <= this.x + 1; i++) {
                  for (var j = this.y - 1; j <= this.y + 1; j++) {
                     if (i > 0 && j > 0 && i < numSquares - 1 && j < numSquares - 1 && (i != this.x || j != this.y)) {
                        if (dungeon.floors[currentFloor].board[i][j].squareType == DOOR) {
                           dungeon.floors[currentFloor].board[i][j].isOpen = !dungeon.floors[currentFloor].board[i][j].isOpen;
                           this.update();
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
                           for (var a = dungeon.floors[currentFloor].mobs.length - 1; a >= 0; a--) {
                              if (dungeon.floors[currentFloor].mobs[a].x == i && dungeon.floors[currentFloor].mobs[a].y == j) {
                                 dungeon.floors[currentFloor].mobs.splice(a, 1);
                                 dungeon.floors[currentFloor].board[i][j].containsMob = false;
                              }
                           }
                        }
                     }
                  }
               }
            };
         };
