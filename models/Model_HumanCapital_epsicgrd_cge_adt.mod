@#include "declare_all.macro"

@#include "Model_HumanCapital_epsicgrd_cge_adt.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsicgrd_cge_adt.shockValues"
end;

@#include "postSimul.mod"
