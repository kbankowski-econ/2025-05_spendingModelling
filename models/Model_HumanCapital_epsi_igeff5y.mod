@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_igeff5y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igeff5y.shockValues"
end;

@#include "simulSpec.mod"
