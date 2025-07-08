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
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101:1000;
values
    0.0020
    0.0040
    0.0060
    0.0080
    0.0100
    0.0120
    0.0140
    0.0160
    0.0180
    0.0200
    0.0220
    0.0240
    0.0260
    0.0280
    0.0300
    0.0320
    0.0340
    0.0360
    0.0380
    0.0400
    0.0420
    0.0440
    0.0460
    0.0480
    0.0500
    0.0520
    0.0540
    0.0560
    0.0580
    0.0600
    0.0620
    0.0640
    0.0660
    0.0680
    0.0700
    0.0720
    0.0740
    0.0760
    0.0780
    0.0800
    0.0820
    0.0840
    0.0860
    0.0880
    0.0900
    0.0920
    0.0940
    0.0960
    0.0980
    0.1000
    0.1020
    0.1040
    0.1060
    0.1080
    0.1100
    0.1120
    0.1140
    0.1160
    0.1180
    0.1200
    0.1220
    0.1240
    0.1260
    0.1280
    0.1300
    0.1320
    0.1340
    0.1360
    0.1380
    0.1400
    0.1420
    0.1440
    0.1460
    0.1480
    0.1500
    0.1520
    0.1540
    0.1560
    0.1580
    0.1600
    0.1620
    0.1640
    0.1660
    0.1680
    0.1700
    0.1720
    0.1740
    0.1760
    0.1780
    0.1800
    0.1820
    0.1840
    0.1860
    0.1880
    0.1900
    0.1920
    0.1940
    0.1960
    0.1980
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