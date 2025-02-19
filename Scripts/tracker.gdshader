shader_type canvas_item;
const int MAX_BLIPS = 10; // Set the MAX_BLIPS constant in the script to the same value.
uniform vec4 line_color : source_color = vec4(0.25, 0.25, 0.25, 1.0);
uniform vec4 pulse_color : source_color = vec4(0.35, 0.5, 0.85, 1.0);
uniform vec4 blip_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool show_edges = false;
uniform float range_lines : hint_range(0.0, 10.0, 1.0) = 4.0;
uniform float sector_lines : hint_range(0.0, 10.0, 1.0) = 4.0;
uniform float line_width : hint_range(0.01, 0.1) = 0.01;
uniform float pulse : hint_range(0.0, 5.0) = 0.0;
uniform float pulse_width : hint_range(0.0, 1.0) = 0.5;
uniform float blip_size : hint_range(0.1, 0.5) = 0.1;
uniform float blip_softness : hint_range(0.1, 1.0) = 0.3;
uniform float blip_presistence : hint_range(0.1, 10.0) = 2.0;
uniform vec2 offset = vec2(0.0, 0.0);
uniform float rotation = 0.0;
uniform vec2 blips_arr[MAX_BLIPS];

float greater_than(float x, float y) {
	return max(sign(x - y), 0.0);
}

void fragment() {
// If you are making a semicircular tracker replace the following line of code with:
	//vec2 uv = vec2(UV.x * 2.0, UV.y) - 1.0;
	vec2 uv = UV * 2.0 - 1.0;

// If you want the whole motion tracker to rotate uncomment the following line of code:
//	uv *= mat2(vec2(sin(rotation), -cos(rotation)), vec2(cos(rotation), sin(rotation)));
	float a = (atan(uv.y, uv.x) + PI) / TAU;
	float l = length(uv);

//	If you do not want to render the range and sector lines remove the following line of code.
//	Or if you want to only render the range lines replace the following line of code with:		
//	COLOR.rgb = mix(COLOR.rgb, line_color.rgb, line_color.a * greater_than(mod(l, 1.0 / range_lines) * range_lines, 1.0 - line_width * range_lines));
//	Or if you only want to render the sector lines replace the following line of code with:
//	COLOR.rgb = mix(COLOR.rgb, line_color.rgb, line_color.a * greater_than(abs(mod(a, 1.0 / sector_lines) * sector_lines * 2.0 - 1.0), 1.0 - (line_width / TAU / l) * sector_lines));
	COLOR.rgb = mix(COLOR.rgb, line_color.rgb, line_color.a * max(greater_than(mod(l, 1.0 / range_lines) * range_lines, 1.0 - line_width * range_lines), greater_than(abs(mod(a, 1.0 / sector_lines) * sector_lines * 2.0 - 1.0), 1.0 - (line_width / TAU / l) * sector_lines)));

//	If you do not want to render the pulse remove the following line of code:
	COLOR.rgb = mix(COLOR.rgb, pulse_color.rgb, pulse_color.a * smoothstep(pulse - pulse_width, pulse, l) * greater_than(pulse, l));

//	If you do not want to render the blips remove the following block of code:
	for (int i = 0; i < blips_arr.length(); i++) {
		vec2 position = blips_arr[i];
// If you do not want the blips to rotate remove the following line of code:
		position *= mat2(vec2(sin(rotation), -cos(rotation)), vec2(cos(rotation), sin(rotation)));
// If you do not want the blips to move remove the following line of code:
		position -= offset;
 		float bl = length(position);
		float bd = distance(position, uv);
		COLOR.rgb = mix(COLOR.rgb, blip_color.rgb, blip_color.a * max(0.0, pow((blip_size - bd) / blip_size, blip_softness) * (greater_than(pulse, bl) - smoothstep(bl, bl + blip_presistence, pulse))));
	}

//	If you do not want the edges to be transparent remove the following line of code.
//	Or if you always want the edges to be transparent replace the following line of code with:
//	COLOR.a *= greater_than(1.0, l);
	COLOR.a *= max(sign(1.0 - l), float(show_edges));
	}