@#include "declare_all.macro"

@#include "parameters_common.macro"

@#include paramFile

@#include effFile

% Technology growth balances the common trends in private and public capital.
gammaa=g^((1-alpha-alphaG)/(vartheta-1))-1;

model;

@#include "model_block.modpart"

end;

steady;
check;

shocks;
@#include shockFile
end;

@#include "postSimul.mod"
