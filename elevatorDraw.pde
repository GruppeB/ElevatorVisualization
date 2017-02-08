int s=5; //Scale
void setup(){
  size(200,650);//(40*s,130*s)
}

void draw(){
  drawBackground();
  drawElevator();
}

void drawBackground(){
  stroke(0);
  fill(0);
  background(255);
  for(int i=1;i<13;i++){
    line(0,i*s*10,40*s,i*s*10);
    text(i,5*s,(130-(-5+i*10))*s);
  }
  text(13,5*s,(130-(-5+13*10))*s);
  line(10*s,0,10*s,130*s);
}

void drawElevator(){
  stroke(0,100,200);
  fill(0,100,200);
  rect(0,mouseY-5*s,10*s,10*s);
}