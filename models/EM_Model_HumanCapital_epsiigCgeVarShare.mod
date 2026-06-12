@#include "declare_all.macro"

@#include "EM_Model_HumanCapital_epsiigCgeVarShare.paramValues"

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsiigCgeVarShare.shockValues"
end;

@#include "postSimul.mod"
