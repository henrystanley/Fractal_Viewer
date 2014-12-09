#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform int Mode;

uniform int XSize;
uniform int YSize;
uniform int Iter;
uniform float Mag;
uniform float Xloc;
uniform float Yloc;
uniform float jxCoord;
uniform float jyCoord;

uniform float R;
uniform float B;
uniform float G;


dvec2 cadd(dvec2 a, dvec2 b) {
	dvec2 s = dvec2((a.x+b.x), (a.y+b.y));
	return s;
}

dvec2 cmul(dvec2 a, dvec2 b) {
	dvec2 s = dvec2((a.x*b.x)-(a.y*b.y), (a.y*b.x)+(a.x*b.y));
	return s;
}

float cabs(dvec2 c) {
	float s = float(sqrt(c.x*c.x + c.y*c.y));
	return s;
}

double xd = Mag/XSize;
double yd = Mag/YSize;


float Fractal(int mode, int iter) {
	// Mandlebrot
	if (mode == 0) {
		int j = 0;
		double mx = (Xloc-(Mag*0.5))+(gl_FragCoord.x*xd);
		double my = (Yloc-(Mag*0.5))+(gl_FragCoord.y*yd);
		dvec2 z = dvec2(mx, my);
		dvec2 c = z;
		while (j < iter && (z.x*z.x + z.y*z.y) < 4.0) {
			z = cadd(cmul(z, z), c);
			j++;
		}
		float sm = j + 1 - log(log(cabs(z))) / log(2);
		return sm;
	}
	// Buring Ship
	if (mode == 1) {
		int j = 0;
		double mx = (Xloc-(Mag*0.5))+(gl_FragCoord.x*xd);
		double my = (Yloc-(Mag*0.5))+(gl_FragCoord.y*yd);
		dvec2 z = dvec2(mx, my);
		dvec2 c = z;
		while (j < iter && (z.x*z.x + z.y*z.y) < 4.0) {
			if (z.x < 0.0) {z.x = z.x * -1.0;}
			if (z.y > 0.0) {z.y = z.y * -1.0;}
			z = cadd(cmul(z, z), c);
			j++;
		}
		float sm = j + 1 - log(log(cabs(z))) / log(2);
		return sm;
	}
	// Julia
	if (mode = 2) {
		int j = 0;
		double mx = (Xloc-(Mag*0.5))+(gl_FragCoord.x*xd);
		double my = (Yloc-(Mag*0.5))+(gl_FragCoord.y*yd);
		dvec2 z = dvec2(mx, my);
		dvec2 c = dvec2(jxCoord, jyCoord);
		while (j < iter && (z.x*z.x + z.y*z.y) < 4.0) {
			z = cadd(cmul(z, z), c);
			j++;
		}
		float sm = j + 1 - log(log(cabs(z))) / log(2);
		return sm;
	}
}



void main(void) {
    float m = (Fractal(Mode, Iter)*0.01);  
    gl_FragColor = vec4(m+R, m+B, m+G, 1.0);
}

