//Instantiate objects and declare variables
Colors Color = new Colors();
GuitarUserInterface guitarUI = new GuitarUserInterface ();
String songName = "All The Small Things";
String songArtist = "Blink-182";
int score = 0;
int energyMeterValue = 0;
int comboMultiplier = 1;
int consecutiveNotes = 0;
int noteCounter = 0;
int maxCounter = 0;
int minCounter = 0;
int timer;
float wait = 150;
int initialDelay = 3250;
boolean initialDelayOver = false;
int newSTDelay;
boolean changeSTDelay = false;
String guitarInput;
String modifiedInput = "";
String sentInput = "";
String notesToHit = "";
int totalNumNotes = 1201;
MusicNote [] songNotes = new MusicNote[1201];

//Serial
import processing.serial.*;
Serial port;

//MusicPlayer
import ddf.minim.*;
AudioPlayer player;
Minim minim;//audio context

//Boolean keyHit
boolean hit1 = false;
boolean hit2 = false;
boolean hit3 = false;
boolean hit4 = false;
boolean hit5 = false;
boolean[] explode = new boolean[5];


//Adjust these values to resize the screen
int screenSizeX = 1000; //740 for guitar, 260 for song info, score, etc.
int screenSizeY = 700;

void setup() {
  size(screenSizeX, screenSizeY);
  frameRate(60);
  //sets up audio player
  minim = new Minim(this);
  player = minim.loadFile("All The Small Things.mp3", 2048);
  player.play();
  //load song notes from textfile
  String[] songNoteNumbers = loadStrings("Song.txt");
  for (int i = 0; i <= 689; i++) //690 lines in the song
  {
    notesFromFileInput(songNoteNumbers[i]);
  }
  //set up timers
  timer = millis();
  //serial setup
  port = new Serial(this, "COM8", 9600);
  port.bufferUntil('\n');
  //set up explode array
  for (int i = 0; i <= 4; i++)
  {
    explode[i] = false;
  }
}

void displaySongInfo () {
  //Displays song information
  textSize (24);
  fill (Color.White);
  text ("Now Playing:", 700, 75);
  text (songName, 700, 125);
  text (songArtist, 700, 175);
  text ("Score: ", 700, 225);
  text (str(score), 775, 225);
}

void updateGlobalVars () {
  //Updates combo multiplier / multiplier buildup
  if (comboMultiplier < 4)
  {
    if (consecutiveNotes >= 8) {
      consecutiveNotes -= 8;
      comboMultiplier +=1;
    }
  }
  //Ensures score cannot go below 0
  if (score < 0) {
    score = 0;
  }
}

void notesFromFileInput (String fileInput) {
  //loads the array with notes from the textfile
  if (fileInput.length() > 5)
  {
    if (fileInput.substring(0, 5).equals("delay")) {  
      songNotes[noteCounter-1].delay = Integer.parseInt(fileInput.substring(5, fileInput.length()));
    }
    if (fileInput.substring(0, 7).equals("stdelay")) {
      changeSTDelay = true;
      println (newSTDelay);
      newSTDelay = Integer.parseInt(fileInput.substring(7, fileInput.length()));
      if (newSTDelay == 183) {
        changeSTDelay = false;
      }
    }
  } else
  {  
    for (int i = 0; i <= fileInput.length () - 1; i++)
    {
      if (noteCounter <= totalNumNotes - 1)
      {
        if (fileInput.charAt(i) == '1')
        {
          songNotes[noteCounter] = new MusicNote(100, 25, 100, 100, -8, Color.Green);
        } else if (fileInput.charAt(i) == '2')
        {
          songNotes[noteCounter] = new MusicNote(100, 25, 210, 100, -8, Color.Red);
        } else if (fileInput.charAt(i) == '3')
        {
          songNotes[noteCounter] = new MusicNote(100, 25, 320, 100, -8, Color.Yellow);
        } else if (fileInput.charAt(i) == '4')
        {
          songNotes[noteCounter] = new MusicNote(100, 25, 430, 100, -8, Color.Blue);
        } else if (fileInput.charAt(i) == '5')
        {
          songNotes[noteCounter] = new MusicNote(100, 25, 540, 100, -8, Color.Orange);
        }
        if (i == 0 && fileInput.length() >= 2) 
        {
          songNotes[noteCounter].isLinkedToNext = true;
        }
        if (changeSTDelay == true)
        {
          songNotes[noteCounter].delay = newSTDelay;
        }
        noteCounter += 1;
      }
    }
  }
}

