int score = 0; //ich bin der Boss
int gitterKonstante = 20;
int spielfeldbreite = 30;
int spielfeldhoehe = 20;

int cols, rows;

boolean gameOver = false;

int xFood;
int yFood;

int[] x = new int[(spielfeldbreite-1)*(spielfeldhoehe-1)];
int[] y = new int[(spielfeldhoehe-1)*(spielfeldbreite-1)];
int laenge;
char richtung;

PImage hintergrund;

import ddf.minim.*; 
import ddf.minim.ugens.*; 
Minim m; 
AudioOutput out;
Sampler getcoinsound;
Sampler gameoversound;

void setup() {
  size((spielfeldbreite)*gitterKonstante,(spielfeldhoehe)*gitterKonstante);
  
  cols = width/gitterKonstante;
  rows = height/gitterKonstante;
  
  rectMode(CORNER); // Rechtecke werden mit    
  textAlign(CENTER);
  frameRate(10); // pro Sekunde 10 Frames
  
  xFood = int(random(1,spielfeldbreite-1));
  yFood = int(random(1,spielfeldhoehe-1));
  
  x[0] = int(random(1,1));
  y[0] = int(random(1,1));
  x[1] = x[0];
  y[1] = y[0];
  richtung = 'd';
  laenge = 2;
 
  m = new Minim(this); 
  out = m.getLineOut();
  getcoinsound = new Sampler( "getcoin.wav", 4, m ); 
  gameoversound = new Sampler( "gameover.wav", 4, m ); 
  getcoinsound.patch( out ); 
  gameoversound.patch( out );
}

void draw() {
  
 for (int i = 0; i < cols; i++) {
   for (int j = 0; j < rows; j++) {
     int a = i*gitterKonstante;
     int b = j*gitterKonstante;
     fill(255);
     stroke(0);
     rect(a,b,gitterKonstante,gitterKonstante);
     }
   } 

  if (gameOver==false) {

    cols = width/gitterKonstante;
    rows = height/gitterKonstante;
        
    fill(random(0),random(200),random(0));
    rect(xFood*gitterKonstante,yFood*gitterKonstante,gitterKonstante, gitterKonstante);
    
    bewegeSchlange(laenge);
    keineWand();
    punkteGutschreiben();
    
    if ( kollisionsKontrolle()==true ) gameOver=true;
    
    text("score="+score,25,15);
  } else {
    tint(250,150);
    image(loadImage("gameover.png"),width/4,height/4,width/2,height/3);
    textSize(30);
    fill(150);
    text("SCORE: "+score,width/2,2*(height/3)+50);
    gameoversound.trigger();
    noLoop();    
  }
}

void bewegeSchlange(int n) {  //hierbei ist n die länge der Schlange
    if (n>=1) {
      x[n] = x[n-1];
      y[n] = y[n-1];
      
      fill(0,0,0);
      rect(x[n]*gitterKonstante,y[n]*gitterKonstante,gitterKonstante, gitterKonstante);  //zeichneKörperteil(x[n],y[n]);
      
      bewegeSchlange(n-1);
    } else {
      //der Kopf wird anschließend entsprechend der Richtung bewegt.
      if (richtung == 'r') {
        x[0] = x[0]+1;
      } else if (richtung == 'l') {
        x[0] = x[0]-1;
      } else if (richtung == 'u') {
        y[0] = y[0]-1;
      } else if (richtung == 'd') {
        y[0] = y[0]+1;
      }
    }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (richtung != 'd') richtung = 'u';
      
    } else if (keyCode == DOWN) {
      if (richtung != 'u') richtung = 'd';
      
    } else if (keyCode == LEFT) {
      if (richtung != 'r') richtung = 'l';
      
    } else if (keyCode == RIGHT) {
      if (richtung != 'l') richtung = 'r';
    } 
  } 
}

void keineWand(){
 if (y[0]<0) y[0]=y[0]+(spielfeldhoehe);
 if (y[0]>spielfeldhoehe) y[0]=y[0]-(spielfeldhoehe+1);
 if (x[0]<0) x[0]=x[0]+(spielfeldbreite);
 if (x[0]>spielfeldbreite) x[0]=x[0]-(spielfeldbreite+1);
}

boolean kollisionsKontrolle(){
//SELBSTKOLISION
for (int i=1; i<laenge; i++) {
  if (x[0] == x[i] ) {    
    if (y[0] == y[i] ) {
      return true;
    }
  }
}
return false;
}

void punkteGutschreiben(){
  if ( xFood == x[0] && yFood == y[0] ) {
    score++;
    laenge++;
    neueFoodKoordinaten(laenge);
    getcoinsound.trigger();
  }
}

void neueFoodKoordinaten(int n){
  xFood = int(random(1,spielfeldbreite-1));
  yFood = int(random(1,spielfeldhoehe-1));
}

void stop()
{
  // kann so bleiben
  super.stop();
}
