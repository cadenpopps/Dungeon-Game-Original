class Region {

  boolean connected;
  ArrayList<Square> children;


  //makes a new region that is not connected, and has an arraylist of childsquares
  public Region(ArrayList<Square> childSquares) {
    connected = false;
    children = childSquares;
  }


  //connects this region
  public void connect() {
    connected = true;
  }
}