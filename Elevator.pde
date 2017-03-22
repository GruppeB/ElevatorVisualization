class Elevator {
  int numberE;
  float yposE, yvelE, xposE;
  int waited=0;
  color c=color(random(255), random(255), 255);
  Elevator(int inumberE) {
    yposE=elevatorYStart;
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

void update(){
  int time=data[iterator+1][0]-data[iterator][0];
  if(time!=0){
    for(int i=0;i<numElevators;i++){
      elevators.get(i).yvelE=float(data[iterator+1][1+i]-data[iterator][1+i])/time;
      elevators.get(i).yposE+=elevators.get(i).yvelE;
    }
    if (timer>=data[iterator+1][0]){
      doPeople();
      iterator++;
    }
  }else{
    while(data[iterator][0]==timer-1){
      for(int i=0;i<numElevators;i++){
        elevators.get(i).yposE=data[iterator+1][i+1];
        int elevatorIndex=0;
        if(i>0){
          elevatorIndex+=13;
        }
        for(int j=0;j<people.get(elevatorIndex).size();j++){
          people.get(elevatorIndex).get(j).ypos+=data[iterator+1][i+1]-data[iterator][i+1];
        }
      }
      doPeople();
      iterator++;
    }
    //iterator--;
  }
  
  if (timer>=data[iterator+1][0]) { //Next step
    if(iterator>=maxIt || (timer>=timerEnd && timerEnd!=0)){
      reset();
    }
    /*if(time!=0){
      doPeople();
    }*/
  }
}

void doPeople(){
  for(int i=1+numElevators;i<1+numElevators+13;i++){//Floors
    if(data[iterator][i]>0){//Person entered floor
      addPeople(data[iterator][i], i-numElevators);
    }
  }
  
  for(int i=1+numElevators+13;i<1+2*numElevators+13;i++){//Elevators
    if(data[iterator][i]>0){//Person entered elevator
      movePeople(data[iterator][i], 13-data[iterator][i-numElevators-13]/50, 13+numElevators-i);
    }else if(data[iterator][i]<0){//Person exited elevator
      movePeople(abs(data[iterator][i]), 13+numElevators-i, 13-data[iterator][i-numElevators-13]/50);
    }
  }
}

void drawElevators(){
  for (int i=0; i<numElevators; i++) {
    elevators.get(i).drawElevator();
  }
}