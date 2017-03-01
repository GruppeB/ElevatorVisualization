int s=5; //Space scale
float pv=0.5; //People velocity
float ev=0.5; //Elevator velocity
int waitTime=50; //Time elevator waits on each floor
float patience=5; //Slowness of colour change
float energicity=3; //Max velocity multiplier. 0 for constant speed
int timerDampening=20; //How slow animation runs

int numElevators;
int[][] data; //Timetable, loaded from .txt
int iterator;
int maxIt;
int[] offset;
int N=5;
ArrayList<ArrayList<Person>> people = new ArrayList<ArrayList<Person>>();
ArrayList<Elevator> elevators=new ArrayList<Elevator>();
//Elevator elevator=new Elevator();
int timer=0;
int[] peopleInFloors=new int[13]; //How many people are on each floor

void setup() {
  size(300, 650);//(30+10*numElevators,130)*s
  if (width==200) {
    data=importData("timeTest.txt");
  } else if (width==250) {
    data=importData("timeTest2.txt");
  }else if (width==300) {
    data=importData("timeTest3.txt");
  }
  
  for (int floor=0; floor<13+numElevators; floor++) {
    people.add(new ArrayList<Person>());
  }
  for (int i=0; i<numElevators; i++) {
    elevators.add(new Elevator(i));
  }
  doPeople();
}

void draw() {
  drawBackground();
  update();
  //elevatorUpdate();
  for (int i=0; i<numElevators; i++) {
    elevators.get(i).drawElevator();
  }
  drawPeople();
}

void drawBackground() {
  stroke(0);
  fill(0);
  background(255);
  for (int i=1; i<=numElevators; i++) {
    line(10*s*i, 0, 10*s*i, height);
  }

  for (int i=1; i<14; i++) {
    line(0, i*s*10, width, i*s*10);
    fill(0);
    text(i, width*0.9, (130-(-5+i*10))*s);
    fill(255, 0, 0);
    //text(peopleInFloors[i-1],width*0.9,(129-((i-1)*10))*s);
    text(people.get(i).size(), (numElevators*10+5)*s, (129-((i-1)*10))*s);
  }
  fill(0);
   text(timer++,width/2,30);
}

int[][] importData(String filename) {
  String[] schedule=loadStrings(filename);
  numElevators=int(schedule[0]); //1st line
  
  maxIt=schedule.length-2;
  /*maxIt=new int[numElevators]; //maxIt
   for(int i=2;i<schedule.length;i++){
   int[] line=int(split(schedule[i], ' '));
   maxIt[line[0]-1]++;
   }*/

  int[][] data=new int[schedule.length-1][1+13+2*numElevators];
  //iterator=new int[numElevators];

  int[] line=int(split(schedule[1], ' ')); //2nd line
  for (int i=0; i<13; i++) {
    peopleInFloors[i]=line[i];
  }

  /*offset=new int[numElevators];
  for (int i=0; i<numElevators; i++) {
    for (int j=i+1; j<numElevators; j++) {
      offset[j]+=maxIt[i];
    }
  }*/

  /*int[] iterations=new int[numElevators];
   for (int i=0; i<schedule.length-2; i++) { //Rest of file
   line=int(split(schedule[i+2], ' '));
   int elevatorNumber=line[0]-1;
   for (int j=0; j<4; j++) {
   data[offset[elevatorNumber]+iterations[elevatorNumber]][j]=line[j+1];
   }
   iterations[elevatorNumber]++;
   }*/
  for (int i=0; i<schedule.length-1; i++) {
    line=int(split(schedule[i+1], ' '));
    for (int j=0; j<1+13+2*numElevators; j++) {
      data[i][j]=line[j];
    }
    data[i][0]*=timerDampening;
  }
  return data;
}

void drawPeople() {
  for (int floor=0; floor<people.size(); floor++) {
    for (int i=0; i<people.get(floor).size(); i++) {
      people.get(floor).get(i).display(floor);
    }
  }
}

class Person {
  boolean removable=false;
  float xpos, ypos, xvel, yvel;
  float N, E, S, W; //Coords of enclosure
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

  Person(int floor, boolean iRemovable, float iTime) {
    removable=iRemovable;
    timeWaited=iTime;
    ypos=(13.5-floor)*10*s;
    xvel=pv*(random(s)+1);
    yvel=pv*(random(s)+1);
    if (floor==0) {//Person is inside elevator 1
      xpos=10*s;
      ypos=elevators.get(0).yposE+5*s;
      E=10*s;
      W=0;
    } else if (floor<14) {//Person is in the building
      if (removable) {
        xpos=(numElevators)*10*s;
      } else {
        xpos=width;
      }
      N=(13-floor)*10*s;
      E=width;
      S=(14-floor)*10*s;
      W=(numElevators)*10*s;
    } else {//Person is in one of the other elevators
      xpos=10*s*(floor-12);
      ypos=elevators.get(floor-13).yposE+5*s;
      E=10*s*(floor-12);
      W=10*s*(floor-13);
    }
  }

  void edgeCollision() {
    if (ypos<N || ypos>S) {
      yvel=-1*yvel;
    }
    if (xpos<W || xpos>E) {
      xvel=-1*xvel;
    }
  }

