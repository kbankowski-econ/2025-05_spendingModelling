@#include "declare_all.macro"

@#include paramFile

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include "EM_Model_HumanCapital_epsiig.shockValues"
end;

@#include "postSimul.mod"
