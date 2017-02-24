class Region {

  boolean connected;
  ArrayList<Square> children;
  int[] regionColor;

  public Region(ArrayList<Square> childSquares) {

    connected = false;
    children = childSquares;
    regionColor = new int[3];
    regionColor[0] = (int)random(255);
    regionColor[1] = (int)random(255);
    regionColor[2] = (int)random(255);


    for (Square s : children) {
      s.regionColor = this.regionColor;
    }
  }

  public void connect() {
    connected = true;
    regionColor[0] = 200;
    regionColor[1] = 200;
    regionColor[2] = 200;

    for (Square s : children) {
      s.regionColor = this.regionColor;
    }
  }
}