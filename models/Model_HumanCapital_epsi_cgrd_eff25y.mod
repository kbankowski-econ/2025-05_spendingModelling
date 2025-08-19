@#include "modEq.mod"

shocks;
    var epsi_cgrd;
    @#include "shockStandardVal.mod"

var epsi_effcgrd;
@#include "Model_HumanCapital_epsi_cgrd_eff25y.shockValues"

end;
@#include "simulSpec.mod"
