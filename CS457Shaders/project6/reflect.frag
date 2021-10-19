varying float LightIntensity; 
varying vec3 ReflectVector;
uniform samplerCube ReflectUnit;


void main()
{
	vec4 newcolor = textureCube( ReflectUnit, ReflectVector );
	gl_FragColor = newcolor;
}
