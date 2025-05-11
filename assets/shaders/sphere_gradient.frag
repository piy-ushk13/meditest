#version 460 core

precision highp float;

// Uniforms
uniform float iFloats[15];

// Mapping uniforms to meaningful names
#define uResolutionX iFloats[0]
#define uResolutionY iFloats[1]
#define uTime iFloats[2]
#define uBaseColorR iFloats[3]
#define uBaseColorG iFloats[4]
#define uBaseColorB iFloats[5]
#define uAccentColor1R iFloats[6]
#define uAccentColor1G iFloats[7]
#define uAccentColor1B iFloats[8]
#define uAccentColor2R iFloats[9]
#define uAccentColor2G iFloats[10]
#define uAccentColor2B iFloats[11]
#define uMetalness iFloats[12]
#define uRoughness iFloats[13]
#define uClearcoat iFloats[14]

// Outputs
out vec4 fragColor;

// Constants
const float PI = 3.14159265359;

// Noise functions
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c, -s, s, c);
    return m * v;
}

// Sphere mapping
vec3 sphereNormal(vec2 uv) {
    vec2 p = uv * 2.0 - 1.0;
    float r2 = p.x * p.x + p.y * p.y;
    if (r2 > 1.0) return vec3(0.0);

    return vec3(p, sqrt(1.0 - r2));
}

// Fresnel effect
float fresnel(float cosTheta, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main() {
    // Normalized coordinates
    vec2 uResolution = vec2(uResolutionX, uResolutionY);
    vec2 uv = gl_FragCoord.xy / uResolution;

    // Define color vectors from individual components
    vec3 uBaseColor = vec3(uBaseColorR, uBaseColorG, uBaseColorB);
    vec3 uAccentColor1 = vec3(uAccentColor1R, uAccentColor1G, uAccentColor1B);
    vec3 uAccentColor2 = vec3(uAccentColor2R, uAccentColor2G, uAccentColor2B);

    // Calculate sphere normal
    vec3 normal = sphereNormal(uv);

    // Skip non-sphere pixels
    if (length(normal) < 0.1) {
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    // Lighting setup
    vec3 lightDir1 = normalize(vec3(0.5, 0.5, 1.0));
    vec3 lightDir2 = normalize(vec3(-0.5, -0.3, 0.8));

    // Rotate normals for animation
    vec3 rotatedNormal = normal;
    rotatedNormal.xy = rotate(normal.xy, uTime * 0.2);
    rotatedNormal.yz = rotate(rotatedNormal.yz, uTime * 0.15);

    // Diffuse lighting
    float diffuse1 = max(0.0, dot(rotatedNormal, lightDir1));
    float diffuse2 = max(0.0, dot(rotatedNormal, lightDir2));

    // Gradient based on normal
    vec3 gradientColor = mix(
        uAccentColor1,
        uAccentColor2,
        smoothstep(-0.2, 1.2, rotatedNormal.x + rotatedNormal.y * 0.5)
    );

    // Fresnel for edge glow
    float viewDot = dot(normal, vec3(0.0, 0.0, 1.0));
    float fresnelFactor = fresnel(viewDot, 0.04);

    // Combine colors
    vec3 baseColor = mix(uBaseColor, gradientColor, 0.7);
    vec3 finalColor = baseColor * (diffuse1 * 0.6 + diffuse2 * 0.4 + 0.2);

    // Add edge glow
    finalColor += uBaseColor * fresnelFactor * 0.8;

    // Add clearcoat highlight
    float specular = pow(max(0.0, dot(reflect(-lightDir1, rotatedNormal), vec3(0.0, 0.0, 1.0))), 32.0);
    finalColor += vec3(1.0) * specular * uClearcoat;

    // Add subtle noise pattern
    float noise = random(rotatedNormal.xy * 10.0 + uTime * 0.1) * 0.05;
    finalColor += noise;

    // Output final color with alpha
    fragColor = vec4(finalColor, 0.95);
}
