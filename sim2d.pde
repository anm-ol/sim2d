import controlP5.*; //<>//

ControlP5 p5;
float x = width/2, y = height/2; // Initialize the position of a particle.
float g = 0., vy = 0, vx = 0; // Initialize gravity and velocities.
float[] a = {100, 100, 100}; // RGB color values.
color col = color(a[0], a[1], a[2]); // Create a color based on the RGB values.
float[] pos = new float[2]; // Initialize an array for position.
float side = 20; // Set the size of the particle.
ArrayList<Float> pathx = new ArrayList<Float>(); // Create an array list to store x-coordinates of the path.
ArrayList<Float> pathy = new ArrayList<Float>(); // Create an array list to store y-coordinates of the path.
ArrayList<body> bodies = new ArrayList<body>(); // Create an array list to store body objects.
int c=1;
void setup() {
  p5=new ControlP5(this);
  size(1200, 700); // Set up the canvas size.
  
  addGUI(p5);
  
  bodies.add(new body(width/2, height/2, 0, 0, 1)); // Create a body object and add it to the array list.
  bodies.get(0).setGravity(true);
  for (body b : bodies) {
    fill(b.c);
    b.setSize(random(15,80));
    circle(b.x, b.y, b.rad); // Display the particle on the canvas.
  }
}

void draw() {
  background(col); // Set the background color.
  disptext(bodies);
  
  if (mousePressed && !p5.isMouseOver()) {
    pathx.clear(); // Clear the x-coordinate path array.
    pathy.clear(); // Clear the y-coordinate path array.
    circle(mouseX, mouseY, side); // Display a circle at the current mouse position.
  }

  handleInterColl(bodies); // Handle interactions between bodies.
  wallColl(bodies); // Handle collisions with walls.

  pathx.add(bodies.get(bodies.size() - 1).x); // Add the x-coordinate of the last body to the path.
  pathy.add(bodies.get(bodies.size() - 1).y); // Add the y-coordinate of the last body to the path.
  
  forceupdate(getforce(bodies)); //update attractive force

  motionupdate(bodies); // Update the motion of bodies.

  for (body b : bodies) {
    
    fill(b.c);
    stroke(b.c);
    circle(b.x, b.y, b.rad); // Display the updated positions of the bodies.
  }

  drawpath(pathx, pathy); // Draw the path of the last body.
}

color randomcolor() {
  float[] a = {random(0, 256), random(0, 256), random(0, 256)}; // Generate random RGB color values.
  return color(a[0], a[1], a[2]); // Create a color based on the random RGB values.
}

void drawpath(ArrayList<Float> x, ArrayList<Float> y) {
  for (int i = 0; i < x.size() - 1; i++) {
    line(x.get(i), y.get(i), x.get(i + 1), y.get(i + 1)); // Draw a line connecting path points.
  }
}

void motionupdate(ArrayList<body> bodies) {
  for (int i = 0; i < bodies.size(); i++) {
    bodies.get(i).vy += g; // Apply gravity to the vertical velocity.
    bodies.get(i).x += bodies.get(i).vx; // Update the horizontal position.
    bodies.get(i).y += bodies.get(i).vy; // Update the vertical position.
  }
}

void wallColl(ArrayList<body> bodies) {
  for (int i = 0; i < bodies.size(); i++) {
    body b = bodies.get(i);

    if (b.x < b.rad/2) {
      b.x = b.rad/2; // Adjust position to prevent going beyond the left wall.
      b.vx *= -0.8; // Reverse horizontal velocity with some loss.
    }
    if (b.y <= b.rad/2) {
      b.y = b.rad/2; // Adjust position to prevent going beyond the top wall.
      b.vy *= -0.8; // Reverse vertical velocity with some loss.
    }
    if (b.x > width - b.rad/2) {
      b.x = width - b.rad/2; // Adjust position to prevent going beyond the right wall.
      b.vx *= -0.8; // Reverse horizontal velocity with some loss.
    }
    if (b.y > height - b.rad/2) {
      b.vx *= 0.95; // Reduce horizontal velocity near the bottom wall.
      b.y = height - b.rad/2; // Adjust position to prevent going beyond the bottom wall.
      if (b.vy < 0.5){
        b.vy = 0; // Stop vertical motion if velocity is small.
      } 
      else
        b.vy *= -0.8; // Reverse vertical velocity with some loss.

      bodies.get(i).copyparams(b);
    }
  }
}

