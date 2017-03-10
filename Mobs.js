function Mob(_x, _y) {

    this.x = _x;
    this.y = _y;

    this.update = function() {
        if ((abs(x - player.x) < 5 && abs(y - player.y) < 5) || dungeon.floors.get(currentFloor).board[x][y].region == dungeon.floors.get(currentFloor).board[player.x][player.y].region) {

            if (x < player.x && y < player.y) {
                if (random(1) < .5) {
                    if (!this.move('d', false)) {
                        this.move('r', false);
                    }
                }
                else {
                    if (!this.move('r', false)) {
                        this.move('d', false);
                    }
                }
            }
            else if (x > player.x && y < player.y) {
                if (random(1) < .5) {
                    if (!this.move('d', false)) {
                        this.move('l', false);
                    }
                }
                else {
                    if (!this.move('l', false)) {
                        this.move('d', false);
                    }
                }
            }
            else if (x < player.x && y > player.y) {
                if (random(1) < .5) {
                    if (!this.move('u', false)) {
                        this.move('r', false);
                    }
                }
                else {
                    if (!this.move('r', false)) {
                        this.move('u', false);
                    }
                }
            }
            else if (x > player.x && y > player.y) {
                if (random(1) < .5) {
                    if (!this.move('u', false)) {
                        this.move('l', false);
                    }
                }
                else {
                    if (!this.move('l', false)) {
                        this.move('u', false);
                    }
                }
            }
        }
    }

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

        dungeon.floors[currentFloor].board[this.x][this.y].containsMob = true;


        return success;
    };
}
