struct Drawable {

    void operator init()
    {
    }

    void render(transform3 t)
    {
        write("No implementation.");
    }
}

// Implemented inheritance/polymorphism to allow drawing paths as well.
// Probably there is a better way to do this. A templatized class might make
// more sense =].
struct PathRenderable {
    Drawable parent;

    path3 mPath;
    pen mPen;
    Label mLabel;

	void operator init(path3 pa, pen pe, Label L="")
	{
        parent.operator init();
        this.mPath = pa;
        this.mPen = pe;
        this.mLabel = L;
	}

	void render(transform3 t)
	{
		write("Drawing a pathrenderable.");
		draw(t*this.mPath, this.mPen);
        label(mLabel, t*this.mPath);
	}
    parent.render=render;
}

// This is the method allowing for polymorphism.
Drawable operator cast(PathRenderable child) { return child.parent; }

struct DotRenderable {
    Drawable parent;

    path3 mPath;
    pen mPen;

	void operator init(path3 pa, pen pe)
	{
        parent.operator init();
        this.mPath = pa;
        this.mPen = pe;
	}

	void render(transform3 t)
	{
		write("Drawing a pathrenderable.");
		dot(t*this.mPath, this.mPen);
	}
    parent.render=render;
}

// This is the method allowing for polymorphism.
Drawable operator cast(DotRenderable child) { return child.parent; }

// Arrow.
struct MBDArrow {
    PathRenderable parent;
    Drawable grandparent;

    arrowbar3 mArrow;
    Label mLabel;

	void operator init(triple begin, triple end, pen pe,
            arrowbar3 ar=EndArrow3(DefaultHead3, size=10, filltype=UnFill),
            Label L="")
	{
        path3 pa = begin--end;
        parent.operator init(pa, pe+thick);
        this.mArrow = ar;
        this.mLabel = L;
	}

	void render(transform3 t)
	{
		write("Drawing an MBDArrow.");
        draw(t*parent.mPath, parent.mPen, mArrow);
		//draw(t*parent.mPath, parent.mPen, Arrows3(DefaultHead3));
        label(this.mLabel, t*parent.mPath);
	}
    parent.render=render;

    // Need to use the next line to get the virtual render method to work..
    parent.parent.render=render;
}

// This is the method allowing for polymorphism.
Drawable operator cast(MBDArrow child) { return child.parent; }

struct SurfRenderable {
    Drawable parent;

	surface mSurf;
    material mMat;

	void operator init(surface s, material m)
	{
        parent.operator init();
		this.mSurf = s;
        this.mMat = m;
	}

	void render(transform3 t)
	{
		write("Drawing a surfrenderable.");
        // nolight prevents things from being dark.
		draw(t*this.mSurf, this.mMat, nolight);
	}
    parent.render=render;
}

// This is the method allowing for polymorphism.
Drawable operator cast(SurfRenderable child) { return child.parent; }

struct Node {

	string name; 	// name of this node
	Node parent;		// parent node
	transform3 translation; // translation from parent (expressed in parent)
	transform3 rotation; // rotation from parent    ( parent_R_this )
	transform3 scaling; 	// scaling from parent      (expressed in *this*)
	Node[] children;  // child nodes
	Drawable[] drawables; // Visual geometry of this node
	
	// Constructor is defined at the bottom
	
	void addChild(Node child)
	{
		// TODO remove old parent?
		child.parent = this;
		this.children.push(child);
	}
	
	void addDrawable(Drawable r)
	{
		this.drawables.push(r);
	}
	
	void setTranslation(transform3 t)
	{
		this.translation = t;
	}
	
	void setRotation(transform3 r)
	{
		this.rotation = r;
	}
	
	void setScaling(transform3 s)
	{
		this.scaling = s;
	}
	
	transform3 getTransform()
	{
		return this.translation*this.rotation*this.scaling;
	}
	
	void render(transform3 t = scale3(1))
	{	
		write("Drawing node "+this.name+".");

		transform3 myT = t*this.getTransform();
		
		// draw self
		for(int i = 0; i < this.drawables.length; ++i)
		{
			this.drawables[i].render(myT);
		}
		
		// draw children
		for(int i = 0; i < this.children.length; ++i)
		{
			this.children[i].render(myT);
		}
	}
	
	void operator init(string name, Node parent=null) 
	{
		this.name = name;
		this.parent = parent;
		if(parent != null)
			parent.addChild(this);
		
		// Set defaults for transform
		this.translation = shift(0,0,0);
		this.rotation = rotate(0, X);
		this.scaling = scale3(1);
		//this.rParent = rParent;
	}
}

//Node createVector()
//{
//	Node n = Node(null, null);
//	Renderable r = Renderable(unitcylinder, mBlack);
//	n.addRenderable( Renderable(unitcylinder, mBlack));	
//	return n;
//}

// Create a node that draws a set of basis vectors
Node createBasis(string name, real length) 
{
	write("Creating basis "+name+".");
	Node n = Node(name, null);
	//n.addChild(createVector());
	n.addDrawable( SurfRenderable(rotate(90,Y)*scale(0.1,0.1,1)*unitcylinder, mRed));
	n.addDrawable( SurfRenderable(rotate(-90, X)*scale(0.1,0.1,1)*unitcylinder, mGreen));
	n.addDrawable( SurfRenderable(scale(0.1,0.1,1)*unitcylinder, mBlue));
	return n;
}

// Create a node that draws a set of basis vectors using paths.
Node createPathBasis(string name)
{
	write("Creating basis "+name+".");
	Node n = Node(name, null);
	n.addDrawable( MBDArrow((0,0,0), (1,0,0), red));
	n.addDrawable( MBDArrow((0,0,0), (0,1,0), green));
	n.addDrawable( MBDArrow((0,0,0), (0,0,1), blue));
	return n;
}

// Create a node that draws a set of basis vectors using paths.
Node createUniformPathBasis(string name, transform3 thisShift, pen p)
{
	write("Creating basis "+name+".");
	Node n = Node(name, null);
	n.addDrawable( MBDArrow((0,0,0), (1,0,0), p));
	n.addDrawable( MBDArrow((0,0,0), (0,1,0), p));
	n.addDrawable( MBDArrow((0,0,0), (0,0,1), p));
	//n.addDrawable( MBDArrow((0,0,0), (1,0,0), p, L="$x$"));
	//n.addDrawable( MBDArrow((0,0,0), (0,1,0), p, L="$y$"));
	//n.addDrawable( MBDArrow((0,0,0), (0,0,1), p, L="$z$"));
    n.setTranslation(thisShift);
    n.setScaling(scale3(0.7));
	return n;
}


/*
// See http://asymptote.sourceforge.net/doc/Structures.html
struct RigidFrame {
  string name;
  triple x, y, z; // Local unit vectors
  triple o; // Position of origin
  
  void operator init(name, scale) {
    this.name = name;
    this.scale = scale;
  }
  
  void Rotate(RigidFrame parent, triple axis, real angle) {
  	this.x = parent.x;
  	this.y = parent.y;
  	this.z = parent.z;
	this.x = rotate(angle, Y)*X;
  }
}
*/
