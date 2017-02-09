int N=20;
int minVel=1;
int maxVel=15-1;
Person[] people=new Person[N];

void setup(){
  size(400,400);
  stroke(255,0,0);
  fill(255,0,0);
  for(int i=0;i<N;i++){
  people[i]=new Person(random(400),random(400), minVel+random(maxVel), minVel+random(maxVel), 0, width, height, 0);
  }
}

void draw(){
  background(255);
  for(int i=0;i<N;i++){
    people[i].display();
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
    ellipse(xpos,ypos,5,5);
  }
}