@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_cgrd.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_cgrd.shockValues"
end;

@#include "simulSpec.mod"
