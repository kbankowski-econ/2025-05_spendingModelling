@#include "modEq.mod"

shocks;
    var epsi_cge;
    @#include "shockStandardVal.mod"

    var epsi_effge;
    @#include  "Model_HumanCapital_epsi_cgeeff5y.shockValues"

end;

@#include "simulSpec.mod"