int s=5; //Space scale
float pv=0.5; //People velocity
float ev=0.5; //Elevator velocity
int waitTime=50; //Time elevator waits on each floor
float patience=10; //Slowness of colour change
float energicity=3; //Max velocity multiplier. 0 for constant speed

int numElevators;
int[][] data; //Timetable, loaded from .txt
int iterator=0;
int maxIt;
int N=5;
ArrayList<ArrayList<Person>> people = new ArrayList<ArrayList<Person>>();
ArrayList<Elevator> elevators=new ArrayList<Elevator>();
//Elevator elevator=new Elevator();
int timer=0;
int[] peopleInFloors=new int[13]; //How many people are on each floor

void setup() {
  size(200, 650);//(40*s,130*s)
  if(width==200){
    data=importData("morningRush.txt");
  }else if(width==240){
    data=importData("doubleMorningRush.txt");
  }
  
  for(int floor=0;floor<13+numElevators;floor++){
    people.add(new ArrayList<Person>());
  }
  for(int i=0;i<numElevators;i++){
    elevators.add(new Elevator());
  }
}

void draw() {
  drawBackground();
  //drawColour();
  elevatorUpdate();
  for(int i=0;i<numElevators;i++){
    elevators.get(i).drawElevator();
  }
  drawPeople();
  
}

void drawColour(){
  for(int i=0;i<=255;i++){
    noStroke();
    fill(i,255-i,0);
    rect(60,2*i,50,2);
  }
}

void drawBackground() {
  stroke(0);
  fill(0);
  background(255);
  /*text("ev:"+ev,2*s,5*s);
  text("pv:"+pv,11*s,5*s);*/
  for(int i=1;i<=numElevators;i++){
    println(numElevators);
    line(10*s*i, 0, 10*s*i, height);
  }
  
  for (int i=1; i<14; i++) {
    line(0, i*s*10, width, i*s*10);
    fill(0);
    text(i, width*0.9, (130-(-5+i*10))*s);
    fill(255,0,0);
    text(peopleInFloors[i-1],width*0.9,(129-((i-1)*10))*s);
    text(people.get(i).size(),(numElevators*10+5)*s,(129-((i-1)*10))*s);
  }
  fill(0);
  text(timer++,width/2,30);
}

int[][] importData(String filename) {
  String[] schedule=loadStrings(filename);
  maxIt=schedule.length-2;
  
  
  numElevators=int(schedule[0]); //1st line //<>//
  int[][] data=new int[maxIt][3+numElevators];
  
  int[] line=int(split(schedule[1], ' ')); //2nd line
  for(int i=0;i<13;i++){
    peopleInFloors[i]=line[i];
  }
  
  for (int i=0; i<schedule.length-2; i++) { //Rest of file
    line=int(split(schedule[i+2], ' '));
    for (int j=0; j<3+numElevators; j++) {
      data[i][j]=line[j];
    }
  }
  return data;
}

void drawPeople(){
  for(int floor=0;floor<14;floor++){
    for(int i=0;i<people.get(floor).size();i++){
      people.get(floor).get(i).display(floor);
    }
  }
}

