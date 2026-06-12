@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsiigeff10y.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsiigeff10y.shockValues"
end;

@#include "postSimul.mod"
