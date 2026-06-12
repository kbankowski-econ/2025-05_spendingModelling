@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_cgeeff5y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_cgeeff5y.shockValues"
end;

@#include "simulSpec.mod"
