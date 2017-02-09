int s=5; //Scale
int[][] data;
int iterator=0;
int maxIt;
void setup() {
  size(200, 650);//(40*s,130*s)
  data=importData("schedule.txt");
}

void draw() {
  drawBackground();
  drawElevator();
  drawPeople();
  if(++iterator>=maxIt){
    iterator=0;
  }
  delay(250);
}

void drawBackground() {
  stroke(0);
  fill(0);
  background(255);
  for (int i=1; i<13; i++) {
    line(0, i*s*10, 40*s, i*s*10);
    text(i, 35*s, (130-(-5+i*10))*s);
  }
  text(13, 35*s, (130-(-5+13*10))*s);
  line(10*s, 0, 10*s, 130*s);
}

void drawElevator() {
  stroke(0, 100, 200);
  fill(0, 100, 200);
  rect(0, (13-data[iterator][0])*10*s, 10*s, 10*s);
  
  fill(255,0,0);
  stroke(255,0,0);
  for(int i=0;i<data[iterator][1];i++){
    ellipse(random(9)*s,((13-data[iterator][0])*10+1+random(6))*s,s,s);
  }
}

int[][] importData(String filename) {
  String[] schedule=loadStrings(filename);
  maxIt=schedule.length;
  int[][] data=new int[maxIt][15];
  for (int i=0; i<schedule.length; i++) {
    int[] line=int(split(schedule[i], ' '));
    for (int j=0; j<15; j++) {
      data[i][j]=line[j];
    }
  }
  return data;
}

void drawPeople(){
  for(int floor=0;floor<13;floor++){
    for(int i=0;i<data[iterator][floor+2];i++){
      fill(255,0,0);
      stroke(255,0,0);
      ellipse((12+random(20))*s,((13-1-floor)*10+1+random(6))*s,s,s);
    }
  }
}