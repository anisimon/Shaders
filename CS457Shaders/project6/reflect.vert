varying float LightIntensity; 
varying vec3 ReflectVector;

void main()
{
	vec3 ECposition = vec3( gl_ModelViewMatrix * gl_Vertex );

	vec3 eyeDir = ECposition;			// vector from eye to pt
    	vec3 normal = normalize( gl_NormalMatrix * gl_Normal );

	ReflectVector = reflect( eyeDir, normal );

#ifdef NOTDEF
	mat3 IN = gl_NormalMatrix;
	IN[0][1] = gl_NormalMatrix[1][0];
	IN[0][2] = gl_NormalMatrix[2][0];
	IN[1][0] = gl_NormalMatrix[0][1];
	IN[1][2] = gl_NormalMatrix[2][1];
	IN[2][0] = gl_NormalMatrix[0][2];
	IN[2][1] = gl_NormalMatrix[1][2];
	ReflectVector = normalize( IN * ReflectVector );

	vec3 I = ECposition;
	vec3 N = normal;
	// vec3 Q = -I + N*dot(I,N);
	vec3 R = I - 2.*N*dot(I,N);

	ReflectVector = R;
#endif


	vec3 LightPos = vec3( 5., 10., 10. );
    	LightIntensity  = 1.5 * abs( dot( normalize(LightPos - ECposition), normal ) );
	if( LightIntensity < 0.2 )
		LightIntensity = 0.2;
		
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
