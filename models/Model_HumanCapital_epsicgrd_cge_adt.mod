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

% Include AE parameters
@#include  "AE_parameters.macro"

%alphaSRD=0;% NO learning by doing
%alphaRD=0.09/2*(1-rho_ZZRD);

model;

@#include "model_block.modpart"

end;


steady;
check;


shocks;

var epsi_cgrd;
periods 1:1000  ;
values 
0.005;


var epsi_cge;
periods 1:1000  ;
values 
0.005;

% 10 percent of the original values
var epsirhoadopt;
@#include "Model_HumanCapital_epsicgrd_cge_adt.shockValues"

end;


perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period



fiscalchange=Ig-Igss+Cge-Cgess+Cgrd-Cgrdss;
ped=1*4;
multiplier_1y=sum((yd(2:ped+1)-yd(1)))/sum((fiscalchange(2:ped+1)))
ped=5*4;
multiplier_5y=sum((yd(2:ped+1)-yd(1)))/sum((fiscalchange(2:ped+1)))
ped=10*4;
multiplier_10y=sum((yd(2:ped+1)-yd(1)))/sum((fiscalchange(2:ped+1)))
ped=20*4;
multiplier_20y=sum((yd(2:ped+1)-yd(1)))/sum((fiscalchange(2:ped+1)))
ped=25*4;
multiplier_25y=sum((yd(2:ped+1)-yd(1)))/sum((fiscalchange(2:ped+1)))
multiplier_all=[ multiplier_1y  multiplier_5y multiplier_10y multiplier_20y multiplier_25y]
/*
num=[1:40]
v1=[0:1/40:1]
v2=v1(2:end)'*0.03
*/