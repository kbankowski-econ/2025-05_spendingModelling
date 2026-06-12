@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

@#include effFile

% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_igeff5y.shockValues"
end;

@#include "postSimul.mod"
