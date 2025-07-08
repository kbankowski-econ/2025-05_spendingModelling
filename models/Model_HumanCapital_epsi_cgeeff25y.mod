@#include "modEq.mod"

shocks;
    var epsi_cge;
    @#include "shockStandardVal.mod"

    var epsi_effge;
    @#include  "epsi_eff_AE_25Y_values.macro"

end;

@#include "simulSpec.mod"