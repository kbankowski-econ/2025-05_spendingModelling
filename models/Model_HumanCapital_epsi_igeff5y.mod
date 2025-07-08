@#include "modEq.mod"

shocks;
    var epsi_ig;
    @#include "shockStandardVal.mod"

    var epsi_eff;
    @#include  "epsi_eff_AE_5Y_values.macro"

end;

@#include "simulSpec.mod"