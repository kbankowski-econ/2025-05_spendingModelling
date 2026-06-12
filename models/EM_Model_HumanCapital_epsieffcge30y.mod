@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsieffcge30y.shockValues"
end;

@#include "postSimul.mod"
