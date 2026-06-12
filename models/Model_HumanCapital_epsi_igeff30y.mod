@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_igeff30y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igeff30y.shockValues"
end;

@#include "simulSpec.mod"
