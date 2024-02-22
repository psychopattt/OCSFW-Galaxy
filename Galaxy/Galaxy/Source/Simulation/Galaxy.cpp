#include "Galaxy.h"

#include "Shaders/Buffers/Texture/Texture.h"
#include "Shaders/ComputeShader/ComputeShader.h"
#include "Simulation/SimulationDrawer/SimulationDrawer.h"

Galaxy::Galaxy(int width, int height, unsigned int seed) :
	Simulation(width, height, seed) { };

void Galaxy::Initialize(int width, int height, unsigned int seed)
{
	using std::make_unique;

	Simulation::Initialize(width, height, seed);

	simDrawer = make_unique<SimulationDrawer>();
	texture = make_unique<Texture>(width, height);

	galaxyShader = make_unique<ComputeShader>("Galaxy", width, height);
	galaxyShader->SetTextureBinding("dataTexture", texture->GetId());
	galaxyShader->SetInt("height", height);
	galaxyShader->SetInt("width", width);
	galaxyShader->SetInt("seed", seed);
}

void Galaxy::Restart()
{
	texture->Clear();
}

void Galaxy::Execute()
{
	galaxyShader->Execute();
}

void Galaxy::Draw()
{
	simDrawer->Draw(texture.get());
}

Galaxy::~Galaxy() { }
