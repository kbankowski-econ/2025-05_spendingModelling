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
periods 1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40 41:1000;
values 
 
    0.0008
    0.0015
    0.0023
    0.0030
    0.0037
    0.0045
    0.0053
    0.0060
    0.0067
    0.0075
    0.0083
    0.0090
    0.0097
    0.0105
    0.0112
    0.0120
    0.0128
    0.0135
    0.0143
    0.0150
    0.0157
    0.0165
    0.0172
    0.0180
    0.0187
    0.0195
    0.0203
    0.0210
    0.0217
    0.0225
    0.0232
    0.0240
    0.0247
    0.0255
    0.0262
    0.0270
    0.0278
    0.0285
    0.0292
    0.0300
0.03; 

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