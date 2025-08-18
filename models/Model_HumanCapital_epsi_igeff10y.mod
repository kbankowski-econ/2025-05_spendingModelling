@#include "modEq.mod"

shocks;
    var epsi_ig;
    @#include "shockStandardVal.mod"

    var epsi_eff;
    @#include  "Model_HumanCapital_epsi_igeff10y.shockValues"

end;

@#include "simulSpec.mod"