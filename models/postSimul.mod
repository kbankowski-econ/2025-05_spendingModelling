perfect_foresight_setup(periods=2000);
perfect_foresight_solver(maxit=20);

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
