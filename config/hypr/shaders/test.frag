#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;

out vec4 FragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // === 1. 降低白点，减少刺眼感 ===
    // 高光部分稍微压暗，让白色变成柔和的乳白
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    float highlightReduce = smoothstep(0.7, 1.0, luminance) * 0.08;
    color.rgb = mix(color.rgb, color.rgb * 0.92, highlightReduce);

    // === 2. 微微提亮暗部，保留细节 ===
    float shadowLift = (1.0 - smoothstep(0.0, 0.25, luminance)) * 0.04;
    color.rgb = mix(color.rgb, color.rgb + 0.04, shadowLift);

    // === 3. 极淡暖灰调，降低蓝光刺激 ===
    // 比你的原版更淡，几乎看不出但眼睛会舒服
    vec3 warmTint = vec3(1.01, 0.995, 0.975);
    color.rgb *= warmTint;

    // === 4. 非常克制的对比度 ===
    // 不拉升对比度，反而略微压缩
    float contrast = 0.98;
    color.rgb = (color.rgb - 0.5) * contrast + 0.5;

    // === 5. 柔和的边缘过渡 ===
    // 极浅的高斯式暗角，比你的原版更平滑
    vec2 centered = v_texcoord - 0.5;
    float dist = dot(centered, centered) * 0.5;
    float vignette = 1.0 - dist * 0.12;
    color.rgb *= vignette;

    FragColor = vec4(color.rgb, color.a);
}
