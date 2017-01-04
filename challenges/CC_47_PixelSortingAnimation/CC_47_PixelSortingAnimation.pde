// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/JUDYkxU6J0o

PImage img;
PImage sorted;

void setup() {
  size(400, 200);
  
  img = loadImage("sunflower.jpg");
  sorted = createImage(img.width, img.height, RGB);
  sorted = img.get();
  
  sorted.loadPixels();
  sortImage();
  
}

void draw() {
  //println(frameRate);


  sorted.updatePixels();

  background(0);
  image(img, 0, 0);
  image(sorted, img.width, 0);
}

void sortImage() {
  sorted.pixels = sort(sorted.pixels);
  // Choose a gradient style
  //radialGradient();
  linearGradientTopToBottom();
}

void linearGradientTopToBottom() {
  int index = 0;
  
  // Selection sort!
  for (int n = 0; n < 10; n++) {
    float record = -1;
    int selectedPixel = index;
    for (int j = index; j < sorted.pixels.length; j++) {
      color pix = sorted.pixels[j];
      float b = brightness(pix);
      if (b > record) {
        selectedPixel = j;
        record = b;
      }
    }

    // Swap selectedPixel with i
    color temp = sorted.pixels[index];
    sorted.pixels[index] = sorted.pixels[selectedPixel];
    sorted.pixels[selectedPixel] = temp;

    if (index < sorted.pixels.length -1) {
      index++;
    }
  }
}

void radialGradient() {
  for(int pass = 1; pass <= (int) Math.ceil((double) sorted.height / 2); pass++){  // For 7 height do 4 passes; for 8 height do 4 passes
    for(int rowOffset = 0; rowOffset < pass * 2; rowOffset++){
      
    }
  }
}