@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsicgeeff25y_al.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsicgeeff25y_al.shockValues"
end;

@#include "postSimul.mod"
