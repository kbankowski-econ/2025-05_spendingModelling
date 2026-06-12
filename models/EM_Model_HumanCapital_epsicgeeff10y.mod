@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsicgeeff10y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsicgeeff10y.shockValues"
end;

@#include "postSimul.mod"
