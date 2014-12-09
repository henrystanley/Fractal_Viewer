/// Parameters ///
float AntiAlias = 1.1;

/// Globals ///
String[] modes = {"Mandel", "BurningShip", "Julia"};
float[][] colors = {{0.0, 0.1, 0.0}, {0.05, 0.2, 0.15}, {0.3, 0.2, 0.0}};
PShader Fractal;
PGraphics Canvas;

/// Shader Parameters ///
int Mode = 0;
float Mag  = 4;
float jMag = 10.0;
float Xloc = -0.5;
float Yloc = 0;
float juliaXCoord = 0.3;
float juliaYCoord = -0.01;
float xcalc;
float ycalc;

/// Shader Mode & Reset Func ///
void setMode(int m) {
  background(255);
  Mode = m;
  Mag  = 4;
  jMag = 10.0;
  Xloc = -0.5;
  Yloc = 0;
  juliaXCoord = 0.3;
  juliaYCoord = -0.01;
}

/// Menu Parameters ///
int select = 0;
int menuX = 0;
int menuFull = 200;
boolean out = false;
PFont largeFont = createFont("Consolas", 30);
PFont smallFont = createFont("Consolas", 18);
int menuTimer = 0;

/// Menu Functions ///

void drawMenu() {
  /// Extend Button ///
  fill(60);
  stroke(60);
  rect(menuX, 0, 20, 20);
  stroke(255);
  if (out) {
    line(menuX+6, 10, menuX+14, 10);
    if (menuX < menuFull) {menuX += 3;}
  } else {
    line(menuX+6, 10, menuX+14, 10);
    line(menuX+10, 6, menuX+10, 14);
    if (menuX > 0) {menuX -= 3;}
  }
  
  /// Fractal Menu ///
  fill(80);
  stroke(80);
  rect(0, 0, menuX, height);
  fill(60);
  stroke(60);
  rect(0, 160+(40*select), menuX, 28); 
  fill(255);
  textSize(30);
  textFont(largeFont);
  text("Fractals", menuX-(menuFull-5), 90);
  textSize(18);
  textFont(smallFont);
  for (int i = 0; i < modes.length; i++) {
    text(modes[i], menuX-(menuFull-5), 180+(40*i));
  }
  if (menuTimer > 0) {menuTimer--;}
}

boolean onMenuButton(float x, float y) {
  return ((x < menuX+20) && (x > menuX) && (y < 20));
}

boolean onMenu(float x, float y) {
  if (menuX >= menuFull) {return ((x < menuX));}
  return false;
}
  
/// Init ///
void setup() {
  size(1000, 1000, P2D);
  Fractal = loadShader("Fractal.glsl");
  Canvas = createGraphics(int(width*AntiAlias), int(height*AntiAlias), P2D);
  setMode(0);
  Fractal.set("XSize", int(width*AntiAlias));
  Fractal.set("YSize", int(height*AntiAlias));
  Fractal.set("Iter", 100);
}

/// Render ///
void draw() {
  
  /// Shader Specific Code ///
  if (Mode == 2) {
    if (keyPressed) {
      if (keyCode == DOWN) {juliaYCoord -= 0.0001*jMag;} 
      if (keyCode == UP) {juliaYCoord += 0.0001*jMag;} 
      if (keyCode == LEFT) {juliaXCoord -= 0.0001*jMag;} 
      if (keyCode == RIGHT) {juliaXCoord += 0.0001*jMag;}
    }
  }
  if (Mode == 1) {}
  if (Mode == 0) {}
 
  /// General Fractal Rendering ///
  Fractal.set("Mode", Mode);
  Fractal.set("Mag", Mag);
  Fractal.set("Xloc", Xloc);
  Fractal.set("Yloc", Yloc);
  if (Mode == 2) {
    Fractal.set("jxCoord", juliaXCoord);
    Fractal.set("jyCoord", juliaYCoord);
  }
  
  /// Colors ///
  Fractal.set("R", colors[Mode][0]);
  Fractal.set("G", colors[Mode][1]);
  Fractal.set("B", colors[Mode][2]);
  
  Canvas.beginDraw();
  Canvas.shader(Fractal);
  Canvas.rect(0, 0, Canvas.width, Canvas.height);
  Canvas.endDraw();
  image(Canvas, 0, 0, width, height);
  
  /// Menu Stuff ///
  drawMenu();
  
  /// Controls ///
  if (mousePressed == true) {
    
    /// Menu Opening & Selecting ///
    if (onMenuButton(mouseX, mouseY)) {
      if ((out == false) && (menuX == 0)) {out = true;}
      if ((out == true) && !(menuX < menuFull)) {out = false;}
    } else if (onMenu(mouseX, mouseY)) {
        if (menuTimer <= 0) {
          menuTimer = 10;
          select = constrain(int((mouseY-160)/40), 0, modes.length-1);
          setMode(select);
        }
      }  else {
      
      /// Zooming ///
      if (mouseButton == LEFT) {
        Mag-=(Mag*0.01);
      }
      else {
        Mag+=(Mag*0.01);
      }
      xcalc = (Mag/(100*width))*((width/2)-mouseX);
      ycalc = (Mag/(100*height))*((height/2)-mouseY);
      Xloc-=xcalc;
      Yloc+=ycalc;
    }
  }
  if (keyPressed) {
    if (key == ' ') {
      Canvas.save("images/" + modes[select] +
      "_x" + int(1000*Xloc) + "_y" + int(1000*Yloc) + ".png");
    }
  }
}
