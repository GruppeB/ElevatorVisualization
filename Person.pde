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

void addPeople(int n, int floor) {
  for (int i=0; i<n; i++) {
    people.get(floor).add(new Person(floor, false, 0));
  }
}

/*void deletePeople(int n, int floor) {
  for (int i=0; i<n; i++) {
    people.get(floor).remove(0);
  }
}*/

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
    if(0<start && start<14){ //Start is a floor
      if(people.get(start).size()>0){
        for(int j=0;j<people.get(start).size();j++){
          if(!people.get(start).get(j).removable){
            people.get(start).remove(j);
            break;
          }
        }
      }
    }else{ //Start is an elevator
      if(people.get(start).size()>0){
        people.get(start).remove(0);
      }
    }
    people.get(dest).add(new Person(dest, true, 0));
  }
}