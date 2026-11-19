#version 300 es
// OLED look for an LCD panel: true blacks, deeper shadows, richer color.
// Midtones and whites stay where they are, so brightness is unchanged.
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float BLACK_CUT  = 0.060; // anything darker than this becomes pure black
const float TOE        = 0.100; // smooth roll-in just above the cut (no banding)
const float CONTRAST   = 0.26;  // midtone S-curve strength (0 = off)
const float SATURATION = 1.26;  // 1.0 = unchanged

float curve(float x) {
    float y = clamp((x - BLACK_CUT) / (1.0 - BLACK_CUT), 0.0, 1.0);
    y = (y < TOE) ? (y * y) / (2.0 * TOE) : (y - 0.5 * TOE);
    y /= (1.0 - 0.5 * TOE);
    return mix(y, smoothstep(0.0, 1.0, y), CONTRAST);
}

// Fast 4x4 Bayer ordered dither matrix (zero trigonometry, zero GPU ALU stalls)
float dither(vec2 p) {
    ivec2 ip = ivec2(mod(p, 4.0));
    const mat4 m = mat4(
         0.0, 12.0,  3.0, 15.0,
         8.0,  4.0, 11.0,  7.0,
         2.0, 14.0,  1.0, 13.0,
        10.0,  6.0,  9.0,  5.0
    );
    return (m[ip.x][ip.y] / 16.0 - 0.5) / 255.0;
}

void main() {
    vec4 px = texture(tex, v_texcoord);
    vec3 c = vec3(curve(px.r), curve(px.g), curve(px.b));
    float luma = dot(c, vec3(0.2126, 0.7152, 0.0722));
    c = clamp(mix(vec3(luma), c, SATURATION), 0.0, 1.0);
    c = clamp(c + dither(gl_FragCoord.xy) * step(0.002, luma), 0.0, 1.0);
    fragColor = vec4(c, px.a);
}
