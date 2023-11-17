class body{
  float x,y,vx,vy,mass;
  color c=randomcolor();
  boolean grav=false;
  float rad=side;
  body(float posx,float posy,float vx,float vy,float m){
    this.x = posx;
    this.y = posy;
    this.vx = vx;
    this.vy = vy;
    this.mass=m;
  }
  
  void setGravity(boolean b){
    this.grav = false;
  }
  
  void setSize(float r){
    this.rad=r;
    this.mass=r*(float)Math.pow(20,3)/400000;
  }
  void copyparams(body b){
    this.x = b.x;
    this.y = b.y;
    this.vx = b.vx;
    this.vy = b.vy;
    this.mass=b.mass;
  }
}
