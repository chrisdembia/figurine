struct Renderable {
	surface surf;
	material mat;
	
	void operator init(surface s, material m) 
	{
		this.surf = s;
		this.mat = m;
	}
	
	void render(transform3 t)
	{
		write("Drawing a renderable.");
		draw(t*this.surf, this.mat);
	}
}

struct Node {

	string name; 	// name of this node
	Node parent;		// parent node
	transform3 translation; // translation from parent (expressed in parent)
	transform3 rotation; // rotation from parent    ( parent_R_this )
	transform3 scaling; 	// scaling from parent      (expressed in *this*)
	Node[] children;  // child nodes
	Renderable[] renderables; // Visual geometry of this node
	
	// Constructor is defined at the bottom
	
	void addChild(Node child)
	{
		// TODO remove old parent?
		child.parent = this;
		this.children.push(child);
	}
	
	void addRenderable(Renderable r)
	{
		this.renderables.push(r);
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
		for(int i = 0; i < this.renderables.length; ++i)
		{
			this.renderables[i].render(myT);
		}
		
		// draw children
		for(int i = 0; i < this.children.length; ++i)
		{
			this.children[i].render(myT);
		}
	}
	
	void operator init(string name, Node parent) 
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
	n.addRenderable( Renderable(rotate(90,Y)*scale(0.1,0.1,1)*unitcylinder, mRed));
	n.addRenderable( Renderable(rotate(-90, X)*scale(0.1,0.1,1)*unitcylinder, mGreen));
	n.addRenderable( Renderable(scale(0.1,0.1,1)*unitcylinder, mBlue));
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