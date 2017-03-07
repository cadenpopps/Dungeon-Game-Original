function Mob( _x, _y ) {

    this.x = _x;
    this.y = _y;

    this.update = function( ) {
        if (( abs( x - player.x ) < 5 && abs( y - player.y ) < 5 ) || dungeon.floors.get( currentFloor ).board[x][y ].region == dungeon.floors.get( currentFloor ).board[player.x][player.y ].region) {

            if ( x < player.x && y < player.y ) {
                if ( random( 1 ) < .5 ) {
                    if (!this.move( 'd', false )) {
                        this.move( 'r', false );
                    }
                } else {
                    if (!this.move( 'r', false )) {
                        this.move( 'd', false );
                    }
                }
            } else if ( x > player.x && y < player.y ) {
                if ( random( 1 ) < .5 ) {
                    if (!this.move( 'd', false )) {
                        this.move( 'l', false );
                    }
                } else {
                    if (!this.move( 'l', false )) {
                        this.move( 'd', false );
                    }
                }
            } else if ( x < player.x && y > player.y ) {
                if ( random( 1 ) < .5 ) {
                    if (!this.move( 'u', false )) {
                        this.move( 'r', false );
                    }
                } else {
                    if (!this.move( 'r', false )) {
                        this.move( 'u', false );
                    }
                }
            } else if ( x > player.x && y > player.y ) {
                if ( random( 1 ) < .5 ) {
                    if (!this.move( 'u', false )) {
                        this.move( 'l', false );
                    }
                } else {
                    if (!this.move( 'l', false )) {
                        this.move( 'u', false );
                    }
                }
            }
        }
    }

    public boolean move( char dir, boolean isPlayer ) {

        boolean sucess = false;

        if ( isPlayer ) {
            dungeon.floors.get( currentFloor ).board[x][y ].containsMob = false;
        }

        switch ( dir ) {
            case 'u':
                if (y > 0 && ( ( dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].isOpen ) && dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].squareType != -1 && dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].squareType != 2 && !dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].containsMob )) {
                    if ( isPlayer ) {
                        y--;
                        sucess = true;
                    } else if ( dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x][( int )y - 1].isOpen ) {
                        y--;
                        sucess = true;
                    }
                }
                break;
            case 'd':
                if (y < dungeon.floors.get( currentFloor ).numSquares - 1 && ( ( dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].isOpen ) && dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].squareType != -1 && dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].squareType != 2 && !dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].containsMob )) {
                    if ( isPlayer ) {
                        y++;
                        sucess = true;
                    } else if ( dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x][( int )y + 1].isOpen ) {
                        y++;
                        sucess = true;
                    }
                }
                break;
            case 'l':
                if (x > 0 && (( dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].isOpen) && dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].squareType != -1 && dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].squareType != 2 && !dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].containsMob)) {
                    if ( isPlayer ) {
                        x--;
                        sucess = true;
                    } else if ( dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x - 1][( int )y ].isOpen) {
                        x--;
                        sucess = true;
                    }
                }
                break;
            case 'r':
                if (x < dungeon.floors.get( currentFloor ).numSquares - 1 && (( dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].isOpen) && dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].squareType != -1 && dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].squareType != 2 && !dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].containsMob)) {
                    if ( isPlayer ) {
                        x++;
                        sucess = true;
                    } else if ( dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].squareType != -5 || dungeon.floors.get( currentFloor ).board[( int )x + 1][( int )y ].isOpen) {
                        x++;
                        sucess = true;
                    }
                }
                break;
        }

        if ( isPlayer && sucess ) {
            player.update( );
            dungeon.floors.get( currentFloor ).board[x][y ].containsMob = true;
            for ( Mob m : dungeon.floors.get( currentFloor ).mobs ) {
                dungeon.floors.get( currentFloor ).board[m.x][m.y ].containsMob = false;
                m.update( );
                dungeon.floors.get( currentFloor ).board[m.x][m.y ].containsMob = true;
            }
        } else if ( isPlayer ) {
            dungeon.floors.get( currentFloor ).board[x][y ].containsMob = true;
        }

        return sucess;
    }
}