class Person{
  boolean removable=false;
  float xpos,ypos,xvel,yvel;
  float N,E,S,W; //Coords of enclosure
  color c=color(#FF0000);
  float timeWaited=0;
  
  /*Person(float ixpos ,float iypos ,float ixvel ,float iyvel ,float iN ,float iE ,float iS ,float iW){
    xpos=ixpos;
    ypos=iypos;
    xvel=ixvel;
    yvel=iyvel;
    N=iN;
    E=iE;
    S=iS;
    W=iW;
  }*/
  
  Person(int floor, boolean iRemovable, float iTime){
    removable=iRemovable;
    timeWaited=iTime;
    ypos=(13.5-floor)*10*s;
    xvel=pv*(random(s)+1);
    yvel=pv*random(s);
    if(floor==0){//Person is inside elevator
      xpos=10*s;
      ypos=elevators.get(0).yposE+5*s;
      N=(13-floor)*10*s;
      E=10*s;
      S=(14-floor)*10*s;
      W=0;
    }else{
      if(removable){
        xpos=50;
      }else{
        xpos=width;
      }
      N=(13-floor)*10*s;
      E=width;
      S=(14-floor)*10*s;
      W=10*s;
    }
  }
  
  void edgeCollision(){
    if(ypos<N || ypos>S){
      yvel=-1*yvel;
    }
    if(xpos<W || xpos>E){
      xvel=-1*xvel;
    }
  }
  
  void display(int floor){
    if(energicity==0){
      xpos+=xvel;
      ypos+=yvel;
    }else{
      xpos+=xvel*timeWaited*energicity/(patience*255);
      ypos+=yvel*timeWaited*energicity/(patience*255);
    }
    edgeCollision();
    c=color(timeWaited/patience,255-timeWaited/patience,0);
    stroke(c);
    fill(c);
    if(timeWaited++/patience>255){
      timeWaited=255*patience;
    }
    ellipse(xpos,ypos,s,s);
    if(xpos>=width&&removable){
      int rightPerson=0;
      float Xpos=0;
      for(int i=0;i<people.get(floor).size();i++){
        if(people.get(floor).get(i).xpos>=Xpos){
          rightPerson=i;
          Xpos=xpos;
        }
      }
      people.get(floor).remove(rightPerson);
      peopleInFloors[floor-1]++;
    }
  }
}

class Elevator{
  float yposE, yvelE;
  int waited=0;
  color c=color(random(255),random(255),255);
  Elevator(){
    yposE=0;
    yvelE=0;
  }
  
  void drawElevator() {
    stroke(c);
    fill(c);
    rect(0, yposE, 10*s, 10*s);

    for(int i=0;i<people.get(0).size();i++){//Sets boundaries for people in elevator
      people.get(0).get(i).N=yposE;
      people.get(0).get(i).S=yposE+10*s;
      people.get(0).get(i).ypos+=yvelE;
    }
  } 
}

void elevatorUpdate(){
  for(int i=0;i<numElevators;i++){
      int dest=(13-data[iterator][i])*10*s;
      if(elevators.get(i).yposE<dest){
        elevators.get(i).yvelE=s*ev;
      }else if(elevators.get(i).yposE>dest){
        elevators.get(i).yvelE=-s*ev;
      }else{
        elevators.get(i).yvelE=0;
        
        if(elevators.get(i).waited++!=waitTime){
          return;
        }
        elevators.get(i).waited=0; //<>//
        if(data[iterator][2]==0){
          addPeople(data[iterator][1], data[iterator][3]);
        }else{
          movePeople(data[iterator][1], data[iterator][2], data[iterator][3]);
        }
        
        if(++iterator>=maxIt){
          timer=0;
          iterator=0;
        }
      }
      elevators.get(i).yposE+=elevators.get(i).yvelE;
  }
}

void addPeople(int n, int floor){
  
  for(int i=0;i<n;i++){
    people.get(floor).add(new Person(floor, false,0));
  }
}

void deletePeople(int n, int floor){
  for(int i=0;i<n;i++){
    people.get(floor).remove(0); //<>//
  }
}

void movePeople(int n, int start, int dest){
  if(start<0){
    if(start==-1){
      start=0;
    }else{
      start=13-start;
    }
  }
  
  if(dest<0){
    if(dest==-1){
      dest=0;
    }else{
      dest=13-start;
    }
  }
  
  for(int i=0;i<n;i++){
    people.get(dest).add(new Person(dest,true,people.get(start).get(0).timeWaited));
    people.get(start).remove(0);
  }
}

/*void mousePressed(){            
  if(mouseX<10*s){                //Never use == on floating point numbers :(
    //ev=2*float(mouseY)/height;    //Elevator oscillates around destination, but never hits it.
  }else{
    pv=2*float(mouseY)/height;
  }
}*/