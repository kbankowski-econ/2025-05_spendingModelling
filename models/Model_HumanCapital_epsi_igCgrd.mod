@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_igCgrd.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igCgrd.shockValues"
end;

@#include "simulSpec.mod"
