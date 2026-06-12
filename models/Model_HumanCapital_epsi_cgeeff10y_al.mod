@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

@#include effFile

% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alppha)/(varthetaat-1))-1;

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include shockFile
end;

@#include "postSimul.mod"
