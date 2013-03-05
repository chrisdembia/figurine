

// See http://asymptote.sourceforge.net/doc/Import.html
//import bsp;
import three;
import settings;
import plain;

// Include has the effect of doing a drop-in replacement of the file
// For some reason I can't get import to work unless it is in the same directory.
include "../MechanicsLibrary.asy"; 
include "../SceneGraph.asy"; 

// Helpful numbers.
real slopeLength = 5;
real slopeWidth = 5.5;
real skiLength = 3;

currentprojection=perspective( (15, 8, -15), up=Y );
// showtarget=true, autoadjust=true, center=true );

// Construct the scene...
Node scene = Node( "root", null );

// Crate a node that draws my specific plane.
Node createMyPlane(string name, real width, real height, pen pe,
        transform3 myShift=shift(0,0,0))
{
    Node n= Node(name, null);
    path3 pa =  (0,0,0)--(height,0,0)--(height,0,width)--(0,0,width)--cycle;
    n.addDrawable(PathRenderable( myShift*pa, pe));
//    n.addDrawable(SurfRenderable( surface(myShift*pa), transparent));
    return n;
}

// N frame
Node frameN = Node( "N", scene );
//frameN.addChild(createPathBasis("basisN"));
frameN.addChild(createUniformPathBasis("visbasisN", shift(0.5,0.5,0), lightgreen, "n"));
//frameN.addChild(createMyPlane("ground", slopeWidth, slopeLength, black));
Node baseLine = Node("baseline");
baseLine.addDrawable(PathRenderable((0,0,0)--(slopeLength,0,0), black));
frameN.addChild(baseLine);

//==============================================================================
// A frame
real slopeIncline = 20; // degrees.
Node frameA = Node( "A", frameN );
frameA.rotation = rotate(-slopeIncline, Z);
frameA.translation = shift(slopeLength,0,0);
//frameA.addChild(createPathBasis("basisA"));
frameA.addChild(createUniformPathBasis("visbasisA", shift(-1.1,0,0.5), lightblue, "a"));

frameA.addChild(createMyPlane("SkiSlope", slopeWidth, slopeLength, black,
    myShift=shift(-slopeLength, 0, 0)));

Node dimSlopeIncline = Node("dimSlopeIncline");
PathRenderable prDimSlopeIncline = PathRenderable( arc((0,0,0), 1.5, 90, 180,
        90, 180+slopeIncline, normal=(0,0,1)), black, "$\gamma$");
dimSlopeIncline.addDrawable(prDimSlopeIncline);
frameA.addChild(dimSlopeIncline);
//label("$A$", prDimSlopeIncline.mPath);

// Intermediate frame between A and B.
Node frameABinter = Node("ABinter", frameA);
frameABinter.translation = shift(-.40*slopeLength, 0, 0.55 * slopeWidth);
real dashedLineLength = 2.8;
frameABinter.addDrawable(PathRenderable((0,0,0)--(-dashedLineLength,0,0), gray+dashed));

//==============================================================================
// B frame
real fallangle = 60; // degrees.
Node frameB = Node("B", frameABinter);
//frameB.addChild(createPathBasis("basisB"));
frameB.addChild(createUniformPathBasis("visbasisB", shift(1.1,0,0), lightred, "b"));
Node toBbasis = Node("toBbasis");
toBbasis.addDrawable(PathRenderable((0,0,0)--(1.1,0,0), gray+dashed));
frameB.addChild(toBbasis);
frameB.rotation = rotate(-fallangle, Y);

Node dimFallAngle = Node("dimFallAngle");
dimFallAngle.addDrawable(PathRenderable(
        arc((0,0,0), 0.5, 90, 180,  90-fallangle, 180, normal=(0,-1,0)),
        black, "$\alpha$"));
frameB.addChild(dimFallAngle);

