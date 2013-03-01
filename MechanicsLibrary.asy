// Note sure if we need/ should include the dependencies of this file here.
import three;


// ****************************************************************************
// Pens and Materials
// ****************************************************************************

// style of some lines... 
// perhaps these should go into the library, once we find good settings
pen medium=linewidth(1);
pen thick=linewidth(1.5);

// Define some default materials by combining standard pen colors
// These definitely need refinement
// See http://asymptote.sourceforge.net/doc/Pens.html

material mWhite = material(diffusepen=gray(0.4),       emissivepen=gray(0.6));
material mBlack = material(diffusepen=gray(0),         emissivepen=gray(0.2));

material mLightRed = material(diffusepen=lightred,     emissivepen=white, opacity=0.5);
material mMedRed   = material(diffusepen=mediumred,    emissivepen=palered, opacity=0.5);
material mRed      = material(diffusepen=red,          emissivepen=mediumred, opacity=0.5);

material mLightGreen = material(diffusepen=lightgreen, emissivepen=lightgreen, opacity=0.5);
material mMedGreen   = material(diffusepen=mediumgreen,emissivepen=mediumgreen, opacity=0.5);
material mGreen      = material(diffusepen=green,      emissivepen=green, opacity=0.5);

material mLightBlue = material(diffusepen=lightblue,   emissivepen=lightblue, opacity=0.5);
material mMedBlue   = material(diffusepen=mediumblue,  emissivepen=mediumblue, opacity=0.5);
material mBlue      = material(diffusepen=blue,        emissivepen=blue, opacity=0.5);


// ****************************************************************************
// Functions
// ****************************************************************************

// Draw a set of basis vectors
void drawBasis(transform3 t, real scale, string text ) 
{
	triple zero = (0,0,0);
	draw(t*(zero--scale*X),red+thick,Arrow3); 
	draw(t*(zero--scale*Y),green+thick,Arrow3);
	draw(t*(zero--scale*Z),blue+thick,Arrow3);
}

// Create a box with dimensions dim, with its local frame centered.
surface createCenteredBox(triple dim) {
  return scale(dim.x, dim.y, dim.z)*shift(-0.5,-0.5,-0.5)*unitcube;
}

// Draw a box with opposite corners at p1 and p2, expressed in frame t, with material m.
void drawBox(triple p1, triple p2, transform3 t, material m) {
  triple d = p2 - p1;
  draw(t*shift(-p1.x, -p1.y, -p1.z)*scale(d.x, d.y, d.z)*unitcube,m);
}
