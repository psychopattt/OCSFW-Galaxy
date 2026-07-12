#version 460 core

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

uniform uint seed;
uniform ivec2 size;
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

vec3 GetNeighborAverage(ivec2 position)
{
    vec3 colorAverage;

    for (int y = -1; y < 2; y++)
    {
        for (int x = -1; x < 2; x++)
        {
            ivec2 neighborPosition = ivec2(position.x + x, position.y + y);
            colorAverage += vec3(imageLoad(dataTexture, neighborPosition));
        }
    }

    return colorAverage / 9.0;
}

void RefreshSource(ivec2 position, uint state)
{
    vec3 color;

    for (int i = 0; i < color.length(); i++)
    {
        state = Random(state);
        color[i] = state / 4294967295.0;
    }

    imageStore(dataTexture, position, vec4(color, 1));
}

void UpdatePixel(ivec2 position)
{
    vec3 multiplier = vec3(1);
    vec3 neighborAverage = GetNeighborAverage(position);

    if (neighborAverage.x + neighborAverage.y + neighborAverage.z < 2.25)
    {
        for (int i = 0; i < multiplier.length(); i++)
            multiplier[i] = neighborAverage[i] > 0.9 ? 1.05 : 1.0005;
    }

    imageStore(dataTexture, position, vec4(neighborAverage * multiplier, 1));
}

void main()
{
    ivec2 position = ivec2(gl_GlobalInvocationID.xy);

    if (position.x >= size.x || position.y >= size.y)
		return;

    uint state = Random(position.y * size.x + position.x);
    bool isSource = state < 20000000;

    if (isSource)
        RefreshSource(position, state);
    else
        UpdatePixel(position);
}
