% ANH NGUYEN (FAD FP)
% This model is a standard macro-fiscal model
% A representative HH 
% Public expenditure: public consumption, pubic investment
% Public revenue: consumption tax, income tax, lump-sum transfer
% Price stickiness
% Public investment is modelled as in Drautzburg and Uhlig (2015)


% June 23: 
% revise the debt equation: R(-1)/PI
% revise the gov expenditure equation in terms of GDP
% revsie the transfer adjustment equation

@#include "declare_all.macro"

% Include EM parameters
@#include  "EM_parameters.macro"


model;

@#include "model_block.modpart"

end;


steady;
check;


shocks;

    var epsi_cge;
    periods 1:40 41 42 43 44 45 46 47 48 49 50:1000;
    values 
    0.005
    0.0052
    0.0054
    0.0056
    0.0058
    0.006
    0.0062
    0.0064
    0.0066
    0.0068
    0.007;

    var epsi_ig;
    periods 1:40 41 42 43 44 45 46 47 48 49 50:1000;
    values 
    0.005
    0.0048
    0.0046
    0.0044
    0.0042
    0.004
    0.0038
    0.0036
    0.0034
    0.0032
    0.003;

end;

perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period



fiscalchange=Ig-Igss+Cge-Cgess+Cgrd-Cgrdss;
ped=1*4;
multiplier_1y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=5*4;
multiplier_5y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=10*4;
multiplier_10y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=20*4;
multiplier_20y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=25*4;
multiplier_25y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))



/*
num=[1:20]
v1=[0:1/20:1]
v2=v1(2:end)'/100;
*/