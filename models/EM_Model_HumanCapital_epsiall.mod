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

var epsi_ig;
periods 1:1000  ;
values 
0.01;


var epsi_eff;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121:1000;
values
    0.0017
    0.0033
    0.0050
    0.0067
    0.0083
    0.0100
    0.0117
    0.0133
    0.0150
    0.0167
    0.0183
    0.0200
    0.0217
    0.0233
    0.0250
    0.0267
    0.0283
    0.0300
    0.0317
    0.0333
    0.0350
    0.0367
    0.0383
    0.0400
    0.0417
    0.0433
    0.0450
    0.0467
    0.0483
    0.0500
    0.0517
    0.0533
    0.0550
    0.0567
    0.0583
    0.0600
    0.0617
    0.0633
    0.0650
    0.0667
    0.0683
    0.0700
    0.0717
    0.0733
    0.0750
    0.0767
    0.0783
    0.0800
    0.0817
    0.0833
    0.0850
    0.0867
    0.0883
    0.0900
    0.0917
    0.0933
    0.0950
    0.0967
    0.0983
    0.1000
    0.1017
    0.1033
    0.1050
    0.1067
    0.1083
    0.1100
    0.1117
    0.1133
    0.1150
    0.1167
    0.1183
    0.1200
    0.1217
    0.1233
    0.1250
    0.1267
    0.1283
    0.1300
    0.1317
    0.1333
    0.1350
    0.1367
    0.1383
    0.1400
    0.1417
    0.1433
    0.1450
    0.1467
    0.1483
    0.1500
    0.1517
    0.1533
    0.1550
    0.1567
    0.1583
    0.1600
    0.1617
    0.1633
    0.1650
    0.1667
    0.1683
    0.1700
    0.1717
    0.1733
    0.1750
    0.1767
    0.1783
    0.1800
    0.1817
    0.1833
    0.1850
    0.1867
    0.1883
    0.1900
    0.1917
    0.1933
    0.1950
    0.1967
    0.1983
    0.2000
0.2;

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