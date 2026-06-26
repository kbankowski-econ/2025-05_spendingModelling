%% Why does ours deflate but Gali's calibration inflate? Sweep the Frisch
% elasticity (phi = inverse Frisch) in the SAME (verified-equivalent) NK model,
% holding everything else at Gali's calibration, at two persistences. Reports the
% impact (quarter-1) percent-deviation of inflation and the real wage.
here = fileparts(mfilename('fullpath')); cd(here);
global oo_ M_ options_

dynare ours_g.mod nograph nointeractive;
iPI = strcmp(cellstr(M_.endo_names),'PI');
iW  = strcmp(cellstr(M_.endo_names),'W_real');
iYd = strcmp(cellstr(M_.endo_names),'yd');
ssPI = oo_.steady_state(iPI); ssW = oo_.steady_state(iW); ssYd = oo_.steady_state(iYd);

phis = [5 3 2 1.2 0.8 0.5 0.2];          % inverse Frisch (Frisch = 1/phi)
rhos = [0.9 0.99];

for rg = rhos
    set_param_value('rho_g', rg);
    fprintf('\n==== rho_g = %.2f : impact (q1) percent deviations ====\n', rg);
    fprintf('  phi(1/Frisch)  Frisch    Inflation     RealWage      Output\n');
    for ph = phis
        set_param_value('phi', ph);
        options_.periods = 200;
        perfect_foresight_setup;
        perfect_foresight_solver;
        e = oo_.endo_simul;
        pPI = (e(iPI,2)/ssPI - 1)*100;
        pW  = (e(iW,2) /ssW  - 1)*100;
        pYd = (e(iYd,2)/ssYd - 1)*100;
        fprintf('  %6.2f       %6.3f   %+9.4f   %+9.4f   %+9.4f\n', ph, 1/ph, pPI, pW, pYd);
    end
end
fprintf('\n(phi=5 is Gali''s textbook value; phi=1.2 is our paper''s calibration.)\n');
