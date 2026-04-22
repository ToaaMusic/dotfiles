#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;

out vec4 FragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // warm
    vec3 warm = vec3(1.03, 1.01, 0.97);
    color.rgb *= warm;

    // brightness + contrast
    float contrast = 1.05;
    float brightness = 1.12;
    color.rgb = (color.rgb - 0.5) * contrast + 0.5;
    color.rgb *= brightness;

    // saturation
    float saturation = 1.08;
    float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    color.rgb = mix(vec3(lum), color.rgb, saturation);

    // noise
    float noise = fract(sin(dot(v_texcoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
    float grain = (noise - 0.5) * 0.03;
    //color.rgb += grain * (1.0 - lum * 0.7);

    // vignette
    float dist = distance(v_texcoord, vec2(0.5));
    float vignette = 1.0 - dist * 0.28;
    vignette = smoothstep(0.3, 2.0, vignette);
    vignette = clamp(vignette, 0.88, 1.0);
    color.rgb *= vignette;

    FragColor = vec4(color.rgb, color.a);
}
