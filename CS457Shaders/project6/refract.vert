varying float LightIntensity; 
varying vec3 RefractVector;
varying vec3 ReflectVector;
uniform float Eta;

void main()
{
	vec3 ECposition = vec3( gl_ModelViewMatrix * gl_Vertex );

	vec3 eyeDir = normalize( ECposition );			// vector from eye to pt
    	vec3 normal = normalize( gl_NormalMatrix * gl_Normal );
	RefractVector = refract( eyeDir, normal, Eta );
	ReflectVector = reflect( eyeDir, normal );

	vec3 LightPos = vec3( 5., 10., 10. );
    	LightIntensity  = 1.5 * abs( dot( normalize(LightPos - ECposition), normal ) );
	if( LightIntensity < 0.2 )
		LightIntensity = 0.2;
		
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
