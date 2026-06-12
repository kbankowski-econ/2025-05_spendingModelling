@#include "declare_all.macro"

@#include "Model_HumanCapital_epsi_cgeeff10y_al.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsi_cgeeff10y_al.shockValues"
end;

@#include "postSimul.mod"
