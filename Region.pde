class Region {

  boolean connected;
  ArrayList<Square> children;


  //makes a new region that is not connected, and has an arraylist of childsquares
  public Region(ArrayList<Square> _children) {
    connected = false;
    children = _children;
  }


  //connects this region
  public void connect() {
    connected = true;
  }
}