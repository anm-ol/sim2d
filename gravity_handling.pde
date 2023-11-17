float[][] getforce(ArrayList<body> bodies){
  float[][] f = new float[bodies.size()][2];
  final float fconst=1000;
  for(int i=0;i<bodies.size()-1;i++)
  {
    body b1 = bodies.get(i);
    if(!b1.grav)
      { 
        f[i][0]=0; f[i][1]=0;
        continue;
      }
    for(int j=i;j<bodies.size();j++){
      body b2 = bodies.get(j);
      if(!b2.grav)
        continue;
      float r = (float) Math.sqrt(Math.pow((b1.x - b2.x), 2) + Math.pow(b1.y - b2.y, 2)) + 0.0001;
      float fr = -fconst*b1.mass*b2.mass/(r*r);
      f[i][0] += fr*(b1.x-b2.x)/(r*b1.mass);
      f[i][1] += fr*b2.mass*(b1.y-b2.y)/(r*b1.mass);
      f[j][0] += fr*b1.mass*(b2.x-b1.x)/(r*b2.mass);
      f[j][1] += fr*b1.mass*(b2.y-b1.y)/(r*b2.mass);
    }
   
  }
  return f;
}
