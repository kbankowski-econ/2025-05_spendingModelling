@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_igCge.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igCge.shockValues"
end;

@#include "simulSpec.mod"
