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

var epsi_effge;
@#include  "EM_Model_HumanCapital_epsieffcge30y.shockValues"
end;


perfect_foresight_setup(periods=2000);%options_.debug
perfect_foresight_solver(maxit=20); %maxit=10 linear_approximation, endogenous_terminal_period



fiscalchange=Ig-Igss+Cge-Cgess+Cgrd-Cgrdss;
multiplier=sum((yd(2:40)-yd(1)))/sum((fiscalchange(2:30)))


/*
vv=0.2
num=[1:20]
v1=[vv:-vv/20:0]';
%v2=v1(2:end)'/100;


vv=0.2
num=[1:20]
v1=[0:vv/20:vv]
v2=v1(2:end)';
*/