void mouseReleased() {
  if(!p5.isMouseOver()){
    pathx.clear(); // Clear the path arrays.
    pathy.clear();
    bodies.add(new body(mouseX, mouseY, (mouseX - pmouseX) * 0.2, (mouseY - pmouseY) * 0.2, 1)); // Add a new body with user input.
    int index=bodies.size()-1;
    bodies.get(index).setGravity(true);
    bodies.get(index).setSize(random(15,80));
  }
}

void handleInterColl(ArrayList<body> bodies) {

  for (int i = 0; i < bodies.size() - 1; i++) {
    body b1 = bodies.get(i);

    for (int j = i + 1; j < bodies.size(); j++) {
      body b2 = bodies.get(j);
      float dist = (float) Math.sqrt(Math.pow((b1.x - b2.x), 2) + Math.pow(b1.y - b2.y, 2)) + 0.0001;
      float cos = (b2.x - b1.x) / dist;
      float sin = (b2.y - b1.y) / dist;

      if (dist < b1.rad/2+b2.rad/2 - 0.01) {
        float shiftx = (b1.rad/2+b2.rad/2 - dist) * cos / 2;
        float shifty = (b1.rad/2+b2.rad/2 - dist) * sin / 2;
        b2.x += shiftx;
        b1.x -= shiftx;
        b2.y += shifty;
        b1.y -= shifty;
        dist = (float) Math.sqrt(Math.pow((b1.x - b2.x), 2) + Math.pow(b1.y - b2.y, 2)) + 0.0001;
        float cosr2 = -((b2.x - b1.x) * b2.vx + (b2.y - b1.y) * b2.vy) / (dist * (float) Math.sqrt(b2.vx * b2.vx + b2.vy * b2.vy) + 0.0001);
        float cosr1 = ((b2.x - b1.x) * b1.vx + (b2.y - b1.y) * b1.vy) / (dist * (float) Math.sqrt(b1.vx * b1.vx + b1.vy * b1.vy) + 0.0001);
        float dvy = b2.vy * cosr2 - b1.vy * cosr1;
        float dvx = b2.vx * cosr2 - b1.vx * cosr1;
        float dv = 0.9 * magnitude(new float[] { dvx, dvy });
        b2.vx += dv * (b2.x - b1.x) / dist;
        b1.vx -= dv * (b2.x - b1.x) / dist;
        b2.vy += dv * (b2.y - b1.y) / dist;
        b1.vy -= dv * (b2.y - b1.y) / dist;
      }

      bodies.get(i).copyparams(b1);
      bodies.get(j).copyparams(b2);
    }
  }
}

void disptext(ArrayList<body> bod){
  float en=0;
  body bi=bod.get(bod.size()-1);
  double vx=(int)(bi.vx*100)/100d, vy=(int)(bi.vy*100)/100d;
  int count=0;
  
  for(body b:bod){
    en+=1*Math.sqrt(b.vx*b.vx+b.vy*b.vy);
    count++;
  }
  fill(0);
  textSize(20);
  text("Count: "+count,0,20);
  text("Vx: "+vx,0,40);
  text("Vy: "+vy,0,60);
  text("Energy: "+en,0,80);
}

void forceupdate(float[][] f){
  for(int i=0;i<bodies.size();i++){
    body b = bodies.get(i);
    b.vx+= f[i][0]; b.vy+= f[i][1];
    bodies.get(i).copyparams(b);
  }
}

float magnitude(float[] a) {
  float sum = 0;
  for (float i : a)
    sum += i * i;
  return (float) Math.sqrt(sum); // Calculate the magnitude of a vector.
}
