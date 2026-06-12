@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsicgrd_cge_adt.shockValues"
end;

@#include "postSimul.mod"
