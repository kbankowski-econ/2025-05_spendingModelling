@#include "declare_all.macro"

@#include paramFile

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsicgrd_cge_limt.shockValues"
end;

@#include "postSimul.mod"
