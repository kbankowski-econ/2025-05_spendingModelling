@#include "declare_all.macro"

@#include "Model_HumanCapital_epsieff30y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsieff30y.shockValues"
end;

@#include "postSimul.mod"
