%% Does the paper's deflation survive a Gali-like Frisch elasticity?
% Takes OUR paper calibration (ours_paper.mod = the fig:persistenceGc model) and,
% at the standard AR(1) persistence rho=0.9 (and rho=0.99 for reference), sweeps
% the inverse Frisch elasticity phi from the paper's 1.2 (Frisch 0.83) up to
% Gali's textbook 5 (Frisch 0.2). Reports impact (q1) annualized-pp inflation and
% percent-dev real wage / output, and saves an IRF overlay (phi=1.2 vs phi=5).
here = fileparts(mfilename('fullpath')); cd(here);
global oo_ M_ options_

dynare ours_paper.mod nograph nointeractive;
iPI = strcmp(cellstr(M_.endo_names),'PI');
iW  = strcmp(cellstr(M_.endo_names),'W_real');
iYd = strcmp(cellstr(M_.endo_names),'yd');
ssW = oo_.steady_state(iW); ssYd = oo_.steady_state(iYd);   % PI_ss = 1

phis = [1.2 2 3 5];     % inverse Frisch; 1.2 = paper, 5 = Gali
H = 40;
store = struct();       % keep IRFs for the phi=1.2 and phi=5 overlay at rho=0.9

for rg = [0.9 0.99]
    set_param_value('rho_g', rg);
    fprintf('\n==== OUR calibration, rho_g = %.2f : impact (q1) ====\n', rg);
    fprintf('  phi (Frisch)   Inflation(ann pp)   RealWage(%%)   Output(%%)\n');
    for ph = phis
        set_param_value('phi', ph);
        options_.periods = 400;
        perfect_foresight_setup;
        perfect_foresight_solver;
        e = oo_.endo_simul;
        PIann = (e(iPI,:) - 1)*400;                  % annualized pp, change in gross qtr rate x400
        Wp    = (e(iW,:)/ssW  - 1)*100;
        Ydp   = (e(iYd,:)/ssYd - 1)*100;
        fprintf('  %4.2f (%4.2f)    %+10.4f        %+8.4f     %+8.4f\n', ...
                ph, 1/ph, PIann(2), Wp(2), Ydp(2));
        if rg == 0.9 && (ph == 1.2 || ph == 5)
            tag = sprintf('p%02d', round(ph*10));
            store.(tag).PI = PIann(1:H); store.(tag).W = Wp(1:H); store.(tag).Yd = Ydp(1:H);
        end
    end
end

%% IRF overlay at rho=0.9: paper Frisch (phi=1.2) vs Gali Frisch (phi=5)
t = 0:H-1;
f = figure('Visible','off','Position',[0 0 1100 320]);
pan = {'PI','Inflation (annualized pp)'; 'W','Real wage (%)'; 'Yd','Output (%)'};
for k = 1:3
    subplot(1,3,k); hold on; grid on;
    plot(t, store.p12.(pan{k,1}), '-',  'LineWidth', 3, 'Color', [0.42 0.11 0.61]);
    plot(t, store.p50.(pan{k,1}), '--', 'LineWidth', 2, 'Color', [0.9 0.32 0]);
    yline(0,'k-'); title(pan{k,2}); xlim([0 H-1]); xlabel('quarters');
    if k==1, legend({'\phi=1.2 (paper, Frisch 0.83)','\phi=5 (Gali, Frisch 0.2)'}, ...
                    'Location','best','FontSize',8); end
end
sgtitle('Gc shock, AR(1) \rho=0.9, OUR calibration: paper vs Gali-like Frisch');
print(f, fullfile(here,'frisch_rho09.png'), '-dpng', '-r150');
fprintf('\nSaved frisch_rho09.png\n');
