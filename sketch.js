Dungeon dungeon;
var currentFloor,
    numSquares,
    squareSize,
    numLoot;
var floors,
    squares;
var counter,
    floorAnimationCounter;
var nextFloorAnimation = false,
    firstFloorAnimation = false;
var player;
var moving;
var loading;
var moveCooldown;
var wallTextures;
var floorTextures;
var playerTexture;
var stairUpTexture;
var stairDownTexture;

function setup() {

    createCanvas(600, 600);
    currentFloor = 0;
    numSquares = 0;
    squareSize = 0;
    numLoot = 0;
    floors = 0;
    squares = 0;
    counter = 0;
    nextFloorAnimation = false;
    firstFloorAnimation = false;
    player = null;
    moving = ' ';
    loading = 0;
    moveCooldown = 0;
    wallTextures = new ArrayList < p5.Image > ();
    floorTextures = new ArrayList < p5.Image > ();
    playerTexture = p5.Image;
    stairUpTexture = p5.Image;
    stairDownTexture = p5.Image;

}

function draw() {}

function Dungeon() {

    //int
    var this.numFloors;
    //int
    var this.numSquares;
    //ArrayList
    var this.floors;

    //new dungeon stores floors, squares per floor
    public Dungeon(var _numFloors, var _numSquares) {

            //number of floors
            this.numFloors = _numFloors;
            //number of squares (width and height)
            this.numSquares = _numSquares;
            //
            //floorSize = (height-100)/numSquares;
            this.floors = new ArrayList < Floor > ();

            for (var i = 0; i < numFloors; i++) {
                if (i > 0) {
                    this.floors.add(new Floor(i, numSquares, numFloors, floors.get(i - 1).stairDown));
                } else {
                    PVector entrance = new PVector();
                    entrance.x = (var)random(5, numSquares - 5);
                    entrance.y = (var)random(5, numSquares - 5);
                    floors.add(new Floor(i, numSquares, numFloors, entrance));
                }
            }
        }
    }
