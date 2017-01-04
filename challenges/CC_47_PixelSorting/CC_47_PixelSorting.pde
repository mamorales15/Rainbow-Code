// Daniel Shiffman
// http://codingrainbow.com
// http://patreon.com/codingrainbow
// Code for: https://youtu.be/JUDYkxU6J0o
// Last edited by: Martin Morales 1/3/17

PImage img;
PImage sorted;

void setup() {
  size(800, 400);
  
  img = loadImage("sunflower400.jpg");
  sorted = img.get();
  sorted.loadPixels();
  sortImage();
  sorted.updatePixels();
}

void draw() {
  background(0);
  image(img, 0, 0);
  image(sorted, 400, 0);
}

void sortImage() {
  sorted.pixels = sort(sorted.pixels);
  
  // Choose a gradient style
  
  //linearGradientTopToBottom();
  radialGradient();
}

/**
 * Liner gradient algorithm written by Daniel Shiffman
 * Selection sort so very slow on large images
 */
void linearGradientTopToBottom() {
  // Selection sort!
  for (int i = 0; i < sorted.pixels.length; i++) {
    float record = -1;
    int selectedPixel = i;
    for (int j = i; j < sorted.pixels.length; j++) {
      color pix = sorted.pixels[j];
      // Sort by hue
      float b = hue(pix);
      if (b > record) {
        selectedPixel = j;
        record = b;
      }
    }

    // Swap selectedPixel with i
    color temp = sorted.pixels[i];
    sorted.pixels[i] = sorted.pixels[selectedPixel];
    sorted.pixels[selectedPixel] = temp;
  }
}

/**
 * Uses an image that has already been sorted.
 * Copies that into an array of the values sorted in ascending order.
 * Loops and moves the next sorted value into one of the corners of the sorted image
 */
void radialGradient() {
  // For convenience
  int width = sorted.width;  
  int height = sorted.height;
  
  // Copy over values once.
  int[] pixValuesArray = new int[width * height];
  arrayCopy(sorted.pixels, pixValuesArray);
  
  int valueIndex = 0;  // used to iterate through sorted pixel values
  
  int totalPasses = (int) Math.ceil((double) width/2);  // passes needed to complete first row
  totalPasses += (int) (Math.ceil((double) height/2) - 1);  // passes needed to complete rows 1 -> (height/2). Only half because we do top and bottom rows at the same time.
  for(int pass = 0; pass < totalPasses; pass++){
    for(int row = 0; row < height; row++){
      if((row <= pass || row >= (height - 1) - pass)  // first pass do top-most and bottom-most rows, second pass do first two and last two rows, etc.
        && (row + width/2) > pass  // Used to skip finished rows in top half
        && row < width - (pass - (width - 1) / 2)){   // Used to skip finished rows in bottom half
        
        int firstPixIndex = -1;
        int secondPixIndex = -1;
        
        if(row < height/2) {  // Top half
          firstPixIndex = (row * width) + (pass - row);  // (row * width) -> first column of row; (pass - row) -> col offset
          secondPixIndex = ((row + 1) * width - 1) - (pass - row);  // ((row + 1) * width - 1) -> last column of row
        } else {    // Bottom half
          firstPixIndex = (row * width) + (pass - (height - 1 - row));  // (pass - (height - 1 - row)) in bottom half === (pass - row) in top half
          secondPixIndex = ((row + 1) * width - 1) - (pass - (height - 1 - row));
        }
        
        // Place next two values in the calculated indices for current row
        sorted.pixels[firstPixIndex] = pixValuesArray[valueIndex++];
        sorted.pixels[secondPixIndex] = pixValuesArray[valueIndex++];
      }
    }
  }
}