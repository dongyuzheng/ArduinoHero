class MusicNote extends Colors
{
  protected int noteLength = 100;
  protected int noteWidth = 25;
  protected int dy = -5;
  protected color noteColor;
  protected int upperLeftX = 100;
  protected int upperLeftY = 100;
  protected int bottomY = 125;
  protected float delay = 180.25;
  protected boolean isHit = false;
  protected boolean isOffScreen = false;
  protected boolean isEnergyNote = false;
  protected boolean isDragNote = false;
  protected boolean alreadyHit = false;
  protected boolean isLinkedToNext = false;
  protected boolean isUpdatedForLag = false;
  protected int cornerRadius = 5;
  protected int notePosition;

  //Constructor
  MusicNote (int nL, int nW, int ulX, int ulY, int speed, color iColor) {
    noteLength = nL;
    noteWidth = nW;
    upperLeftX = ulX;
    upperLeftY = ulY;
    bottomY = (ulY + noteWidth) / 2;
    dy = speed;
    noteColor = iColor;
    if (iColor == Green)
    {
      notePosition = 1;
    } else if (iColor == Red)
    {
      notePosition = 2;
    } else if (iColor == Yellow)
    {
      notePosition = 3;
    } else if (iColor == Blue)
    {
      notePosition = 4;
    } else if (iColor == Orange)
    {
      notePosition = 5;
    }
  }

  //Draw Method
  void display () {
    noStroke();
    fill (noteColor);
    rect(upperLeftX, upperLeftY, noteLength, noteWidth, cornerRadius);
    upperLeftY -= dy;
    bottomY -= dy;
  }

  void updateForLag () {
    if (isUpdatedForLag == false) {
      upperLeftY += dy;
      bottomY += dy;
      isUpdatedForLag = true;
    }
  }

  boolean checkIfHit () {
    if (bottomY >= 500 && bottomY <= 550)
    {
      isHit = true;
    }
    return isHit;
  }

  void noteIsHit () {
    noteWidth = 0;
    noteLength = 0;
    upperLeftX = 0;
    upperLeftY = 0;
    bottomY = 0;
    dy = 0;
    alreadyHit = true;
  }

  void noteOffScreen ()
  {
    if (upperLeftY >= 600)
    {
      isOffScreen = true;
      noteWidth = 0;
      noteLength = 0;
      upperLeftX = 0;
      upperLeftY = 0;
      bottomY = 0;
      dy = 0;
    }
  }
}

