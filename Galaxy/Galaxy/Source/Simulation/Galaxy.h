#pragma once

#include <memory>

#include "Simulation/Simulation.h"

using std::unique_ptr;

class Galaxy : public Simulation
{
	public:
		Galaxy(int width, int height, unsigned int seed = 0);
		void Initialize(int width, int height, unsigned int seed = 0) override;
		void Restart() override;
		void Execute() override;
		void Draw() override;
		~Galaxy();

	private:
		unique_ptr<class Texture> texture;
		unique_ptr<class SimulationDrawer> simDrawer;
		unique_ptr<class ComputeShader> galaxyShader;
};