// For drawing right angle symbol.
real del = 0.1;
real binhwidth = 0.25;
real binlength = 1.5 * 2 * binhwidth;
// Crate a node that draws my specific plane.
Node createSki(string name, real skiLength)
{
    Node n= Node(name, null);
    real height = skiLength - binhwidth;
    real radius = binhwidth;
    path3 p = (0,0,0)--(0,0,2*binhwidth)--
        (0, height, 2*binhwidth)..(0, height+radius,binhwidth)..(0,height,0)--cycle;
    n.addDrawable(PathRenderable(
            shift(0, 0, -binhwidth)*p, black));
    material m = material(diffusepen=lightgray,
        emissivepen=gray(0.6), opacity=1);
    n.addDrawable(SurfRenderable(
            surface(shift(0, 0, -binhwidth)*p), m));
    //n.addDrawable(PathRenderable(
    //    (0, 0,-binhwidth-del)--(0,del,-binhwidth-del)--(0,del,-binhwidth), black));
    return n;
}
frameB.addChild(createSki("planted", skiLength));

real telemarkAngle = 20;
//==============================================================================
/*
Node frameC = Node( "Binding", frameB );
frameC.rotation = rotate(-telemarkAngle, Z);
frameC.translation = shift(0, 0.5 * skiLength, 0);

Node createBinding()
{
    Node n = Node("bindingg");
    path3 p = (0, -binlength, hwidth) -- 
        (0, 0, hwidth) --
        (0, 0, -hwidth) --
        (0, -binlength, -hwidth) -- cycle;
    n.addDrawable(SurfRenderable(surface(p), mWhite));
    return n;
}
frameC.addChild(createBinding());
*/

