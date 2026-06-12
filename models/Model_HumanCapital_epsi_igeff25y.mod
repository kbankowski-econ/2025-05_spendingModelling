@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_igeff25y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igeff25y.shockValues"
end;

@#include "simulSpec.mod"
