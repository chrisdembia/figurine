// Most functions lifted from three.js
struct Quaternion {
	real w, x, y, z;
	
	void setFromAxisAngle( triple axis, real angle )
	{
		// from http://www.euclideanspace.com/maths/geometry
		//             /rotations/conversions/angleToQuaternion/index.htm
		// axis have to be normalized

		real halfAngle = angle / 2;
		real s = sin( halfAngle );

		this.x = axis.x * s;
		this.y = axis.y * s;
		this.z = axis.z * s;
		this.w = cos( halfAngle );
	}
	
	real length () 
	{
		return sqrt( this.x * this.x + this.y * this.y 
					+ this.z * this.z + this.w * this.w );
	}
	
	void normalize ()
	{
		real l = this.length();
		if ( l == 0 ) {
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.w = 1;
		} else {
			l = 1 / l;
			this.x = this.x * l;
			this.y = this.y * l;
			this.z = this.z * l;
			this.w = this.w * l;
		}
	}
	
	transform3 getTransform3()
	{
		// to axis-angle
		real angle = 2*acos(this.w);
		real oneOverSinAngleOver2 = 1 / sin(angle/2);
		real l1 = this.x * oneOverSinAngleOver2;
		real l2 = this.y * oneOverSinAngleOver2;
		real l3 = this.z * oneOverSinAngleOver2;
		return rotate(angle, (l1, l2, l3));
	}	
}