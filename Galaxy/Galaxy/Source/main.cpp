#include "Simulation/Galaxy.h"
#include "OCSFW.h"

int main()
{
	Galaxy simulation = Galaxy(2560, 1440);

	OCSFW(&simulation)
		.WithTitle("Galaxy")
		.Run();

	return EXIT_SUCCESS;
}
