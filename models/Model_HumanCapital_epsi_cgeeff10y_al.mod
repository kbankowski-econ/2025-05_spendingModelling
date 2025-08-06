@#include "modEq.mod"

shocks;
    var epsi_cge;
    @#include "shockStandardVal.mod"

    var epsi_effge;
    @#include  "epsi_eff_AE_10Y_values.macro"

    var epsiallo_cge;
    @#include  "epsi_allo_AE_10Y_values.macro"

end;

@#include "simulSpec.mod"