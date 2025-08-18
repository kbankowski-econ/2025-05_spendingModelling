@#include "modEq.mod"

shocks;
    var epsi_cge;
    @#include "shockStandardVal.mod"

    var epsi_effge;
    @#include  "Model_HumanCapital_epsi_cgeeff10y_al.shockValues"

    var epsiallo_cge;
    @#include  "epsi_allo_cge_AE_10Y_values.macro"

end;

@#include "simulSpec.mod"