void serialEvent (Serial port)
{
  String input = (port.readStringUntil('\n'));

  if (input != null)
  {
    guitarInput = input;
    modifiedInput = "";
    for (int i = 0; i <= input.length () - 1; i++)
    {
      if (guitarInput.charAt(i) != '0')
      {
        if (guitarInput.charAt(i) == '1') {
          guitarUI.guitarButtonPressedDraw(1);
          hit1 = true;
        }
        if (guitarInput.charAt(i) == '2') {
          guitarUI.guitarButtonPressedDraw(2);
          hit2 = true;
        }
        if (guitarInput.charAt(i) == '3') {
          guitarUI.guitarButtonPressedDraw(3);
          hit3 = true;
        }
        if (guitarInput.charAt(i) == '4') {
          guitarUI.guitarButtonPressedDraw(4);
          hit4 = true;
        }
        if (guitarInput.charAt(i) == '5') {
          guitarUI.guitarButtonPressedDraw(5);
          hit5 = true;
        }
        modifiedInput += guitarInput.charAt(i);
      }
    }
    //Due to the fact that modifiedInput will have \n at the end
    //The program will set modifiedInput equal to the substring that comes before \n
    modifiedInput = modifiedInput.substring(0, modifiedInput.length()-2);
  }

  if (minCounter == totalNumNotes)
  {
    minCounter = totalNumNotes -1;
  }

  //Checks to see if two notes come simultaneously
  if (songNotes[minCounter].isLinkedToNext == true)
  {
    notesToHit = str(songNotes[minCounter].notePosition) + str(songNotes[minCounter+1].notePosition);
  } else
  {
    notesToHit = str(songNotes[minCounter].notePosition);
  }

  //Instant win code
  //modifiedInput = notesToHit;
  println (modifiedInput);
  println (notesToHit);

  //If input matches the correct note pattern
  if (modifiedInput.equals(notesToHit) == true) {
    songNotes[minCounter].checkIfHit();
    //Correct pattern and is hit at the right time
    if (songNotes[minCounter].isHit == true  && songNotes[minCounter].alreadyHit == false) {
      if (modifiedInput.length() == 2)
      {
        songNotes[minCounter].noteIsHit();
        songNotes[minCounter+1].noteIsHit();
        explode[songNotes[minCounter].notePosition-1] = true;
        explode[songNotes[minCounter+1].notePosition-1] = true;
        minCounter += 2;
      } else
      {
        songNotes[minCounter].noteIsHit();
        explode[songNotes[minCounter-1].notePosition-1] = true;
        minCounter += 1;
      }
      score += comboMultiplier * modifiedInput.length() * 200;
      consecutiveNotes +=  modifiedInput.length();
      modifiedInput = "";
    } else //Correct pattern but is not hit at the right time
    {
      //Checks if the notes are offscreen
      songNotes[minCounter].noteOffScreen();
      if (songNotes[minCounter].isOffScreen == true)
      {
        if (modifiedInput.length() == 2)
        {
          minCounter += 2;
        } else
        {
          minCounter += 1;
        }
        score -= modifiedInput.length() * 50;
        consecutiveNotes = 0;
        comboMultiplier = 1;
      }
    }
  } else //If the input does not equal the correct note pattern
  {
    if (modifiedInput.equals("") == false) //User sent incorrect pattern
    {
      score -= modifiedInput.length() * 50;
      consecutiveNotes = 0;
      comboMultiplier = 1;
      modifiedInput = "";
    } else //User failed to send a pattern
    {
      //Checks if notes are offscreen
      songNotes[minCounter].noteOffScreen();
      if (songNotes[minCounter].isOffScreen == true)
      {
        if (notesToHit.length() == 2)
        {
          minCounter += 2;
        } else
        {
          minCounter += 1;
        }
        score -= notesToHit.length() * 50;
        consecutiveNotes = 0;
        comboMultiplier = 1;
      }
    }
  }
}

void noteHitGraphics ()
{
  strokeWeight(10);
  if (explode[0] == true)
  {
    stroke (Color.LightGreen);
    fill (Color.White);
    rect(85, 535, 130, 55);
    explode[0] = false;
  }
  if (explode[1] == true)
  {
    stroke (Color.LightRed);
    fill (Color.White);
    rect(195, 535, 130, 55);
    explode[1] = false;
  }
  if (explode[2] == true)
  {
    stroke (Color.LightYellow);
    fill (Color.White);
    rect (305, 535, 130, 55);
    explode[2] = false;
  }
  if (explode[3] == true)
  {
    stroke (Color.LightBlue);
    fill (Color.White);
    rect (415, 535, 130, 55);
    explode[3] = false;
  }
  if (explode[4] == true)
  {
    stroke (Color.LightOrange);
    fill (Color.White);
    rect (525, 535, 130, 55);
    explode[4] = false;
  }
}

void draw() {
  background (Color.Black);
  guitarUI.displayHitBar();
  guitarUI.drawTrack();
  guitarUI.drawEnergyMeter(energyMeterValue);
  updateGlobalVars();
  guitarUI.drawComboMultiplier (comboMultiplier, consecutiveNotes);
  displaySongInfo();
  serialEvent(port);
  if (hit1 == true)
  {
    guitarUI.guitarButtonPressedDraw(1);
    hit1 = false;
  }
  if (hit2 == true)
  {
    guitarUI.guitarButtonPressedDraw(2);
    hit2 = false;
  }
  if (hit3 == true)
  {
    guitarUI.guitarButtonPressedDraw(3);
    hit3 = false;
  }
  if (hit4 == true)
  {
    guitarUI.guitarButtonPressedDraw(4);
    hit4 = false;
  }
  if (hit5 == true)
  {
    guitarUI.guitarButtonPressedDraw(5);
    hit5 = false;
  }
  noteHitGraphics();
  //Draws the notes
  if (millis() >= initialDelay)
  {
    initialDelayOver = true;
  }
  if (initialDelayOver == true)
  {
    for (int i = minCounter; i <= maxCounter-1; i++)
    {
      songNotes[i].display();
      if (songNotes[i].isLinkedToNext == true)
      {
        songNotes[i].updateForLag();
      }
    }
    //Timer determines when to send a new note/notes
    if (millis() - timer >= wait) {
      if (maxCounter <= noteCounter -1)
      {
        maxCounter +=1;
      }
      timer = millis();
    }
    if (songNotes[maxCounter-1].isLinkedToNext == true)
    {
      wait = 0;
    } else
    {
      wait = songNotes[maxCounter-1].delay;
    }
  }
}

void stop()
{
  //terminates audio player
  player.close();
  minim.stop();
  super.stop();
}

