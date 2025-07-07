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

/*
periods 1:2000    ;
values 
  0.2;
*/
periods 1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20 21:1000  ;
values  0.0100
    0.0200
    0.0300
    0.0400
    0.0500
    0.0600
    0.0700
    0.0800
    0.0900
    0.1000
    0.1100
    0.1200
    0.1300
    0.1400
    0.1500
    0.1600
    0.1700
    0.1800
    0.1900
    0.2000
0.2;

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