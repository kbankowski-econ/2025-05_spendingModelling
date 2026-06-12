@#include "declare_all.macro"

@#include paramFile

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "Model_HumanCapital_epsieff30y.shockValues"
end;

@#include "postSimul.mod"
