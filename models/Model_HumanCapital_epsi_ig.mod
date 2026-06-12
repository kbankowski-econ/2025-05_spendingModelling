@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_ig.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_ig.shockValues"
end;

@#include "simulSpec.mod"
