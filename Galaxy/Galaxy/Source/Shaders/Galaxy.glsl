#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

uniform int width;
uniform int height;
uniform uint seed;
layout(rgba32f) restrict uniform image2D dataTexture;

uint Random(uint state)
{
	state ^= 2747636419;
	state *= 2654435769;
	state ^= state >> 16;
	state *= seed + 1;
	state *= 2654435769;
	state ^= state >> 16;
	state *= 2654435769;
	return state;
}

vec4 GetNeighborAverage(ivec2 position)
{
    vec4 colorAverage = vec4(0);

    for (int y = -1; y < 2; y++)
    {
        for (int x = -1; x < 2; x++)
        {
            ivec2 neighborPos = ivec2(position.x + x, position.y + y);
            colorAverage += imageLoad(dataTexture, neighborPos);
        }
    }

    return colorAverage / 9.0f;
}

float GetColorAverage(vec4 color)
{
    return (color.x + color.y + color.z) / 3.0f;
}

void RefreshSource(ivec2 position, uint state)
{
    float uintMax = 4294967295.0f;
    uint r = Random(state);
    uint g = Random(r);
    uint b = Random(g);

    imageStore(dataTexture, position, vec4(
        r / uintMax, g / uintMax, b / uintMax, 1.0f
    ));
}

void UpdatePixel(ivec2 position)
{
    vec4 neighborAverage = GetNeighborAverage(position);
    float colorAverage = GetColorAverage(neighborAverage);

    if (colorAverage > 0.01f)
    {
        vec4 multiplier = vec4(vec3(1.0005f), 1.0f);

        if (colorAverage < 0.75f)
        {
            for (int i = 0; i < 3; i++)
            {
                if (neighborAverage[i] > 0.9f)
                    multiplier[i] = 1.05f;
            }
        }

        imageStore(dataTexture, position, neighborAverage * multiplier);
    }
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= width || position.y >= height)
		return;

    uint state = Random(position.y * width + position.x);
    bool isSource = state < 20000000;

    if (isSource)
        RefreshSource(position, state);
    else
        UpdatePixel(position);
}
