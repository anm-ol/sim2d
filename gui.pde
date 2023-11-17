void addGUI(ControlP5 p5){
  ControlFont cf1 = new ControlFont(createFont("Arial",1),15);
  p5.setFont(cf1);
  p5.addSlider("side")
    .setSize(100,30)
    .setPosition(100,10)
    .setRange(5,200)
    .setLabel("Radius");
  p5.addSlider("g")
    .setSize(100,30)
    .setPosition(300,10)
    .setRange(0,5)
    .setLabel("Acc. due to g");
}
