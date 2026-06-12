@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsicgeeff25ylow.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsicgeeff25ylow.shockValues"
end;

@#include "postSimul.mod"
