var 
C               % HH consumption
lambda          % Marginal Utility
R               % Interest rate on bond
PI              % Gross inflation
N               % (Effective) Labor supply
W_real          % Real wages
Ip              % Private investment
Kp              % Private capital
rk              % Return on private investment
x1              % Price setting 1
x2              % Price setting 2
mc              % Marginal cost
PIstar          % Optimnal gross inflation 
y              % Production
Kg              % Public capital
Rmp             % Policy rate
D              % Debt level
by              % Debt/GDP
Igi              % Public investment
Gc              % Public consumption
tauc            % Consumption tax
tauw            % Income tax
yd              % Aggregate demand
vp              % Price dispersion
ZZ              % Gross growth rate
%shock_ZZ        % shock to the ZZ process  
Delta_G         % Expected loss 
prob_def        % probability of default
omega           % Scaling
Igiss            % Steady state of Investment
Gcss            % Steady state of Consumption
Rss             % Steady state interest rate   
ydss            % Steady state output
Trans           % Transfer
lnyd            % Log of Output
G               % Total government spending (Gc+Igi+Ige+Grd)
pdef            % Primary Deficit
rreal           % Ex-post real interest rate (R/PI)
pdef_yss        % Primary deficit, share of steady-state GDP
Trans_yss       % Transfers, share of steady-state GDP
dserv_yss       % Debt service (interest), share of steady-state GDP
by_yss          % Government debt, share of steady-state GDP
Igi_ys           % Public Investment as percent of GDP
by_ann          % Debt to GDP
lnPI            % Log of Prince index
H               % Human capital
Kge             % Public Human-related Capital Stock (HCS)
Ige             % Public spending in public humand-related capital stock
E               % Time for schooling and taking care of health (building capital)
lambda_HC        % Lagrangian of the Human capital formation
Igess           % Steady state of public spending on Public human-capital related stock
Lab             % Labor supply 
muyH            % Adjuster so that E=0.1
ygrowth          % econonmic growth
eGE             % Gap in public human-capital efficiency (e^GE)
eGI             % Gap in public infrastructure efficiency (e^GI)
A             % Aoption Tech Process
Grd            % R&D spending
Grdss          % R&D spending SS
shockchi       % R&D process productivity shock SS
SDF             % Stochastic discount factor
S             % Effective labor demand for tech adoption
VA              % Value of tech adoption
probadopt       % Probability of adoption
J             % Value of unadopted Intermediate
Srd             % Effective labor demand for R&D development
ZZRD            % R&D product
kappaprob       % Parameter in the probability for scaling
shockchiss     %% SS of shockchi 
Ns              % Labor in R&D
TFP             % TFP
Grd_ydss_ratio
ln_Grd
Grdeff
eGRD            % Gap in public R&D efficiency (e^GRD)
;
%-----------------------------
% Define exogenous variables
%-----------------------------
varexo
epsi_gc         % Shock to government consumption
epsi_igi         % Shock to government investment  
epsi_ZZ         % Shock to trend
epsi_spread     % Shock to Spread
epsi_MP         % Monetary Policy Shocks
epsi_tauc       % Consumption income tax shock 
epsi_tauw       % Labor income tax shock
epsi_ige        % Public HC spending shock
epsi_effge  
epsi_eff
epsi_grd       % Shock to R&D spending
epsi_shockchi  % Shock to the R&D process 
epsirhoadopt
epsi_effcgrd
epsiallo_ig        % shock to elasticity wrt public infrastructure capital
epsiallo_ige       % Shock to elasticity wrt public human capital 
;
%--------------------------
% Define parameters
%--------------------------
parameters 
betta           % Discount value
varphi             % Frisch parameter
chi             % indexation
delta           % depreciationf
thetap          % firsm cant change the price
epsilon         % elasticity of substitution 
alpha          % share of capital in intermediate firms production
Bigtheta        % Fixed cost
Bigtheta_y      % Fixed cost to GDP
alphaG          % Share of public capital in the production (paper alpha_G)
rho_R           % Persistence of policy rate
gamma_pi        % Reponse of MP to inflation
gamma_y         % Reponse of MP to OG
Piss            % SS of gross inflation
rho_RG          % Persistence of goverment bond rate capturing the maturity (1/(1-rho_RG)) s the average maturity
rho_tauc        % AR(1) of consumption tax rate
taucss          % Consumption tax rate SS
gamma_y_tauc    % Response of consumption tax to OG
gamma_d_tauc    % Response of consumption tax to debt
rho_tauw        % AR(1) of income tax rate
tauwss          % Income tax rate SS
gamma_y_tauw    % Response of consumption tax to OG
gamma_d_tauw    % Response of consumption tax to debt
byss            % Steady state of debt
rho_ZZ          % AR(1) of growth shock 
ZZss            % SS of growth
eta1            % Prof default param 1
eta2            % Prof default param 2 
Deltacost       % Feed back of debt on rate
Igiy             % Public investment/GDP
Gcy             % Public consumption/GDP
rho_Gc          % AR(1) process for public consumption
rho_Igi          % AR(1) process for public investment  
gamma_d_trans   % Response of lump sum transfer to debt
rho_trans
eGI_ss          % SS gap in public infrastructure efficiency (e^GI)
deltaH          % Depreciation of Labor
gamma             % Effectiveness of education investment.
mu          % Elasticity of Human Capital Formation w.r.t. Public Human-related Capital (HRC)
eGE_ss          % SS gap in public human-capital efficiency (e^GE)
Igey            % Share of goevrnment expenditure to human capital
alphaZZ1        % Learning by doing off HHon ZZ
rho_Ige         % Persistence of human-related spending
alphaRD         % R&D on TFP
Grdy           % share of expenditure for R&D
markupss        % SS markup of Intermediate goods 
phi           % obsolescence rate: 0.08/4
vartheta      % Intermediate goods elasticity of substitution
gammaa         % Gorwth of tech
probadoptss    % Probability of adoption
varsigma      % Adoption elasticity
alphaHA        % HC elasticity in tech creation (paper alpha_HA)
rhoshockchi    % AR (1) or shock to r&D
rho_ZZRD
eGRD_ss         % SS gap in public R&D efficiency (e^GRD)
;
betta=0.9985;
varphi= 5 ;   % inverse Frisch elasticity (Frisch 0.2), as in Gali (2015, Ch. 3); was 1.2
chi =0.6;
delta =0.025;
thetap = 0.8;
epsilon =10;
alpha=0.3;
Bigtheta=0;
Bigtheta_y=0;
rho_R=0.7;
gamma_pi=1.5;
gamma_y=0.25;
Piss=1;
rho_RG=0;
rho_tauc=0.9;
gamma_y_tauc=0;
gamma_d_tauc=0.0;
rho_tauw=0.9;
gamma_y_tauw=0;
gamma_d_tauw=0;
rho_ZZ= 0.24 ;
eta1=-18.12;
eta2=3.12;
Deltacost=0;  % Shutting down the feedback of debt on rate
rho_Gc=0.9;
rho_Igi=0.9;
gamma_d_trans=0.01;
rho_trans=0;
deltaH=0.025;
gamma=0.5;
rho_Ige=0.9;
alphaZZ1=0.2;
markupss=1.18;
phi=1-0.08/4;   % obsolescence rate: 0.08/4
vartheta=1.35;
probadoptss=0.2/4;
rhoshockchi=1;
rho_ZZRD=0.79;
% AE-specific calibration            (definition                                    | EM value)
% production and growth
alphaG=0.054;                        % share of public capital in production         | EM: 0.17
ZZss=1.004;                          % steady-state gross quarterly growth           | EM: 1.0075
% taxes and debt
taucss=0.18;                         % steady-state consumption tax rate             | EM: 0.15
tauwss=0.25;                         % steady-state income tax rate                  | EM: 0.10
byss=1*4;                            % steady-state debt to quarterly GDP (annual x4)| EM: 0.6*4
% public spending shares of GDP
Igiy=0.03;                            % public investment                             | EM: 0.05
Gcy=0.18;                            % public consumption                            | EM: 0.14
Igey=0.0145;                         % human-capital-related spending                | EM: 0.02
Grdy=0.006;                         % R&D spending                                  | EM: 0.001
% human capital
mu=0.1;                          % elasticity of HC formation w.r.t. public HRC  | EM: 0.25
% R&D and technology adoption
eGRD_ss=0.399;                       % public R&D efficiency gap (e^GRD)              | EM: 0.2
alphaRD=0.09*(1-rho_ZZRD);           % effect of R&D on TFP                          | EM: 0
alphaHA=0.1;                         % HC elasticity in tech creation (paper a_HA)   | EM: 0
varsigma=0.8;                       % adoption elasticity                           | EM: 0.1
% AE efficiency gaps (2023 medians; INF re-estimated 2026-06)
eGI_ss=0.359;
eGE_ss=0.306;
% gammaa uses the set-specific ZZss, so it must come after it
gammaa=ZZss^((1-alpha)/(vartheta-1))-1;
model;
//********************************************************
// HOUSEHOLD DECISIONS
//********************************************************
// Marginal utility
1/C = lambda*(1+tauc);
// Euler equation
lambda = betta*(lambda(+1)/ZZ(+1)*R/PI(+1));
// Labor decision
omega*(Lab+E)^varphi = lambda*W_real*H(-1)*(1-tauw);
// Law of motion of private capital
Kp*ZZ = (1-delta)*Kp(-1)+Ip;
// Return on private investment
1 = betta*(lambda(+1)/lambda/ZZ(+1)*(1-delta+rk(+1)));
// Human capital of the household
H = (1-deltaH)*H(-1)+muyH*E^gamma*(Kge(-1))^(mu*(1+epsiallo_ige));
// Time devoted to building human capital (E)
omega*(Lab+E)^varphi = lambda_HC*muyH*gamma*E^(gamma-1)*(Kge(-1))^(mu*(1+epsiallo_ige));
// Shadow value of human capital
lambda_HC = betta*(lambda(+1)*(1-tauw(+1))*W_real(+1)*Lab(+1)+lambda_HC(+1)*(1-deltaH));
// Effective labor
N = Lab*H(-1);
//********************************************************
// FIRMS DECISIONS
//********************************************************
// Price setting
x1 = lambda*mc*yd+betta*thetap*(PI^chi/PI(+1))^(-epsilon)*x1(+1);
x2 = lambda*PIstar*yd+betta*thetap*(PI^chi/PI(+1))^(1-epsilon)*PIstar/PIstar(+1)*x2(+1);
epsilon*x1 = (epsilon-1)*x2;
// Optimal factor mix
Kp(-1)/N = alpha/(1-alpha)*W_real/rk;
// Marginal cost
(1-alpha)*mc*y/N = markupss*W_real;
// Law of motion of prices
1 = thetap*(PI(-1)^chi/PI)^(1-epsilon)+(1-thetap)*PIstar^(1-epsilon);
// Production
[name='y']
y = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*(Kp(-1)^alpha)*(N^(1-alpha))-Bigtheta;
// Technology creation (R&D enters in efficiency-adjusted form via Grdeff)
ln(ZZRD/STEADY_STATE(ZZRD)) = rho_ZZRD*ln(ZZRD(-1)/STEADY_STATE(ZZRD))+alphaRD*ln(Grdeff(-1)/STEADY_STATE(Grdeff))+alphaHA*ln(H(-1)/STEADY_STATE(H))+log(shockchi);
// Effective R&D = efficiency wedge times R&D spending
Grdeff = (1-eGRD)*Grd;
// Value of an unadopted technology
J = -S+phi*(SDF(+1)*A(-1)/A*1/(1+gammaa)*(probadopt*VA(+1)+(1-probadopt)*J(+1)));
// Probability of adoption
probadopt = (kappaprob+epsirhoadopt)*(S)^(varsigma);
// Adoption
(1+gammaa)*A = probadopt*phi*(ZZRD(-1)-A(-1))+phi*A(-1);
// Value of an adopted technology
VA = (markupss-1)/(markupss)*mc*y + phi*SDF(+1)*VA(+1)*A(-1)/A/(1+gammaa);
// FOC for adoption effort
varsigma*probadopt*phi*SDF(+1)/(1+gammaa)*A(-1)/A*(VA(+1)-J(+1)) = S;
// Stochastic discount factor (detrended)
SDF = betta*lambda*(1+tauc)/(lambda(-1)*(1+tauc(-1)));
// Shock to the R&D technology
log(shockchi) = (1-rhoshockchi)*log(shockchiss)+rhoshockchi*log(shockchi(-1))+epsi_shockchi;
//********************************************************
// MONETARY AUTHORITY
//********************************************************
// Taylor rule
Rmp/Rss = (Rmp(-1)/Rss)^rho_R*((PI/Piss)^gamma_pi*(yd/ydss)^gamma_y)^(1-rho_R)*exp(epsi_MP);
// Government borrowing cost vs. policy rate (sovereign spread)
log(R) = rho_RG*R(-1)+ (1-rho_RG)*(log(Rmp) + Delta_G*(by(-1)-byss)) + epsi_spread;
Delta_G = prob_def*Deltacost;
prob_def = exp(eta1 + eta2*by(-1))/(1+exp(eta1 + eta2*by(-1)));
//********************************************************
// GOVERNMENT DECISIONS
//********************************************************
// Public infrastructure capital
Kg*ZZ = (1-delta)*Kg(-1)+(1-eGI)*Igi;
// Government debt
D = (R(-1)/PI)*D(-1)/ZZ+Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C;
// Lump-sum transfers
Trans-STEADY_STATE(Trans) = rho_trans*(Trans(-1)-STEADY_STATE(Trans))+(1-rho_trans)*(-gamma_d_trans*(by(-1)-byss)*ydss);
// Debt to GDP
by = D/y;
// Government spending instruments (subject to expenditure shocks)
Gc = Gcss+ydss*epsi_gc;                                     // consumption (explicit instrument; neutrality imposed via the offsetting epsi_gc shock)
Igi = Igiss+ydss*epsi_igi;                                     // infrastructure investment
Ige = Igess+ydss*epsi_ige;                                  // human-capital investment
Grd = Grdss+ydss*epsi_grd;                               // R&D spending
// Consumption tax rule
tauc-taucss = rho_tauc*(tauc(-1)-taucss)+(1-rho_tauc)*(gamma_d_tauc*(by(-1)-byss))+epsi_tauc;
// Income tax rule
tauw-tauwss = rho_tauw*(tauw(-1)-tauwss)+(1-rho_tauw)*(gamma_d_tauw*(by(-1)-byss))+epsi_tauw;
// Public human-capital stock
Kge*ZZ = (1-delta)*Kge(-1)+(1-eGE)*Ige;
//********************************************************
// MARKET CLEARING
//********************************************************
// Aggregate demand
[name='yd']
yd = C+Ip+Igi+Gc+Ige+Grd+Srd+(ZZRD(-1)/A(-1)-1)*S;
// Aggregate production
y = vp*yd;
// Price dispersion
vp = thetap*(PI(-1)^chi/PI)^(-epsilon)*vp(-1)+(1-thetap)*PIstar^(-epsilon);
//********************************************************
// SHOCK DYNAMICS
//********************************************************
// Trend growth
log(ZZ) = (1-rho_ZZ)*log(ZZ(-1))+rho_ZZ*(log(ZZss))+epsi_ZZ;
// Gap in human-capital spending efficiency (e^GE; positive shock closes the gap)
eGE = eGE_ss-epsi_effge;
// Gap in infrastructure spending efficiency (e^GI)
eGI = eGI_ss-epsi_eff;
// Gap in R&D spending efficiency (e^GRD)
eGRD = eGRD_ss-epsi_effcgrd;
//********************************************************
// VARIABLES OF INTEREST
//********************************************************
lnyd = log(yd)*100;
TFP = A(-1)^(vartheta-1)*(Kg(-1)^(alphaG*(1+epsiallo_ig)))*H(-1)^(1-alpha);
G = Gc+Igi+Ige+Grd;                                        // total government spending (sum of the four instruments)
pdef = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/y*100;
rreal = R/PI;                                              // ex-post real interest rate
// Fiscal aggregates as a share of steady-state GDP (ydss)
pdef_yss  = (Gc+Igi+Ige+Grd+Trans-tauw*W_real*N-tauc*C)/ydss;  // primary deficit
Trans_yss = Trans/ydss;                                       // transfers
dserv_yss = (R-1)*D/ydss;                                    // debt service (interest)
by_yss    = D/ydss;                                          // government debt
Igi_ys = Igi/ydss*100;
by_ann = by/4*100;
lnPI = log(PI)*100;
ln_Grd = log(Grd);
Grd_ydss_ratio = Grd/ydss;
// Output growth
ygrowth = log(yd/yd(-1))*100+log(ZZ)*100;
//********************************************************
// STEADY-STATE VALUES CARRIED INTO THE MODEL BLOCK
//********************************************************
// Auxiliary variables pinned to their steady-state values; used as constants
// in the rules above. Collected here for clarity — in Dynare the order of
// equations within the model block does not affect the solution.
omega       = STEADY_STATE(omega);
Rss         = STEADY_STATE(R);
ydss        = STEADY_STATE(yd);
muyH        = STEADY_STATE(muyH);
kappaprob   = STEADY_STATE(kappaprob);
shockchiss = STEADY_STATE(shockchi);   // exogenous disturbance to the R&D technology
Ns          = STEADY_STATE(Ns);
Srd         = STEADY_STATE(Srd);
Gcss        = Gcy*STEADY_STATE(y);
Igiss        = Igiy*STEADY_STATE(y);
Igess       = Igey*STEADY_STATE(y);
Grdss      = Grdy*STEADY_STATE(y);
end;
steady;
check;
shocks;
var epsi_igi;
periods 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 513 514 515 516 517 518 519 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 571 572 573 574 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 590 591 592 593 594 595 596 597 598 599 600 601 602 603 604 605 606 607 608 609 610 611 612 613 614 615 616 617 618 619 620 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 660 661 662 663 664 665 666 667 668 669 670 671 672 673 674 675 676 677 678 679 680 681 682 683 684 685 686 687 688 689 690 691 692 693 694 695 696 697 698 699 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 752 753 754 755 756 757 758 759 760 761 762 763 764 765 766 767 768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 800 801 802 803 804 805 806 807 808 809 810 811 812 813 814 815 816 817 818 819 820 821 822 823 824 825 826 827 828 829 830 831 832 833 834 835 836 837 838 839 840 841 842 843 844 845 846 847 848 849 850 851 852 853 854 855 856 857 858 859 860 861 862 863 864 865 866 867 868 869 870 871 872 873 874 875 876 877 878 879 880 881 882 883 884 885 886 887 888 889 890 891 892 893 894 895 896 897 898 899 900 901 902 903 904 905 906 907 908 909 910 911 912 913 914 915 916 917 918 919 920 921 922 923 924 925 926 927 928 929 930 931 932 933 934 935 936 937 938 939 940 941 942 943 944 945 946 947 948 949 950 951 952 953 954 955 956 957 958 959 960 961 962 963 964 965 966 967 968 969 970 971 972 973 974 975 976 977 978 979 980 981 982 983 984 985 986 987 988 989 990 991 992 993 994 995 996 997 998 999 1000 ;
values
    0.01
    0.009
    0.0081
    0.00729
    0.006561
    0.0059049
    0.00531441
    0.00478297
    0.00430467
    0.0038742
    0.00348678
    0.00313811
    0.0028243
    0.00254187
    0.00228768
    0.00205891
    0.00185302
    0.00166772
    0.00150095
    0.00135085
    0.00121577
    0.00109419
    0.000984771
    0.000886294
    0.000797664
    0.000717898
    0.000646108
    0.000581497
    0.000523348
    0.000471013
    0.000423912
    0.00038152
    0.000343368
    0.000309032
    0.000278128
    0.000250316
    0.000225284
    0.000202756
    0.00018248
    0.000164232
    0.000147809
    0.000133028
    0.000119725
    0.000107753
    9.69774e-05
    8.72796e-05
    7.85517e-05
    7.06965e-05
    6.36269e-05
    5.72642e-05
    5.15378e-05
    4.6384e-05
    4.17456e-05
    3.7571e-05
    3.38139e-05
    3.04325e-05
    2.73893e-05
    2.46503e-05
    2.21853e-05
    1.99668e-05
    1.79701e-05
    1.61731e-05
    1.45558e-05
    1.31002e-05
    1.17902e-05
    1.06112e-05
    9.55005e-06
    8.59504e-06
    7.73554e-06
    6.96199e-06
    6.26579e-06
    5.63921e-06
    5.07529e-06
    4.56776e-06
    4.11098e-06
    3.69988e-06
    3.3299e-06
    2.99691e-06
    2.69722e-06
    2.42749e-06
    2.18475e-06
    1.96627e-06
    1.76964e-06
    1.59268e-06
    1.43341e-06
    1.29007e-06
    1.16106e-06
    1.04496e-06
    9.40461e-07
    8.46415e-07
    7.61773e-07
    6.85596e-07
    6.17037e-07
    5.55333e-07
    4.998e-07
    4.4982e-07
    4.04838e-07
    3.64354e-07
    3.27919e-07
    2.95127e-07
    2.65614e-07
    2.39053e-07
    2.15147e-07
    1.93633e-07
    1.74269e-07
    1.56842e-07
    1.41158e-07
    1.27042e-07
    1.14338e-07
    1.02904e-07
    9.26139e-08
    8.33525e-08
    7.50172e-08
    6.75155e-08
    6.0764e-08
    5.46876e-08
    4.92188e-08
    4.42969e-08
    3.98672e-08
    3.58805e-08
    3.22925e-08
    2.90632e-08
    2.61569e-08
    2.35412e-08
    2.11871e-08
    1.90684e-08
    1.71615e-08
    1.54454e-08
    1.39008e-08
    1.25108e-08
    1.12597e-08
    1.01337e-08
    9.12034e-09
    8.20831e-09
    7.38748e-09
    6.64873e-09
    5.98386e-09
    5.38547e-09
    4.84693e-09
    4.36223e-09
    3.92601e-09
    3.53341e-09
    3.18007e-09
    2.86206e-09
    2.57585e-09
    2.31827e-09
    2.08644e-09
    1.8778e-09
    1.69002e-09
    1.52102e-09
    1.36891e-09
    1.23202e-09
    1.10882e-09
    9.97939e-10
    8.98145e-10
    8.0833e-10
    7.27497e-10
    6.54748e-10
    5.89273e-10
    5.30346e-10
    4.77311e-10
    4.2958e-10
    3.86622e-10
    3.4796e-10
    3.13164e-10
    2.81847e-10
    2.53663e-10
    2.28296e-10
    2.05467e-10
    1.8492e-10
    1.66428e-10
    1.49785e-10
    1.34807e-10
    1.21326e-10
    1.09193e-10
    9.82741e-11
    8.84467e-11
    7.9602e-11
    7.16418e-11
    6.44776e-11
    5.80299e-11
    5.22269e-11
    4.70042e-11
    4.23038e-11
    3.80734e-11
    3.42661e-11
    3.08395e-11
    2.77555e-11
    2.498e-11
    2.2482e-11
    2.02338e-11
    1.82104e-11
    1.63894e-11
    1.47504e-11
    1.32754e-11
    1.19478e-11
    1.07531e-11
    9.67775e-12
    8.70997e-12
    7.83898e-12
    7.05508e-12
    6.34957e-12
    5.71461e-12
    5.14315e-12
    4.62884e-12
    4.16595e-12
    3.74936e-12
    3.37442e-12
    3.03698e-12
    2.73328e-12
    2.45995e-12
    2.21396e-12
    1.99256e-12
    1.79331e-12
    1.61398e-12
    1.45258e-12
    1.30732e-12
    1.17659e-12
    1.05893e-12
    9.53037e-13
    8.57733e-13
    7.7196e-13
    6.94764e-13
    6.25287e-13
    5.62759e-13
    5.06483e-13
    4.55834e-13
    4.10251e-13
    3.69226e-13
    3.32303e-13
    2.99073e-13
    2.69166e-13
    2.42249e-13
    2.18024e-13
    1.96222e-13
    1.766e-13
    1.5894e-13
    1.43046e-13
    1.28741e-13
    1.15867e-13
    1.0428e-13
    9.38523e-14
    8.4467e-14
    7.60203e-14
    6.84183e-14
    6.15765e-14
    5.54188e-14
    4.98769e-14
    4.48892e-14
    4.04003e-14
    3.63603e-14
    3.27243e-14
    2.94518e-14
    2.65067e-14
    2.3856e-14
    2.14704e-14
    1.93233e-14
    1.7391e-14
    1.56519e-14
    1.40867e-14
    1.2678e-14
    1.14102e-14
    1.02692e-14
    9.2423e-15
    8.31807e-15
    7.48626e-15
    6.73764e-15
    6.06387e-15
    5.45748e-15
    4.91174e-15
    4.42056e-15
    3.97851e-15
    3.58066e-15
    3.22259e-15
    2.90033e-15
    2.6103e-15
    2.34927e-15
    2.11434e-15
    1.90291e-15
    1.71262e-15
    1.54135e-15
    1.38722e-15
    1.2485e-15
    1.12365e-15
    1.01128e-15
    9.10155e-16
    8.19139e-16
    7.37225e-16
    6.63503e-16
    5.97152e-16
    5.37437e-16
    4.83693e-16
    4.35324e-16
    3.91792e-16
    3.52613e-16
    3.17351e-16
    2.85616e-16
    2.57055e-16
    2.31349e-16
    2.08214e-16
    1.87393e-16
    1.68653e-16
    1.51788e-16
    1.36609e-16
    1.22948e-16
    1.10654e-16
    9.95882e-17
    8.96294e-17
    8.06664e-17
    7.25998e-17
    6.53398e-17
    5.88058e-17
    5.29253e-17
    4.76327e-17
    4.28695e-17
    3.85825e-17
    3.47243e-17
    3.12518e-17
    2.81266e-17
    2.5314e-17
    2.27826e-17
    2.05043e-17
    1.84539e-17
    1.66085e-17
    1.49477e-17
    1.34529e-17
    1.21076e-17
    1.08968e-17
    9.80716e-18
    8.82644e-18
    7.9438e-18
    7.14942e-18
    6.43448e-18
    5.79103e-18
    5.21192e-18
    4.69073e-18
    4.22166e-18
    3.79949e-18
    3.41954e-18
    3.07759e-18
    2.76983e-18
    2.49285e-18
    2.24356e-18
    2.01921e-18
    1.81729e-18
    1.63556e-18
    1.472e-18
    1.3248e-18
    1.19232e-18
    1.07309e-18
    9.6578e-19
    8.69202e-19
    7.82282e-19
    7.04054e-19
    6.33648e-19
    5.70284e-19
    5.13255e-19
    4.6193e-19
    4.15737e-19
    3.74163e-19
    3.36747e-19
    3.03072e-19
    2.72765e-19
    2.45488e-19
    2.2094e-19
    1.98846e-19
    1.78961e-19
    1.61065e-19
    1.44958e-19
    1.30463e-19
    1.17416e-19
    1.05675e-19
    9.51072e-20
    8.55965e-20
    7.70369e-20
    6.93332e-20
    6.23999e-20
    5.61599e-20
    5.05439e-20
    4.54895e-20
    4.09405e-20
    3.68465e-20
    3.31618e-20
    2.98457e-20
    2.68611e-20
    2.4175e-20
    2.17575e-20
    1.95817e-20
    1.76236e-20
    1.58612e-20
    1.42751e-20
    1.28476e-20
    1.15628e-20
    1.04065e-20
    9.36588e-21
    8.42929e-21
    7.58637e-21
    6.82773e-21
    6.14496e-21
    5.53046e-21
    4.97741e-21
    4.47967e-21
    4.03171e-21
    3.62853e-21
    3.26568e-21
    2.93911e-21
    2.6452e-21
    2.38068e-21
    2.14261e-21
    1.92835e-21
    1.73552e-21
    1.56197e-21
    1.40577e-21
    1.26519e-21
    1.13867e-21
    1.02481e-21
    9.22325e-22
    8.30092e-22
    7.47083e-22
    6.72375e-22
    6.05137e-22
    5.44624e-22
    4.90161e-22
    4.41145e-22
    3.97031e-22
    3.57328e-22
    3.21595e-22
    2.89435e-22
    2.60492e-22
    2.34443e-22
    2.10998e-22
    1.89899e-22
    1.70909e-22
    1.53818e-22
    1.38436e-22
    1.24592e-22
    1.12133e-22
    1.0092e-22
    9.08279e-23
    8.17451e-23
    7.35706e-23
    6.62135e-23
    5.95922e-23
    5.36329e-23
    4.82697e-23
    4.34427e-23
    3.90984e-23
    3.51886e-23
    3.16697e-23
    2.85027e-23
    2.56525e-23
    2.30872e-23
    2.07785e-23
    1.87007e-23
    1.68306e-23
    1.51475e-23
    1.36328e-23
    1.22695e-23
    1.10425e-23
    9.93829e-24
    8.94446e-24
    8.05002e-24
    7.24502e-24
    6.52051e-24
    5.86846e-24
    5.28162e-24
    4.75346e-24
    4.27811e-24
    3.8503e-24
    3.46527e-24
    3.11874e-24
    2.80687e-24
    2.52618e-24
    2.27356e-24
    2.04621e-24
    1.84159e-24
    1.65743e-24
    1.49168e-24
    1.34252e-24
    1.20826e-24
    1.08744e-24
    9.78694e-25
    8.80825e-25
    7.92742e-25
    7.13468e-25
    6.42121e-25
    5.77909e-25
    5.20118e-25
    4.68106e-25
    4.21296e-25
    3.79166e-25
    3.4125e-25
    3.07125e-25
    2.76412e-25
    2.48771e-25
    2.23894e-25
    2.01504e-25
    1.81354e-25
    1.63219e-25
    1.46897e-25
    1.32207e-25
    1.18986e-25
    1.07088e-25
    9.6379e-26
    8.67411e-26
    7.8067e-26
    7.02603e-26
    6.32342e-26
    5.69108e-26
    5.12197e-26
    4.60978e-26
    4.1488e-26
    3.73392e-26
    3.36053e-26
    3.02447e-26
    2.72203e-26
    2.44982e-26
    2.20484e-26
    1.98436e-26
    1.78592e-26
    1.60733e-26
    1.4466e-26
    1.30194e-26
    1.17174e-26
    1.05457e-26
    9.49112e-27
    8.54201e-27
    7.68781e-27
    6.91903e-27
    6.22712e-27
    5.60441e-27
    5.04397e-27
    4.53957e-27
    4.08562e-27
    3.67705e-27
    3.30935e-27
    2.97841e-27
    2.68057e-27
    2.41252e-27
    2.17126e-27
    1.95414e-27
    1.75872e-27
    1.58285e-27
    1.42457e-27
    1.28211e-27
    1.1539e-27
    1.03851e-27
    9.34658e-28
    8.41192e-28
    7.57073e-28
    6.81366e-28
    6.13229e-28
    5.51906e-28
    4.96716e-28
    4.47044e-28
    4.0234e-28
    3.62106e-28
    3.25895e-28
    2.93306e-28
    2.63975e-28
    2.37577e-28
    2.1382e-28
    1.92438e-28
    1.73194e-28
    1.55875e-28
    1.40287e-28
    1.26258e-28
    1.13633e-28
    1.02269e-28
    9.20424e-29
    8.28381e-29
    7.45543e-29
    6.70989e-29
    6.0389e-29
    5.43501e-29
    4.89151e-29
    4.40236e-29
    3.96212e-29
    3.56591e-29
    3.20932e-29
    2.88839e-29
    2.59955e-29
    2.33959e-29
    2.10563e-29
    1.89507e-29
    1.70556e-29
    1.53501e-29
    1.38151e-29
    1.24336e-29
    1.11902e-29
    1.00712e-29
    9.06407e-30
    8.15766e-30
    7.34189e-30
    6.6077e-30
    5.94693e-30
    5.35224e-30
    4.81702e-30
    4.33531e-30
    3.90178e-30
    3.51161e-30
    3.16044e-30
    2.8444e-30
    2.55996e-30
    2.30396e-30
    2.07357e-30
    1.86621e-30
    1.67959e-30
    1.51163e-30
    1.36047e-30
    1.22442e-30
    1.10198e-30
    9.91781e-31
    8.92603e-31
    8.03343e-31
    7.23008e-31
    6.50708e-31
    5.85637e-31
    5.27073e-31
    4.74366e-31
    4.26929e-31
    3.84236e-31
    3.45813e-31
    3.11231e-31
    2.80108e-31
    2.52097e-31
    2.26888e-31
    2.04199e-31
    1.83779e-31
    1.65401e-31
    1.48861e-31
    1.33975e-31
    1.20577e-31
    1.0852e-31
    9.76677e-32
    8.79009e-32
    7.91108e-32
    7.11998e-32
    6.40798e-32
    5.76718e-32
    5.19046e-32
    4.67142e-32
    4.20427e-32
    3.78385e-32
    3.40546e-32
    3.06492e-32
    2.75842e-32
    2.48258e-32
    2.23432e-32
    2.01089e-32
    1.8098e-32
    1.62882e-32
    1.46594e-32
    1.31935e-32
    1.18741e-32
    1.06867e-32
    9.61803e-33
    8.65623e-33
    7.79061e-33
    7.01154e-33
    6.31039e-33
    5.67935e-33
    5.11142e-33
    4.60027e-33
    4.14025e-33
    3.72622e-33
    3.3536e-33
    3.01824e-33
    2.71642e-33
    2.44477e-33
    2.2003e-33
    1.98027e-33
    1.78224e-33
    1.60402e-33
    1.44361e-33
    1.29925e-33
    1.16933e-33
    1.0524e-33
    9.47156e-34
    8.5244e-34
    7.67196e-34
    6.90477e-34
    6.21429e-34
    5.59286e-34
    5.03357e-34
    4.53022e-34
    4.07719e-34
    3.66948e-34
    3.30253e-34
    2.97228e-34
    2.67505e-34
    2.40754e-34
    2.16679e-34
    1.95011e-34
    1.7551e-34
    1.57959e-34
    1.42163e-34
    1.27947e-34
    1.15152e-34
    1.03637e-34
    9.32731e-35
    8.39458e-35
    7.55512e-35
    6.79961e-35
    6.11965e-35
    5.50769e-35
    4.95692e-35
    4.46123e-35
    4.0151e-35
    3.61359e-35
    3.25223e-35
    2.92701e-35
    2.63431e-35
    2.37088e-35
    2.13379e-35
    1.92041e-35
    1.72837e-35
    1.55553e-35
    1.39998e-35
    1.25998e-35
    1.13398e-35
    1.02059e-35
    9.18527e-36
    8.26674e-36
    7.44007e-36
    6.69606e-36
    6.02645e-36
    5.42381e-36
    4.88143e-36
    4.39329e-36
    3.95396e-36
    3.55856e-36
    3.2027e-36
    2.88243e-36
    2.59419e-36
    2.33477e-36
    2.10129e-36
    1.89117e-36
    1.70205e-36
    1.53184e-36
    1.37866e-36
    1.24079e-36
    1.11671e-36
    1.00504e-36
    9.04538e-37
    8.14085e-37
    7.32676e-37
    6.59409e-37
    5.93468e-37
    5.34121e-37
    4.80709e-37
    4.32638e-37
    3.89374e-37
    3.50437e-37
    3.15393e-37
    2.83854e-37
    2.55468e-37
    2.29922e-37
    2.06929e-37
    1.86236e-37
    1.67613e-37
    1.50852e-37
    1.35766e-37
    1.2219e-37
    1.09971e-37
    9.89737e-38
    8.90763e-38
    8.01687e-38
    7.21518e-38
    6.49366e-38
    5.8443e-38
    5.25987e-38
    4.73388e-38
    4.26049e-38
    3.83444e-38
    3.451e-38
    3.1059e-38
    2.79531e-38
    2.51578e-38
    2.2642e-38
    2.03778e-38
    1.834e-38
    1.6506e-38
    1.48554e-38
    1.33699e-38
    1.20329e-38
    1.08296e-38
    9.74664e-39
    8.77198e-39
    7.89478e-39
    7.1053e-39
    6.39477e-39
    5.75529e-39
    5.17976e-39
    4.66179e-39
    4.19561e-39
    3.77605e-39
    3.39844e-39
    3.0586e-39
    2.75274e-39
    2.47747e-39
    2.22972e-39
    2.00675e-39
    1.80607e-39
    1.62546e-39
    1.46292e-39
    1.31663e-39
    1.18496e-39
    1.06647e-39
    9.59821e-40
    8.63839e-40
    7.77455e-40
    6.99709e-40
    6.29738e-40
    5.66765e-40
    5.10088e-40
    4.59079e-40
    4.13171e-40
    3.71854e-40
    3.34669e-40
    3.01202e-40
    2.71082e-40
    2.43974e-40
    2.19576e-40
    1.97619e-40
    1.77857e-40
    1.60071e-40
    1.44064e-40
    1.29658e-40
    1.16692e-40
    1.05023e-40
    9.45204e-41
    8.50683e-41
    7.65615e-41
    6.89053e-41
    6.20148e-41
    5.58133e-41
    5.0232e-41
    4.52088e-41
    4.06879e-41
    3.66191e-41
    3.29572e-41
    2.96615e-41
    2.66953e-41
    2.40258e-41
    2.16232e-41
    1.94609e-41
    1.75148e-41
    1.57633e-41
    1.4187e-41
    1.27683e-41
    1.14915e-41
    1.03423e-41
    9.30809e-42
    8.37728e-42
    7.53955e-42
    6.7856e-42
    6.10704e-42
    5.49633e-42
    4.9467e-42
    4.45203e-42
    4.00683e-42
    3.60614e-42
    3.24553e-42
    2.92098e-42
    2.62888e-42
    2.36599e-42
    2.12939e-42
    1.91645e-42
    1.72481e-42
    1.55233e-42
    1.39709e-42
    1.25738e-42
    1.13165e-42
    1.01848e-42
    9.16634e-43
    8.2497e-43
    7.42473e-43
    6.68226e-43
    6.01403e-43
    5.41263e-43
    4.87137e-43
    4.38423e-43
    3.94581e-43
    3.55123e-43
    3.1961e-43
    2.87649e-43
    2.58884e-43
    2.32996e-43
    2.09696e-43
    1.88727e-43
    1.69854e-43
    1.52869e-43
    1.37582e-43
    1.23824e-43
    1.11441e-43
    1.00297e-43
    9.02674e-44
    8.12407e-44
    7.31166e-44
    6.58049e-44
    5.92244e-44
    5.3302e-44
    4.79718e-44
    4.31746e-44
    3.88572e-44
    3.49714e-44
    3.14743e-44
    2.83269e-44
    2.54942e-44
    2.29448e-44
    2.06503e-44
    1.85853e-44
    1.67267e-44
    1.50541e-44
    1.35487e-44
    1.21938e-44
    1.09744e-44
    9.87697e-45
    8.88927e-45
    8.00034e-45
    7.20031e-45
    6.48028e-45
    5.83225e-45
    5.24903e-45
    4.72412e-45
    4.25171e-45
    3.82654e-45
    3.44389e-45
    3.0995e-45
    2.78955e-45
    2.51059e-45
    2.25953e-45
    2.03358e-45
    1.83022e-45
    1.6472e-45
    1.48248e-45
    1.33423e-45
    1.20081e-45
    1.08073e-45
    9.72655e-46
    8.7539e-46
    7.87851e-46
    7.09066e-46
    6.38159e-46
    5.74343e-46
    5.16909e-46
    4.65218e-46
    4.18696e-46
    3.76827e-46
    3.39144e-46
    3.05229e-46
    2.74707e-46
    2.47236e-46
    2.22512e-46
    2.00261e-46
    1.80235e-46
    1.62211e-46
    1.4599e-46
    1.31391e-46
    1.18252e-46
    1.06427e-46
    9.57842e-47
    8.62058e-47
    7.75852e-47
    6.98267e-47
    6.2844e-47
    5.65596e-47
    5.09037e-47
    4.58133e-47
    4.1232e-47
    3.71088e-47
    3.33979e-47
    3.00581e-47
    2.70523e-47
    2.43471e-47
    2.19124e-47
    1.97211e-47
    1.7749e-47
    1.59741e-47
    1.43767e-47
    1.2939e-47
    1.16451e-47
    1.04806e-47
    9.43255e-48
    8.4893e-48
    7.64037e-48
    6.87633e-48
    6.1887e-48
    5.56983e-48
    5.01285e-48
    4.51156e-48
    4.06041e-48
    3.65436e-48
    3.28893e-48
    2.96004e-48
    2.66403e-48
    2.39763e-48
    2.15787e-48
    1.94208e-48
;
end;
perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);
fiscalchange=Igi-Igiss+Ige-Igess+Grd-Grdss;
% Period 1 is the pre-shock steady state (the baseline, subtracted as yd(1));
% the shock is active from period 2 on. An N-year horizon is the 4N quarters in
% indices 2:(N*4+1), so ped=N*4+1 (the slice 2:ped is inclusive of both ends).
ped=1*4+1;
multiplier_1y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=5*4+1;
multiplier_5y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=10*4+1;
multiplier_10y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=20*4+1;
multiplier_20y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
ped=25*4+1;
multiplier_25y=sum((yd(2:ped)-yd(1)))/sum((fiscalchange(2:ped)))
