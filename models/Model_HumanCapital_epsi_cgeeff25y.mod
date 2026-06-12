@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_cgeeff25y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_cgeeff25y.shockValues"
end;

@#include "postSimul.mod"
