varying float LightIntensity; 
varying vec3 ReflectVector;
varying vec3 RefractVector;

uniform float Mix;
uniform samplerCube ReflectUnit;
uniform samplerCube RefractUnit;

void main()
{
	vec4 WHITE = vec4( 1.,1.,1.,1. );

	vec4 refractcolor = textureCube( RefractUnit, RefractVector );
	vec4 reflectcolor = textureCube( ReflectUnit, ReflectVector );
	refractcolor = mix( refractcolor, WHITE, 0.30 );
	gl_FragColor = mix( refractcolor, reflectcolor, Mix );
}
