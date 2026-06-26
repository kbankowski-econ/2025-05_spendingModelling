%% Cross-check: our canonical NK vs Gali (2015, Ch.3) + government block.
% Runs three perfect-foresight models under an identical AR(1) Gc shock:
%   B   = ours_g.mod                 (our NK FOCs, Gali calibration, alppha=0)
%   A0  = gali_g.mod  -DALPHA=0       (Gali FOCs + G, constant returns)
%   A25 = gali_g.mod  -DALPHA=0.25    (Gali baseline DRS)
% B vs A0 should match to numerical precision (equation equivalence); A25 shows
% the alppha=1/4 baseline (sign unchanged).

here = fileparts(mfilename('fullpath'));
cd(here);

global oo_ M_

dynare ours_g.mod nograph nointeractive;
B.endo = oo_.endo_simul;  B.ss = oo_.steady_state;  B.names = cellstr(M_.endo_names);

dynare gali_g.mod -DALPHA=0 nograph nointeractive;
A0.endo = oo_.endo_simul; A0.ss = oo_.steady_state; A0.names = cellstr(M_.endo_names);

dynare gali_g.mod -DALPHA=0.25 nograph nointeractive;
A25.endo = oo_.endo_simul; A25.ss = oo_.steady_state; A25.names = cellstr(M_.endo_names);

% (gali name, our name, panel title)
map = {
    'Y','yd','Output Y'
    'C','C','Consumption C'
    'N','N','Hours N'
    'Pi','PI','Inflation \Pi'
    'W_real','W_real','Real wage W/P'
    'MC','mc','Marginal cost'
    'R','R','Nominal rate R'
    'G','Gc','Govt spending G'
};

H = 60;   % compare/plot first 60 quarters
pdev = @(S, nm) ( S.endo(strcmp(S.names, nm), 1:H) ./ S.ss(strcmp(S.names, nm)) - 1 ) * 100;

fprintf('\n==== max |percent-deviation difference|, ours vs Gali(alppha=0), first %d q ====\n', H);
maxdiff = 0;
for k = 1:size(map,1)
    pB  = pdev(B,   map{k,2});
    pA0 = pdev(A0,  map{k,1});
    d = max(abs(pB - pA0));
    maxdiff = max(maxdiff, d);
    fprintf('  %-16s  ours impact=%+8.4f  gali impact=%+8.4f  max|diff|=%.2e\n', ...
            map{k,3}, pB(2), pA0(2), d);
end
fprintf('  ----> overall max |diff| (ours vs Gali alppha=0) = %.3e\n', maxdiff);

% impact comparison vs the DRS baseline (alppha=1/4)
fprintf('\n==== impact (quarter 1) percent deviation: ours vs Gali DRS(alppha=1/4) ====\n');
for k = 1:size(map,1)
    pB   = pdev(B,   map{k,2});
    pA25 = pdev(A25, map{k,1});
    fprintf('  %-16s  ours=%+8.4f   gali alppha=0.25=%+8.4f\n', map{k,3}, pB(2), pA25(2));
end

%% overlay plot
t = 0:H-1;
f = figure('Visible','off','Position',[0 0 1100 700]);
for k = 1:size(map,1)
    subplot(2,4,k); hold on; grid on;
    plot(t, pdev(B,  map{k,2}), '-',  'LineWidth', 3, 'Color', [0.42 0.11 0.61]);
    plot(t, pdev(A0, map{k,1}), '--', 'LineWidth', 1.5, 'Color', [0 0.6 0.5]);
    plot(t, pdev(A25,map{k,1}), ':',  'LineWidth', 1.5, 'Color', [0.9 0.32 0]);
    title(map{k,3}); xlim([0 H-1]);
    if k==1, legend({'ours (\alpha=0)','Gali (\alpha=0)','Gali (\alpha=1/4)'}, ...
                    'Location','best','FontSize',7); end
end
sgtitle('Gc shock: our canonical NK vs Gali (2015, Ch.3) + government block');
print(f, fullfile(here,'gali_compare.png'), '-dpng', '-r150');
fprintf('\nSaved gali_compare.png\n');
