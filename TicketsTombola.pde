import processing.pdf.*;

String exampleFile = "demo/example.png";
PImage img;
final int indexBeg = 1;
final int nbDigitsForIndex = 3;
final PVector[] indexCoordinates = { new PVector(384, 450), new PVector(1280, 450)};
final int indexFontSize = 34;

final int[] nbTicketsOnPage = {2, 4}; // nb columns, nb rows (landscape format)
final int nbTicketsPerBooklet = 10;
final int nbBooklets = 8;
int nbPages = nbTicketsPerBooklet * ceil(nbBooklets * 1.0f / intArrayMultiply(nbTicketsOnPage));

final int cutLineLen = 50;

int curPage = 0;

String exportFile = "exports\\export_"+nf(indexBeg,nbDigitsForIndex)+"_"+nf((indexBeg+intArrayMultiply(nbTicketsOnPage)*nbPages-1), nbDigitsForIndex)+".pdf";



void setup() { 
  size(2851, 1984, PDF, exportFile);
  img = loadImage(exampleFile);
  PFont arial = createFont("Arial", indexFontSize);
  
  strokeWeight(1);
  stroke(128);
  fill(0);
  textFont(arial);
  textAlign(BOTTOM, LEFT);
  background(255);
  
}


void draw() {
  for(int i = 0; i < nbTicketsOnPage[0]; i++) {
    int x = i * (img.width + 2);
    for(int j = 0; j < nbTicketsOnPage[1]; j++) {
      int index = indexBeg + (curPage/nbTicketsPerBooklet) * intArrayMultiply(nbTicketsOnPage) * nbTicketsPerBooklet + i*nbTicketsPerBooklet + curPage%nbTicketsPerBooklet;
      int y = j * (img.height + 2);
      image(img, x, y);
      for(PVector vec : indexCoordinates) {
        text("N° " + nf(index, nbDigitsForIndex), vec.x+x, vec.y+y);
      }
      if(curPage % nbTicketsPerBooklet == 0) {
        line(0, y+img.height, cutLineLen, y+img.height);
        line(img.width-cutLineLen, y+img.height, img.width+cutLineLen, y+img.height);
        line(width-cutLineLen, y+img.height, width, y+img.height);
      }
    }
    if(curPage % nbTicketsPerBooklet == 0) {
      line(img.width, 0, img.width, cutLineLen);
      line(img.width, height-cutLineLen, img.width, height);
    }
  }
  
  PGraphicsPDF pdf = (PGraphicsPDF) g;  // Get the renderer

  // When finished drawing, quit and save the file
  if (curPage == nbPages-1) {
    println("Terminé !");
    println("le fichier exporté se trouve ici -> " + sketchPath() + "\\" + exportFile);
    exit();
  } else {
    curPage++;
    pdf.nextPage();  // Tell it to go to the next page
  }
}


int intArrayMultiply(int[] arr) {
  int res = 1;
  for(int el : arr) {
    res *= el;
  }
  return res;
}
