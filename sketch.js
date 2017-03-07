var dungeon;
var currentFloor,
    numSquares,
    squareSize,
    numFloors,
    numSquares,
    counter,
    floorAnimationCounter,
    loading,
    moveCooldown,
    nextFloorAnimation,
    firstFloorAnimation,
    moving;
var player;
var wallTextures;
var floorTextures;
var playerTexture;
var stairUpTexture;
var stairDownTexture;

//preload image assets
function preload( ) {

    wallTextures = [ ];
    //wallTextures.push(loadImage( "data/wallTexture0.jpg" ));
    floorTextures = [ ];
    //floorTextures.push(loadImage( "data/floorTexture0.jpg" ));
    //playerTexture = loadImage( "data/playerTexture.png" );
    //stairUpTexture = loadImage( "data/stairUpTexture.png" );
    //stairDownTexture = p5.Image;

}

function setup( ) {

    createCanvas( displayWidth, displayHeight );
    currentFloor = 0;
    numSquares = 0;
    squareSize = 0;
    numFloors = 0;
    numSquares = 0;
    nextFloorAnimation = false;
    firstFloorAnimation = false;
    player = null;
    moving = ' ';
    loading = 0;
    moveCooldown = 0;

    frameRate(30);

    textSize( 30 );
    noStroke( );
    //stroke(255);
    
    
    
    //loading = 10;
    newDungeon( );
}
    
function draw( ) {

    background( 0 );

    push( );
    //var scale = (numSquares)/15;
    //scale(scale);
    //translate((-player.x*squareSize) + (width/scale/2) - (230/scale/2), (-player.y*squareSize)+(height/scale/2) - (30/scale/2));
    for ( var i = 0; i < numSquares; i++ ) {
        for ( var j = 0; j < numSquares; j++ ) {
            //current square
            var curSquare = dungeon.floors[currentFloor].board[i][j ];

            //if (player.canSee.contains(curSquare) || player.hasSeen.contains(curSquare)) {
            switch ( curSquare.squareType ) {
                case 0:
                    //path
                    fill( 255 );
                    rect( i * squareSize, j * squareSize, squareSize, squareSize );
                    //image( curSquare.texture, i * squareSize, j * squareSize, squareSize, squareSize );

                    break;
                case - 1:
                    //wall
                    fill( 0 );
                    rect( i * squareSize, j * squareSize, squareSize, squareSize );
                    //image( curSquare.texture, i * squareSize, j * squareSize, squareSize, squareSize );
                    break;
                case - 2:
                    //stair down
                    fill( 150, 0, 0 );
                    break;
                case - 3:
                    //stair up
                    fill(0, 150, 0);
                    //image( stairTexture, i * squareSize, j * squareSize, squareSize, squareSize );
                    break;
                case - 5:
                    //door
                    if ( curSquare.isOpen ) {
                        fill( 150, 50, 20, 100 );
                    } else {
                        fill( 100, 50, 20 );
                    }
                    break;
                case 1:
                    //?
                    fill( 255, 100, 100 );
                    break;
                case 2:
                    //loot
                    fill( 255, 50, 50 );
                    break;
                case 3:
                    //mob
                    fill( 150, 255, 50 );
                    break;
            }

            //draw the square
            if ( curSquare.squareType != -1 && curSquare.squareType !== 0 ) {
                rect( i * squareSize, j * squareSize, squareSize, squareSize );
            }
            //darken for light level
            // if (player.canSee.contains( curSquare )) {
            //     fill(0, 0, 10, constrain( curSquare.lightLevel * 15, 0, 255 ));
            //     rect( i * squareSize, j * squareSize, squareSize, squareSize );
            //     if (curSquare.containsMob && ( player.x != i || player.y != j )) {
            //         fill( 255, 100, 0, 180 );
            //         rect( i * squareSize + ( squareSize / 8 ), j * squareSize + ( squareSize / 8 ), squareSize / 1.25, squareSize / 1.25 );
            //     }
            // } else if (player.hasSeen.contains( curSquare )) {
            //     fill(0, constrain( curSquare.lightLevel * 15, 100, 255 ));
            //     rect( i * squareSize, j * squareSize, squareSize, squareSize );
            // }

            //draw player
            // } else {
            //   fill(map(curSquare.lightLevel, 0, 10, 30, 0));
            //   rect(i*squareSize, j*squareSize, squareSize, squareSize);
            // }
        }
    }

    //fill(255, 200, 200, 10);
    //ellipse(player.x*squareSize+(squareSize/2), player.y*squareSize+(squareSize/2), 2/squareSize, 2/squareSize);
    //image( playerTexture, player.x * squareSize, player.y * squareSize, squareSize, squareSize );

    pop( );

    //up
    //rect(0, 0, 800, 50);
    ////right
    //rect(750, 0, 50, 800);
    ////down
    //rect(0, 750, 800, 50);
    ////left
    //rect(0, 0, 50, 800);
    //rect(390, 390, 20, 20);

    fill( 255, 255, 210, 150 );
    rect( width - 400, 20, 380, height - 150 );

    fill( 255 );
    //text( "Mobs: " + dungeon.floors.get( currentFloor ).mobs.size( ), width - 180, height - 120 );
    text( "Current Floor: " + ( currentFloor + 1 ), width - 320, height - 150 );
}

function newDungeon( ) {

    //floors = (int)random(7, 10);
    numFloors = 2;
    //squares = (int)random(100, 150);
    numSquares = 30;
    //make numSquares odd
    if ( numSquares % 2 === 0 ) {
        numSquares--;
    }

    //calc new squareSize
    squareSize = floor( ( height - 100 ) / numSquares );

    //reset currentFloor
    currentFloor = 0;

    //make a new dungeon
    dungeon = new Dungeon( numFloors, numSquares );
    console.log("make dungeon");
    for ( let f of dungeon.floors ) {
        // if (f.floorNum < f.numFloors - 1 && !findPath(dungeon.floors.get(f.floorNum).stairDown, dungeon.floors.get(f.floorNum).stairUp, dungeon.floors.get(f.floorNum).board)) {
        //     startUp();
        // }
        for ( var i = 0; i < numSquares; i++ ) {
            for ( var j = 0; j < numSquares; j++ ) {
                if ( dungeon.floors[f.floorNum].board[i][j ].squareType == -1) {
                    dungeon.floors[f.floorNum].board[i][j ].texture = wallTextures[(floor(random( wallTextures.length )))];
                }
                if ( dungeon.floors[f.floorNum].board[i][j ].squareType === 0) {
                    dungeon.floors[f.floorNum].board[i][j ].texture = floorTextures[(floor(random( floorTextures.length )))];
                }
            }
        }
    }

    //player = new Player(dungeon.floors.get(0).stairUp.x, dungeon.floors.get(0).stairUp.y);
    //player.update();


  function keyTyped(){
    
    if(key === 'n'){
      
      newDungeon();
      
    }
    
  }

}
