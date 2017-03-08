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
        this.canSee = [];

        //brightness and mobs?
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
                    if (!l.straight) {
                        l.findTouching();
                    }
                    else {
                        l.findStraightTouching();
                    }
                    var blocked = false;
                    for (var k = 0; k < l.touching.length; k++) {
                        if (blocked) {
                            //this.canSee.add(l.touching.get(k));
                            continue;
                        }
                        else if (l.touching[k].squareType == -1 || (l.touching[k].squareType == -5 && !l.touching[k].isOpen)) {
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
            if (this.canSee[a].squareType != -1 && (this.canSee[a].squareType != -5 || this.canSee[a].isOpen)) {
                for (var i = this.canSee[a].locX - 1; i <= this.canSee[a].locX + 1; i++) {
                    for (var j = this.canSee[a].locY - 1; j <= this.canSee[a].locY + 1; j++) {
                        if (i >= 0 && j >= 0 && i < numSquares && j < numSquares && (i != this.canSee[a].locX || j != this.canSee[a].locY)) {
                            if (!this.hasSeen.contains(dungeon.floors[currentFloor].board[i][j])) {
                                this.hasSeen.push(dungeon.floors[currentFloor].board[i][j]);
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
                else if (dungeon.floors[currentFloor].board[this.x][this.y - 1].squareType == -5 || dungeon.floors[currentFloor].board[this.x][this.y - 1].isOpen) {
                    this.y--;
                    sucess = true;
                }

                break;
            case 'd':
                if (this.y < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != -1 && dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType != 2 && !dungeon.floors[currentFloor].board[this.x][this.y + 1].containsMob) {
                    this.y++;
                    sucess = true;
                }
                else if (dungeon.floors[currentFloor].board[this.x][this.y + 1].squareType == -5 || dungeon.floors[currentFloor].board[this.x][this.y + 1].isOpen) {
                    this.y++;
                    sucess = true;
                }
                break;
            case 'l':
                if (this.x > 0 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x - 1][this.y].containsMob) {
                    this.x--;
                    sucess = true;
                }
                else if (dungeon.floors[currentFloor].board[this.x - 1][this.y].squareType == -5 || dungeon.floors[currentFloor].board[this.x - 1][this.y].isOpen) {
                    this.x--;
                    sucess = true;
                }
                break;
            case 'r':
                if (this.x < dungeon.floors[currentFloor].numSquares - 1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != -1 && dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType != 2 && !dungeon.floors[currentFloor].board[this.x + 1][this.y].containsMob) {
                    this.x++;
                    sucess = true;
                }
                else if (dungeon.floors[currentFloor].board[this.x + 1][this.y].squareType == -5 || dungeon.floors[currentFloor].board[this.x + 1][this.y].isOpen) {
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
}
