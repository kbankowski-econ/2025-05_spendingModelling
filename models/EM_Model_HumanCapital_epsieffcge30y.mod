@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsieffcge30y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsieffcge30y.shockValues"
end;

@#include "postSimul.mod"
