@#include "modEq.mod"

shocks;
    var epsi_ig;
    @#include "shockStandardVal.mod"

    var epsi_eff;
    @#include  "Model_HumanCapital_epsi_igeff10y_al.shockValues"

    var epsiallo_ig;
    @#include  "epsi_allo_ig_AE_10Y_values.macro"

end;

@#include "simulSpec.mod"