  void display(int floor) {
    if (energicity==0) {
      xpos+=xvel;
      ypos+=yvel;
    } else {
      xpos+=xvel*timeWaited*energicity/(patience*255);
      ypos+=yvel*timeWaited*energicity/(patience*255);
    }
    edgeCollision();
    c=color(timeWaited/patience, 255-timeWaited/patience, 0);
    stroke(c);
    fill(c);
    if (timeWaited++/patience>255) {
      timeWaited=255*patience;
    }
    ellipse(xpos, ypos, s, s);
    if (xpos>=width&&removable) {
      int rightPerson=0;
      float Xpos=0;
      for (int i=0; i<people.get(floor).size(); i++) {
        if (people.get(floor).get(i).xpos>=Xpos) {
          rightPerson=i;
          Xpos=xpos;
        }
      }
      people.get(floor).remove(rightPerson);
      if (floor<14) {
        peopleInFloors[floor-1]++;
      }
    }
  }
}

class Elevator {
  int numberE;
  float yposE, yvelE, xposE;
  int waited=0;
  color c=color(random(255), random(255), 255);
  Elevator(int inumberE) {
    yposE=0;
    yvelE=0;
    xposE=inumberE*10*s;
    numberE=inumberE;
    if (numberE>0) {
      numberE=13+numberE;
    }
  }

  void drawElevator() {
    stroke(c);
    fill(c);
    rect(xposE, yposE, 10*s, 10*s);
    //text(numberE, numberE*5, 10);

    for (int i=0; i<people.get(numberE).size(); i++) {//Sets boundaries for people in elevator
      people.get(numberE).get(i).N=yposE;
      people.get(numberE).get(i).S=yposE+10*s;
      people.get(numberE).get(i).ypos+=yvelE;
    }
  }
}

/*void elevatorUpdate(){
 for(int i=0;i<numElevators;i++){
 int dest=(13-data[offset[i]+iterator[i]][0])*10*s;
 if(elevators.get(i).yposE<dest){
 elevators.get(i).yvelE=s*ev;
 }else if(elevators.get(i).yposE>dest){
 elevators.get(i).yvelE=-s*ev;
 }else{
 elevators.get(i).yvelE=0;
 
 if(elevators.get(i).waited++!=waitTime){
 continue;
 }
 elevators.get(i).waited=0;
 int index=offset[i]+iterator[i];
 if(data[index][1]!=0){//People to be moved is not 0
 if(data[index][2]==0){//People arrive from building
 addPeople(data[index][1], data[index][3]);
 }else{//People move between floors and elevators
 movePeople(data[index][1], data[index][2], data[index][3]);
 }
 }
 
 if(++iterator[i]>=maxIt[i]){
 iterator[i]=0;
 }
 }
 elevators.get(i).yposE+=elevators.get(i).yvelE;
 }
 }*/

void addPeople(int n, int floor) {
  for (int i=0; i<n; i++) {
    people.get(floor).add(new Person(floor, false, 0));
  }
}

void deletePeople(int n, int floor) {
  for (int i=0; i<n; i++) {
    people.get(floor).remove(0);
  }
}

void movePeople(int n, int start, int dest) {

  if (start<0) {
    if (start==-1) {
      start=0;
    } else {
      start=12-start;
    }
  }
  
  if (dest<0) {
    if (dest==-1) {
      dest=0;
    } else {
      dest=12-dest;
    }
  }

  for (int i=0; i<n; i++) {
    people.get(dest).add(new Person(dest, true, people.get(start).get(0).timeWaited)); //<>//
    people.get(start).remove(0);
  }
}

void reset() {
  iterator=0;
  timer=0;
  for (int i=0; i<numElevators; i++) {
    elevators.get(i).yposE=0;
    elevators.get(i).waited=0;
  }
  peopleInFloors=new int[13];
  for (int floor=0; floor<people.size(); floor++) {
    people.get(floor).clear();
  }
  //doPeople();
}

void mousePressed() {            
  //reset();
}

void update(){
  for(int i=0;i<numElevators;i++){
    elevators.get(i).yvelE=float(data[iterator+1][1+i]-data[iterator][1+i])/(data[iterator+1][0]-data[iterator][0]);
    elevators.get(i).yposE+=elevators.get(i).yvelE;
  }
  if (timer>=data[iterator+1][0]) { //Next step
    if(++iterator==maxIt){
      reset();
    }
    doPeople();
  }
}

void doPeople(){
  for(int i=1+numElevators;i<1+numElevators+13;i++){//Floors
    if(data[iterator][i]>0){//Person entered floor
      addPeople(data[iterator][i], i-numElevators);
    }
    /*else if(data[iterator][i]<0){//Person went from floor to elevator
      deletePeople(data[iterator][i], i-1);
    }*/
  }
  
  for(int i=1+numElevators+13;i<1+2*numElevators+13;i++){//Elevators
    if(data[iterator][i]>0){//Person entered elevator
      movePeople(data[iterator][i], 13-data[iterator][i-numElevators-13]/50, 13+numElevators-i);
    }else if(data[iterator][i]<0){//Person exited elevator
      movePeople(abs(data[iterator][i]), 13+numElevators-i, 13-data[iterator][i-numElevators-13]/50);
    }
  }
}