@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_cgeeff30y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_cgeeff30y.shockValues"
end;

@#include "simulSpec.mod"
