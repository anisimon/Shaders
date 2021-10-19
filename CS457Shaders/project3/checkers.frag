#version 330 compatibility

in vec4  vColor;
in float vLightIntensity;
in vec2  vST;
in vec3 vMCposition;

uniform bool  uUseST;
uniform bool  uSmooth;
uniform float uSize;
uniform vec4  uSquareColor;
uniform float uAd;
uniform float uBd;
uniform float uTol;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
uniform float uAlpha;
uniform sampler3D Noise3;


const float THREE16    = 3./16.;

float
Pulse( float value, float left, float right, float tol )
{
	float t = (  smoothstep( left-tol, left+tol, value )  -  smoothstep( right-tol, right+tol, value )  );
	return t;
}

void
main( void )
{
	float tryNoiseFreq = uNoiseFreq;
	vec3 stp = uNoiseFreq *vMCposition;
	vec4  nv  = texture( Noise3, stp );
	float n = nv.r + nv.g + nv.b + nv.a;	// 1. -> 3.
	n = n - 2.;				// -1. -> 1.
	float delta = uNoiseAmp * n;
	
	float V;
	if( uUseST )
		V = vST.t;
	else
		V = vMCposition.x;
	///////////////////////////////////////////////////////
	float	Width = 0.10,				// square width
		Ramp = 0.1,				// fraction of square used in the ramp
		Height = 0.2,				// displacement height
		Ad = 0.25,
		Bd = 0.10,
		NoiseAmp = 0.00,
		DispAmp = 0.10;
	float halfSize = uSize/2.;
	float f = fract(  uAd*(V+delta) );
	
	float TheHeight = 0.;			// how much displacement to apply



	float s = vST.s;
	float t = vST.t;
	float sp = 2. * s;		// good for spheres
	float tp = t;
	//int numins = int( sp / uSize );
	//int numint = int( tp / uSize );

	gl_FragColor = vColor;		// default color
	
	float up = 2. * s;
	float vp = t;
	up += delta;
	vp += delta;
	float numins = floor( up / uAd ); //Ad
	float numint = floor( vp / uBd ); //Bd
	
	//point PP = point P; //point "shader" P;
	float magnitude = 0.;
	float size = 1.;
	float i;

	
	float uc = uAd *numins + (uAd/2);
	float vc = uBd *numint+ (uBd/2);
	float r = Width/2.;
	float Ar = uAd/2.;
	float Br = uBd/2.;
	float du = up - uc;
    float dv = vp - vc;
    float oldrad = sqrt( du*du + dv*dv );
	float newrad = magnitude + oldrad;
	float factor = newrad/oldrad;
	du *= factor;
	dv *= factor;

	float d = pow((du)/Ar, 2.) + pow((dv)/Br, 2.);

	if (d <= 1.)
	{
		if( uSmooth )
		{
			//float t = 1. - d;//this is if you want the inverse smooth shading
			float t= smoothstep( 1.-uTol, 1.+uTol, d );
			gl_FragColor = mix( uSquareColor, vColor, t );
			TheHeight = t*Height;
			V = vST.t;
		}
		else
		{
			gl_FragColor = uSquareColor;
			V = vMCposition.x;
		}
	}
	if(gl_FragColor == vColor){
		gl_FragColor.w = uAlpha;
		if (uAlpha == 0){
			discard;
		}
	}

	
	if( f >= d - uTol )
	{
		t = smoothstep( 1.-uTol, 1.+uTol, d  );
		gl_FragColor = mix( uSquareColor, vColor, t );
	}
	gl_FragColor.rgb *= vLightIntensity;	// apply lighting model
}
