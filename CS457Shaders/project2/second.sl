displacement
secondd(
	float	Width = 0.10,				// square width
		Ramp = 0.1,				// fraction of square used in the ramp
		Height = 0.2,				// displacement height
		Ad = 0.50,
		Bd = 0.35,
		NoiseAmp = 0.00,
		DispAmp = 0.10;
)
{
	float TheHeight = 0.;			// how much displacement to apply

	float up = 2. * u;
	float vp = v;
	float numinu = floor( up / Ad ); //Ad
	float numinv = floor( vp / Bd ); //Bd
	
	point PP = point "shader" P;
	float magnitude = 0.;
	float size = 1.;
	float i;
	for( i = 0.; i < 6.0; i += 1.0 )
	{
		magnitude += ( noise( size * PP ) - 0.5 ) / size;
		size *= 2.0;
	} 
	 
	float uc = Ad *numinu + (Ad/2);
	float vc = Bd *numinv+ (Bd/2);
	float r = Width/2.;
	float Ar = Ad/2.;
	float Br = Bd/2.;
	float du = up - uc;
    float dv = vp - vc;
    float oldrad = sqrt( du*du + dv*dv );
	float newrad = magnitude + oldrad;
	float factor = newrad/oldrad;
	du *= factor;
	dv *= factor;

	float d = pow((du)/Ar, 2.) + pow((dv)/Br, 2.);//pow((up - uc)/Ar, 2.) + pow((vp - vc)/Br, 2.);
	if (  d <= 1.)
	{
		float umin = numinu*Ad;	// square boundaries in u
		float umax = umin+Ar;
		float vmin = numinv*Bd;	// square boundaries in v
		float vmax = vmin+Br;
		float distu = min( up-Ar, umax-Ar );	// dist to nearest u boundary
		float distv = min( vp-Br, vmax-Br );	// dist to nearest v boundary
		float dist = min( distu, distv )/r;	// dist to nearest boundary
		
		float t = 1. - d; //smoothstep( 0., Ramp, dist );	// 0. if dist <= 0., 1. if dist >= Ramp
		//float t = smoothstep( 0., Ramp, dist);
		TheHeight = t*Height;			// apply the blending
	}


#define DISPLACEMENT_MAPPING

	float disp = 1. - d;
	if( disp != 0. ) //disp
	{
#ifdef DISPLACEMENT_MAPPING
		P = P + normalize(N) * TheHeight;
		N = calculatenormal(P);
#else
		N = calculatenormal( P + normalize(N) * TheHeight );
#endif
	}
}