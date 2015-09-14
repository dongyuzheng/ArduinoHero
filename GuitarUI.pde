class GuitarUserInterface extends Colors
{

  //Constructor
  GuitarUserInterface ()
  {
  }

  //Draws the HitBar
  void displayHitBar () {
    strokeWeight (2);
    stroke (Green);
    fill (DarkGreen);
    rect(100, 550, 100, 25); //green
    stroke (Red);
    fill (DarkRed);
    rect(210, 550, 100, 25); //red
    stroke (Yellow);
    fill (DarkYellow);
    rect (320, 550, 100, 25); //yellow
    stroke (Blue);
    fill (DarkBlue);
    rect (430, 550, 100, 25); //blue
    stroke (Orange);
    fill (DarkOrange);
    rect (540, 550, 100, 25); //orange
    stroke (Grey);
    fill (White);
    rect(201, 543, 9, 39); //seperators
    rect(311, 543, 9, 39);
    rect(421, 543, 9, 39);
    rect(531, 543, 9, 39);
  }

  void drawTrack () {
    strokeWeight (1);
    line (205, 543, 205, 0);
    line (315, 543, 315, 0);
    line (425, 543, 425, 0);
    line (535, 543, 535, 0);
    line (95, 543, 95, 0);
    line (645, 543, 645, 0);
  }

  void drawEnergyMeter (int eM) {
    strokeWeight(2);
    stroke (White);
    fill (Color.Black);
    rect (100, 600, 540, 20);
    stroke (Gold);
    fill (Gold);
    if (eM == 1) {
      rect (102, 602, 134, 16);
    } else if (eM == 2) {
      rect (102, 602, 268, 16);
    } else if (eM == 3) {
      rect (102, 602, 402, 16);
    } else if (eM == 4) {
      rect (102, 602, 536, 16);
    }
  }

  void drawComboMultiplier (int cM, int numNotes)
  {
    float percentToNextCombo = (numNotes * PI) / 4;

    strokeWeight (2);
    stroke (Grey);
    fill (Blue);
    rect (370, 620, 80, 37);
    textSize (32);
    fill (White);
    noStroke ();
    text (str(cM), 400, 650);
    textSize (24);
    text ("x", 425, 640);
    stroke (Grey);
    fill (Black);
    ellipse (370, 625, 50, 50);
    fill (White);
    arc(370, 625, 50, 50, 0, percentToNextCombo, PIE);
    stroke (Black);
    fill (Black);
    ellipse (370, 625, 10, 10);
  }

  void guitarButtonPressedDraw (int keyNum) {
    strokeWeight (2);
    stroke (White);
    if (keyNum == 1) {
      fill (LightGreen);
      rect(95, 545, 110, 35); //green
    } else if (keyNum == 2) {
      fill (LightRed);
      rect(205, 545, 110, 35); //red
    } else if (keyNum == 3) {
      fill (LightYellow);
      rect (315, 545, 110, 35); //yellow
    } else if (keyNum == 4) {
      fill (LightBlue);
      rect (425, 545, 110, 35); //blue
    } else if (keyNum == 5) {
      fill (LightOrange);
      rect (535, 545, 110, 35); //orange
    }
  }
}

