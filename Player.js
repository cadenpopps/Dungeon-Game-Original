function Player( _x, _y ) {

    ArrayList < Square > canSee;
    ArrayList < Square > hasSeen;
    final int radius;

    public Player( int x, int y ) {
        //new mob with x and y location
        super( x, y );
        //list of squares the player can see
        canSee = new ArrayList < Square > ( );
        //list of squares the player has seen
        hasSeen = new ArrayList < Square > ( );
        //the furthest distance a player can see
        radius = 20;
    }

    //update player visibility, line of sight, etc. called on moves and on new floors

    public void update( ) {

        //if the player is on the down stair, start the nextFloorAnimation
        if ( dungeon.floors.get( currentFloor ).board[( int )x][( int )y ].squareType == -2) {
            nextFloorAnimation = true;
        }

        //reset canSee on every update
        canSee = new ArrayList < Square > ( );

        //brightness and mobs
        for ( int i = 0; i < numSquares; i++ ) {
            for ( int j = 0; j < numSquares; j++ ) {
                float distance = dist( player.x, player.y, i, j );
                dungeon.floors.get( currentFloor ).board[i][j ].lightLevel = ( int )distance;
            }
        }

        //line of sight within radius. can see if not blocked, if it is the blocker, or if it's in the same region and the region is a room
        for ( int i = x - radius; i <= x + radius; i++ ) {
            for ( int j = y - radius; j <= y + radius; j++ ) {
                if ( i >= 0 && j >= 0 && i < numSquares && j < numSquares ) {
                    SightLine l = new SightLine( x, y, i, j );
                    boolean blocked = false;
                    for ( int k = 0; k < l.touching.size( ); k++ ) {
                        if ( blocked ) {
                            //canSee.add(l.touching.get(k));
                            continue;
                        } else if (l.touching.get( k ).squareType == -1 || ( l.touching.get( k ).squareType == -5 && !l.touching.get( k ).isOpen )) {
                            blocked = true;
                            if (!canSee.contains(l.touching.get( k ))) {
                                canSee.add(l.touching.get( k ));
                            }
                            if (!hasSeen.contains(l.touching.get( k ))) {
                                hasSeen.add(l.touching.get( k ));
                            }
                        } else if ( dungeon.floors.get( currentFloor ).board[x][y ].region != null && !dungeon.floors.get( currentFloor ).board[x][y ].region.path && l.touching.get( k ).region == dungeon.floors.get( currentFloor ).board[x][y ].region) {
                            if (!canSee.contains(l.touching.get( k ))) {
                                canSee.add(l.touching.get( k ));
                            }
                            if (!hasSeen.contains(l.touching.get( k ))) {
                                hasSeen.add(l.touching.get( k ));
                            }
                        } else {
                            if (!canSee.contains(l.touching.get( k ))) {
                                canSee.add(l.touching.get( k ));
                            }
                            if (!hasSeen.contains(l.touching.get( k ))) {
                                hasSeen.add(l.touching.get( k ));
                            }
                        }
                    }
                }
            }
        }

        //adds all squares around visible paths to hasSeen
        for ( int a = canSee.size( ) - 1; a >= 0; a-- ) {
            if (canSee.get( a ).squareType != -1 && ( canSee.get( a ).squareType != -5 || canSee.get( a ).isOpen )) {
                for ( int i = canSee.get( a ).locX - 1; i <= canSee.get( a ).locX + 1; i++ ) {
                    for ( int j = canSee.get( a ).locY - 1; j <= canSee.get( a ).locY + 1; j++ ) {
                        if (i >= 0 && j >= 0 && i < numSquares && j < numSquares && ( i != canSee.get( a ).locX || j != canSee.get( a ).locY )) {
                            if (!hasSeen.contains( dungeon.floors.get( currentFloor ).board[i][j ])) {
                                hasSeen.add( dungeon.floors.get( currentFloor ).board[i][j ]);
                            }
                        }
                    }
                }
            }
        }
    }

    //Opens all doors in a 3x3 square around the player
    public void openDoor( ) {
        for ( int i = x - 1; i <= x + 1; i++ ) {
            for ( int j = y - 1; j <= y + 1; j++ ) {
                if (i > 0 && j > 0 && i < numSquares - 1 && j < numSquares - 1 && ( i != x || j != y )) {
                    if ( dungeon.floors.get( currentFloor ).board[i][j ].squareType == -5) {
                        dungeon.floors.get( currentFloor ).board[i][j ].isOpen = !dungeon.floors.get( currentFloor ).board[i][j ].isOpen;
                        update( );
                    }
                }
            }
        }
    }

    //kills all mobs in a 3x3 square around the player
    public void attack( ) {
        for ( int i = x - 2; i <= x + 2; i++ ) {
            for ( int j = y - 2; j <= y + 2; j++ ) {
                if (i > 0 && j > 0 && i < numSquares - 1 && j < numSquares - 1 && ( i != x || j != y )) {
                    if ( dungeon.floors.get( currentFloor ).board[i][j ].containsMob) {
                        for ( int a = dungeon.floors.get( currentFloor ).mobs.size( ) - 1; a >= 0; a-- ) {
                            if ( dungeon.floors.get( currentFloor ).mobs.get( a ).x == i && dungeon.floors.get( currentFloor ).mobs.get( a ).y == j ) {
                                dungeon.floors.get( currentFloor ).mobs.remove( a );
                                dungeon.floors.get( currentFloor ).board[i][j ].containsMob = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
