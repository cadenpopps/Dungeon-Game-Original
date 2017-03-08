function Square(_x, _y, _difficulty, _squareType) {

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

    //returns an arraylist of pvectors of moves (for maze)
    this.moves = function(board) {
        moves = [];
        if (this.x > 1 && board[this.x - 1][this.y].squareType == -1 && (this.y) % 2 == 1 && board[this.x - 1][this.y].numNeighbors(board) < 2) {
            moves.push(createVector(this.x - 1, this.y));
        }
        if (this.x < board.length - 2 && board[this.x + 1][this.y].squareType == -1 && (this.y) % 2 == 1 && board[this.x + 1][this.y].numNeighbors(board) < 2) {
            moves.push(createVector(this.x + 1, this.y));
        }
        if (this.y > 1 && board[this.x][this.y - 1].squareType == -1 && (this.x) % 2 == 1 && board[this.x][this.y - 1].numNeighbors(board) < 2) {
            moves.push(createVector(this.x, this.y - 1));
        }
        if (this.y < board.length - 2 && board[this.x][this.y + 1].squareType == -1 && (this.x) % 2 == 1 && board[this.x][this.y + 1].numNeighbors(board) < 2) {
            moves.push(createVector(this.x, this.y + 1));
        }
        return moves;
    };

    //returns the number of neighbors, doors or paths
    this.numNeighbors = function(board) {
        var neighbors = 0;

        if (this.x > 0 && (board[this.x - 1][this.y].squareType === 0 || board[this.x - 1][this.y].squareType == -5)) {
            neighbors++;
        }
        if (this.x < numSquares - 1 && (board[this.x + 1][this.y].squareType === 0 || board[this.x + 1][this.y].squareType == -5)) {
            neighbors++;
        }
        if (this.y > 0 && (board[this.x][this.y - 1].squareType === 0 || board[this.x][this.y - 1].squareType == -5)) {
            neighbors++;
        }
        if (this.y < numSquares - 1 && (board[this.x][this.y + 1].squareType === 0 || board[this.x][this.y + 1].squareType == -5)) {
            neighbors++;
        }

        return neighbors;
    };

    //returns an ArrayList of neighbors, doors or paths
    this.neighbors = function(board) {

        neighbors = [];

        if (this.x > 0 && (board[this.x - 1][this.y].squareType === 0 || board[this.x - 1][this.y].squareType == -5 || board[this.x - 1][this.y].squareType == -2)) {
            neighbors.push(board[this.x - 1][this.y]);
        }
        if (this.x < numSquares - 1 && (board[this.x + 1][this.y].squareType === 0 || board[this.x + 1][this.y].squareType == -5 || board[this.x + 1][this.y].squareType == -2)) {
            neighbors.push(board[this.x + 1][this.y]);
        }
        if (this.y > 0 && (board[this.x][this.y - 1].squareType === 0 || board[this.x][this.y - 1].squareType == -5 || board[this.x][this.y - 1].squareType == -2)) {
            neighbors.push(board[this.x][this.y - 1]);
        }
        if (this.y < numSquares - 1 && (board[this.x][this.y + 1].squareType === 0 || board[this.x][this.y + 1].squareType == -5 || board[this.x][this.y + 1].squareType == -2)) {
            neighbors.push(board[this.x][this.y + 1]);
        }

        return neighbors;
    };

    //returns the number of diagonal neighbors
    this.diagNeighbors = function(board) {
        var neighbors = 0;

        if (this.x > 0 && board[this.x - 1][this.y - 1].squareType === 0) {
            neighbors++;
        }
        if (this.x < numSquares - 1 && board[this.x + 1][this.y + 1].squareType === 0) {
            neighbors++;
        }
        if (this.y > 0 && board[this.x + 1][this.y - 1].squareType === 0) {
            neighbors++;
        }
        if (this.y < numSquares - 1 && board[this.x - 1][this.y + 1].squareType === 0) {
            neighbors++;
        }

        return neighbors;
    };

    //return the number of path neighbors
    this.pathNeighbors = function(board) {
        var neighbors = 0;

        if (this.x > 0 && board[this.x - 1][this.y].squareType === 0) {
            neighbors++;
        }
        if (this.x < numSquares - 2 && board[this.x + 1][this.y].squareType === 0) {
            neighbors++;
        }
        if (this.y > 0 && board[this.x][this.y - 1].squareType === 0) {
            neighbors++;
        }
        if (this.y < numSquares - 2 && board[this.x][this.y + 1].squareType === 0) {
            neighbors++;
        }

        return neighbors;
    };

    //returns true if this square should be a connector
    this.connector = function(regions) {

        for (let r of regions) {
            if (r.connected) {
                if (this.adjacentTo(r)) {
                    for (let u of regions) {
                        if (!u.connected) {
                            if (this.adjacentTo(u)) {
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    };

    //returns true if this square is adjacent to region
    this.adjacentTo = function(region) {

        for (let s of region.children) {
            if ((this.x - 1 == s.x && this.y == s.y) || (this.x + 1 == s.x && this.y == s.y) || (this.x == s.x && this.y - 1 == s.y) || (this.x == s.x && this.y + 1 == s.y)) {
                return true;
            }
        }
        return false;
    };
}
