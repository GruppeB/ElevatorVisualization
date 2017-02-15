int s=5; //Scale
int[][] data; //Timetable, loaded from .txt
int iterator=0;
int maxIt;
int N=5;
//Person[][] people=new Person[14][N];
ArrayList<ArrayList<Person>> people = new ArrayList<ArrayList<Person>>();
int[] numPeople=new int[14];
Elevator elevator=new Elevator();

void setup() {
  size(200, 650);//(40*s,130*s)
  data=importData("schedule2.txt");
  for(int floor=0;floor<14;floor++){
    people.add(new ArrayList<Person>());
  }
}

void draw() {
  drawBackground();
  text(iterator,150,630);
  for(int i=0;i<14;i++){
    text(people.get(i).size(),100+i*10,600);
  }
  elevator.update();
  elevator.drawElevator();
  drawPeople();
  
  
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

/*int[][] importData(String filename) {
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
}*/

int[][] importData(String filename) {
  String[] schedule=loadStrings(filename);
  maxIt=schedule.length;
  int[][] data=new int[maxIt][4];
  for (int i=0; i<schedule.length; i++) {
    int[] line=int(split(schedule[i], ' '));
    for (int j=0; j<4; j++) {
      data[i][j]=line[j];
    }
  }
  return data;
}

void drawPeople(){
  fill(255,0,0);
  stroke(255,0,0);
  for(int floor=0;floor<14;floor++){
    for(int i=0;i<people.get(floor).size();i++){
      people.get(floor).get(i).display();
    }
  }
}

class Person{
  float xpos,ypos,xvel,yvel;
  float N,E,S,W; //Coords of enclosure
  
  Person(float ixpos ,float iypos ,float ixvel ,float iyvel ,float iN ,float iE ,float iS ,float iW){
    xpos=ixpos;
    ypos=iypos;
    xvel=ixvel;
    yvel=iyvel;
    N=iN;
    E=iE;
    S=iS;
    W=iW;
  }
  
  Person(int floor){
    ypos=(13.5-floor)*10*s;
    xvel=random(s);
    yvel=random(s);
    if(floor==0){//Person is inside elevator
      xpos=5*s;
      N=(13-floor)*10*s;
      E=10*s;
      S=(14-floor)*10*s;
      W=0;
    }else{
      xpos=width/2;
      N=(13-floor)*10*s;
      E=width;
      S=(14-floor)*10*s;
      W=10*s;
    }
  }
  
  void setN(float i){
    N=i;
  }
  void setS(float i){
    S=i;
  }
  
  void setypos(float i){
    ypos=i;
  }
  
  void edgeCollision(){
    if(ypos<N || ypos>S){
      yvel=-1*yvel;
    }
    if(xpos<W || xpos>E){
      xvel=-1*xvel;
    }
  }
  
  void display(){
    xpos+=xvel;
    ypos+=yvel;
    edgeCollision();
    ellipse(xpos,ypos,s,s);
  }
}

class Elevator{
  float yposE, yvelE;
  
  Elevator(){
    yposE=0;
    yvelE=0;
  }
  
  void update(){
    int dest=(13-data[iterator][0])*10*s;
    if(yposE<dest){
      yvelE=s;
    }else if(yposE>dest){
      yvelE=-s;
    }else{
      yvelE=0; //<>//
      
      if(data[iterator][2]==-1){
        addPeople(data[iterator][1], data[iterator][3]);
      }else{
        movePeople(data[iterator][1], data[iterator][2], data[iterator][3]);
      }
      
      if(++iterator>=maxIt){
        iterator=0;
      }
    }
    yposE+=yvelE;
    delay(25);
  }
  
  void drawElevator() {
    stroke(0, 100, 200);
    fill(0, 100, 200);
    rect(0, yposE, 10*s, 10*s);

    for(int i=0;i<numPeople[0];i++){//Sets boundaries for people in elevator
      people.get(0).get(i).setN(yposE);
      people.get(0).get(i).S=yposE+10*s;
      people.get(0).get(i).setypos(people.get(0).get(i).ypos-yvelE);
    }
  } 
}

void addPeople(int n, int floor){
  for(int i=0;i<n;i++){
    people.get(floor).add(new Person(floor));
  }
}

void movePeople(int n, int start, int dest){
  for(int i=0;i<n;i++){
    people.get(dest).add(new Person(dest));
    people.get(start).remove(0);
  }
}