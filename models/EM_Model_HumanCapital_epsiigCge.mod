@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsiigCge.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsiigCge.shockValues"
end;

@#include "postSimul.mod"
