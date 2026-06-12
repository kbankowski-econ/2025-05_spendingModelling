@#include "declare_all.macro"

@#include paramFile

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsicgrd_cge_adt.shockValues"
end;

@#include "postSimul.mod"
