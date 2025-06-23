@#include "modEq.mod"

shocks;
    var epsi_ig;
    @#include "shockStandardVal.mod"
    var epsi_cge;
    @#include "shockStandardVal.mod"
    var epsi_cgrd;
    @#include "shockStandardVal.mod"
end;

@#include "simulSpec.mod"