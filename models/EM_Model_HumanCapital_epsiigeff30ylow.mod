@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsiigeff30ylow.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsiigeff30ylow.shockValues"
end;

@#include "postSimul.mod"
