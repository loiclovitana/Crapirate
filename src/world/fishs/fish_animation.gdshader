shader_type spatial;

const float TIME_SCALE = 2.0;
const float SIDE_TO_SIDE = 0.02;
const float PIVOT = 0.2;
const float WAVE = 0.1;
const float TWIST = 0.1;

void vertex() {
	float time = TIME *TIME_SCALE+ 2.0*PI*INSTANCE_CUSTOM.x;
	VERTEX.x += cos(time) * SIDE_TO_SIDE;
	
	float pivot_angle = cos(time) *  PIVOT;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	float body = (VERTEX.z + 0.1) / 0.2; //for a fish centered at (0, 0) with a length of 2
	//wave is a uniform float
	VERTEX.x += cos(time + body) * WAVE;
	
	float twist_angle = cos(time + body) *  TWIST;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	VERTEX.xy = twist_matrix * VERTEX.xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
