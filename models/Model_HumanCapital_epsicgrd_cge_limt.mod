@#include "declare_all.macro"

@#include "Model_HumanCapital_epsicgrd_cge_limt.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsicgrd_cge_limt.shockValues"
end;

@#include "postSimul.mod"
