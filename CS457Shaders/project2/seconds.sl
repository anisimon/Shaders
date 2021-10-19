surface
seconds(
	float	Width = 0.10,				// square width
		Ks = 0.4,				// specular coefficient
		Kd = 0.5, 				// diffuse  coefficient
		Ka = 0.1, 				// ambient  coefficient
		Ad = 0.50,
		Bd = 0.35,
		Roughness = 0.1;			// specular roughness
	color	SpecularColor = color( 1, 1, 1 )	// specular color
)
{
	color ORANGE = color( .1, .7, .1 );

	varying vector Nf = faceforward( normalize( N ), I );
	vector V = normalize( -I );

	float up = 2. * u;
	float vp = v;
	float numinu = floor( up / Ad );
	float numinv = floor( vp / Bd );
	
	Oi = Os;	// use whatever opacity the rib file gave us
	
        color TheColor = Cs;
		//float d = 
	//if( mod( numinu+numinv, 2. ) == 0 )
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
	float r = Width/2;
	float Ar = Ad/2.;
	float Br = Bd/2.;

	float du = up - uc;
	float dv = vp - vc;
	float oldrad = sqrt( du*du + dv*dv );
	float newrad = magnitude + oldrad;
	float factor = newrad/oldrad;
	du *= factor;
	dv *= factor;

	if (  pow((du)/Ar, 2.) + pow((dv)/Br, 2.)<= 1.)
		TheColor = ORANGE;
	 else
		   Oi = color( 0.6, 0.6, 0.6 );
	Ci =        TheColor * Ka * ambient();
	Ci = Ci  +  TheColor * Kd * diffuse(Nf);
	Ci = Ci  +  SpecularColor * Ks * specular( Nf, V, Roughness );
	Ci = Ci * Oi;
}
