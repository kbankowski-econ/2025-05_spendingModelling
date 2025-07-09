@#include "modEq.mod"

shocks;
    var epsi_cge;
    periods 1:1000  ;
    values 
    0.005;
    var epsi_cgrd;
    periods 1:1000  ;
    values 
    0.005;
end;

@#include "simulSpec.mod"