Node createTheFallen(string name, real height)
{
    Node n = Node(name);

    // BINDING
    real binhoff = binlength * tan(telemarkAngle * 3.14 / 180.0);
    path3 p = (0, 0, binhwidth) --
        (-binhoff, -binlength, binhwidth) --
        (-binhoff, -binlength, -binhwidth) --
        (0, 0, -binhwidth) -- cycle;
    n.addDrawable(SurfRenderable(
                shift(0,height+.5*binlength,0)*surface(p), orange));
    n.addDrawable(PathRenderable(
                shift(0,height+.5*binlength,0)*p, black));
    n.addDrawable(DotRenderable((0,height+.5*binlength,0), royalblue));
    n.addDrawable(DotRenderable((0,0,0), royalblue));
    triple bincorner = (0, height + 0.5 * binlength, -binhwidth);
    
    PathRenderable prDimTelemarkAngle = PathRenderable(
            arc(bincorner, 0.95*binlength, 90, -90,
                90, -90-telemarkAngle, normal=(0,0,1)), black, Label("$\theta$"));
    //n.addDrawable(PathRenderable(
    //            shift(bincorner)*((0,0,0)--
    //                1.2*binlength*dir(90,-90-telemarkAngle)), gray+dashed));
    n.addDrawable(prDimTelemarkAngle);

    // BODY
    triple foot = (-.5*binhoff, height,0);
    real ankleAngle = 5 * 3.14/180.;
    real kneeAngle = 75 * 3.14/180.;
    real hipAngle = 15 * 3.14/180.;
    real q1 = 90 - ankleAngle*180./3.14 + telemarkAngle;
    real q2 = 180 - ankleAngle*180./3.14 - kneeAngle*180./3.14 ;
    real q3 = hipAngle*180./3.14  + (180 - kneeAngle*180./3.14 );
    real limbLength = height / (-sin(ankleAngle) + sin(kneeAngle) +
            2/3.*sin(hipAngle));
    real tiltAng = 25*3.14/180.;
    // Comes from a formula like:
    // h = dsin(theta) + 2dsin(theta)/3 + dsin(q)
    // h = skiLength
    // d = limbLength
    // theta = ankleAngle
    // q = kneeAngle
    //real kneeAngle = asin(skiLength/limbLength - 5.0/3.0*sin(ankleAngle));
    triple knee = foot - limbLength*(cos(ankleAngle), -sin(ankleAngle), 0);
    triple hip = knee - limbLength*(cos(kneeAngle), sin(kneeAngle), 0);
    triple torsopre = hip - 2/3*limbLength*(cos(hipAngle), sin(hipAngle), 0);
    triple torso = torsopre - 2/3*limbLength*(0,0, sin(tiltAng));
    path3 p = foot -- knee -- hip -- torso;
    n.addDrawable(PathRenderable(p, black+thick));
    n.addDrawable(DotRenderable(p, royalblue));
    n.addDrawable(PathRenderable((0,0,0)--(-dashedLineLength,0,0), gray+dashed));
    n.addDrawable(PathRenderable(knee--(knee.x, 0,0), gray+dashed));
    n.addDrawable(PathRenderable(hip--(hip.x, 0,0), gray+dashed));
    n.addDrawable(PathRenderable(hip--torsopre, gray+dashed));
    n.addDrawable(PathRenderable((hip.x,0,0)--(torso.x,0,torso.z), gray+dashed));
    n.addDrawable(PathRenderable(
        (knee.x-del, 0,0)--(knee.x-del,del,0)--(knee.x,del,0), black));
    n.addDrawable(PathRenderable(
        (hip.x-del, 0,0)--(hip.x-del,del,0)--(hip.x,del,0), black));
    n.addDrawable(PathRenderable(
        (0-del, 0,0)--(0-del,del,0)--(0,del,0), black));

    // angles.
    n.addDrawable(PathRenderable(foot--(0,height+.5*binlength,0), gray+dashed));
    PathRenderable prDimAnkle = PathRenderable(
            arc(foot, .2*limbLength, 90, 90-telemarkAngle, 90,
                90-telemarkAngle+q1, normal=(0,0,1)), black,
            Label("$q_1$",align=N));
    n.addDrawable(prDimAnkle);

    PathRenderable prDimKnee = PathRenderable(
            arc(knee, .2*limbLength, 90, -ankleAngle*180/3.14, 90,
                -ankleAngle*180/3.14 - q2, normal=(0,0,1)), black,
            Label("$q_2$"));
    n.addDrawable(prDimKnee);

    PathRenderable prDimHip = PathRenderable(
            arc(hip, .2*limbLength, 90, kneeAngle*180./3.14, 90,
                180+hipAngle*180./3.14, normal=(0,0,1)), black, Label("$q_3$",
                align=N));
    n.addDrawable(prDimHip);

    PathRenderable prDimTilt = PathRenderable(
            arc((hip.x,0,0), 0.6*limbLength, 90, 180, 90+tiltAng*180./3.14,
                180, normal=(0,-1,0)), black, Label("$q_4$", align=2E));
    n.addDrawable(prDimTilt);

    n.addDrawable(SurfRenderable(shift(torso)*scale3(.1)*unitsphere, mRed, false));
    return n;
}

frameB.addChild(createTheFallen("bob", 0.5 * skiLength));

//path3 y=(0,0,0)--(0,0,1)--(1,0,1)--(1,0,0)--cycle;
//draw(y, mRed);
//filldraw(y, yellow, black);
//draw(surface(plane((0,0,0), (1, 0, 1))));

/*
real u=2.5;
real v=1;
path3 y=plane((2u,0,0),(0,2v,0),(-u,-v,0));
path3 l=rotate(90,Z)*rotate(90,Y)*y;
path3 g=rotate(90,X)*rotate(90,Y)*y;
face[] faces;
filldraw(faces.push(y),project(y),yellow);
filldraw(faces.push(l),project(l),lightgrey);
filldraw(faces.push(g),project(g),green);
add(faces);
*/

// Draw the scene
scene.render(scale3(1));

//label("$A$", frameA.getTransform() *  (0, 1, 0));

// Draw the N basis.
//drawBasis(scale3(1), 1, "N");

