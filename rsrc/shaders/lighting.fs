#version 330

// Input vertex attributes (from vertex shader)
in vec3 fragPosition;
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;

// Input uniform values
uniform sampler2D texture0;
uniform vec4 colDiffuse;

// Output fragment color
out vec4 finalColor;

// NOTE: Add here your custom variables

#define     MAX_LIGHTS              4
#define     LIGHT_DIRECTIONAL       0
#define     LIGHT_POINT             1

struct MaterialProperty {
    vec3 color;
    int useSampler;
    sampler2D sampler;
};

struct Light {
    int enabled;
    int type;
    vec3 position;
    vec3 target;
    vec4 color;
};

// Input lighting values
uniform Light lights[MAX_LIGHTS];
uniform vec4 ambient;
uniform vec3 viewPos;
uniform vec2 lightFalloff;

void main()
{
    // Texel color fetching from texture sampler
    vec4 texelColor = texture(texture0, fragTexCoord);
    vec3 lightDot = vec3(0.0);
    vec3 normal = normalize(fragNormal);
    vec3 viewD = normalize(viewPos - fragPosition);
    vec3 specular = vec3(0.0);

    // NOTE: Implement here your fragment shader code

    for (int i = 0; i < MAX_LIGHTS; i++)
    {
        if (lights[i].enabled == 1)
        {
            vec3 light = vec3(0.0);
            
            if (lights[i].type == LIGHT_DIRECTIONAL) 
            {
                light = -normalize(lights[i].target - lights[i].position);
            }
            
            if (lights[i].type == LIGHT_POINT) 
            {
                light = normalize(lights[i].position - fragPosition);
            }
            
            float NdotL = max(dot(normal, light), 0.0);
            lightDot += lights[i].color.rgb*NdotL;

            float specCo = 0.0;
            if (NdotL > 0.0) specCo = pow(max(0.0, dot(viewD, reflect(-(light), normal))), 16); // 16 refers to shine
            specular += specCo;
        }
    }

    finalColor = (texelColor*((colDiffuse + vec4(specular, 1.0))*vec4(lightDot, 1.0)));

    if (texelColor.x != 1.0 && texelColor.y != 1.0 && texelColor.z != 1.0){
        finalColor += texelColor*ambient;
    }
    else {
        finalColor += colDiffuse*ambient;
    }

    // Gamma correction
    finalColor = pow(finalColor, vec4(1.0/2.2));

     // Distance calculation
    float dist = length(viewPos - fragPosition);

    // Exponential color falloff
    float falloffFactor = 1.0/exp((dist*lightFalloff.x)*(dist*lightFalloff.x));

    // Linear fog (less nice)
    //const float fogStart = 2.0;
    //const float fogEnd = 10.0;
    //float fogFactor = (fogEnd - dist)/(fogEnd - fogStart);

    falloffFactor = clamp(falloffFactor, 0.4, 1.0);

    vec4 lightColor = vec4(0.0, 0.0, 0.0, 1.0);

    finalColor = mix(lightColor, finalColor, falloffFactor);
}