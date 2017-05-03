int s=5; //Space scale
float pv=0.5; //People velocity
float ev=0.5; //Elevator velocity
int waitTime=50; //Time elevator waits on each floor
float patience=5; //Slowness of colour change
float energicity=3; //Max velocity multiplier. 0 for constant speed
float timerDampening=5; //How slow animation runs

String filename="davidErAwzm.txt";
int itStart=2000; //Line start and end number. 0 for file start or end. 
int itEnd=0;

int timerStart=0; //Start time
int timerEnd=0; //End time.
int elevatorYStart=600;
int numElevators;
int[][] data; //Timetable, loaded from .txt
int iterator;
int maxIt;
int[] offset;
int N=5;
ArrayList<ArrayList<Person>> people = new ArrayList<ArrayList<Person>>();
ArrayList<Elevator> elevators=new ArrayList<Elevator>();
int timer;
int[] peopleInFloors=new int[13]; //How many people are on each floor

void setup() {
  data=importData(filename);
  surface.setSize((30+10*numElevators)*s, 130*s);
  makestuff();
  //doPeople();
}

void draw() {
  drawBackground();
  update();
  drawElevators();
  drawPeople();
}

void makestuff(){
  for (int floor=0; floor<13+numElevators; floor++) {
    people.add(new ArrayList<Person>());
  }
  for (int i=0; i<numElevators; i++) {
    elevators.add(new Elevator(i));
  }
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
  drawClock();
}

void drawClock(){
  fill(0);
  float clock=timer++/timerDampening;
  int w=width/2;
  text(int(clock), w-7, 15);
  int hour=int(clock/3600);
  int minute=int((clock%3600)/60);
  if(hour<10){
    text('0',w-7,30);
    text(hour,w,30);
  }else{
    text(hour,w-6,30);
  }
  text(':',w+8,30);
  if(minute<10){
    text('0',w+12,30);
    text(minute,w+19,30);
  }else{
    text(minute,w+12,30);
  }
}
int[][] importData(String filename) {
  String[] schedule=loadStrings(filename);
  int[] line=int(split(schedule[0], ' '));
  numElevators=int(line[0]); //1st line //<>//

  int[][] data=new int[schedule.length-1][1+13+2*numElevators];

  line=int(split(schedule[1], ' ')); //2nd line
  for (int i=0; i<13; i++) {
    peopleInFloors[i]=line[i];
  }

  for (int i=0; i<schedule.length-1; i++) {
    float[] line2=float(split(schedule[i+1], ' '));
    for (int j=0; j<1+13+2*numElevators; j++) {
      data[i][j]=(int)floor(line2[j]);
    }
    data[i][0]*=timerDampening;
  }

  if (itStart!=0) {
    itStart-=2;
  }
  elevatorYStart=data[itStart][1];
  if (itEnd!=0) {
      itEnd-=2;
       //End time. 0 for to EoF
  }else{
    itEnd=schedule.length-2;
  }
  timerEnd=int(data[itEnd][0]);
  timerStart=int(data[itStart][0]); //Start time
  timer=timerStart;
  maxIt=itEnd; 
  iterator=itStart;
  return data;
}

void reset() {
  iterator=itStart;
  timer=timerStart;
  for (int i=0; i<numElevators; i++) {
    elevators.get(i).yposE=elevatorYStart;
    elevators.get(i).waited=0;
    elevators.get(i).c=color(random(255), random(255), 255);
  }
  peopleInFloors=new int[13];
  for (int floor=0; floor<people.size(); floor++) {
    people.get(floor).clear();
  }
}

void mousePressed() {
  if (mouseButton==LEFT) { //<>//
    //reset();
  } else {
    for (int i=0; i<numElevators; i++) {
      elevators.get(i).c=color(random(255), random(255), 255);
    }
  }
}