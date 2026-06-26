/*
 * Galí (2015, Ch.3) baseline NK FOCs (Pfeifer's nonlinear replication), trimmed
 * to the real/nominal core and EXTENDED with a wasteful, lump-sum-financed
 * government-consumption block (Y = C + G). Solved in perfect foresight with an
 * AR(1) government-spending shock. alppha is set by -DALPHA (default 0) so the
 * same file gives the constant-returns case (exact match to our NK) and the
 * Galí baseline DRS case (alppha = 1/4).
 */
@#ifndef ALPHA
    @#define ALPHA = 0
@#endif

var C W_real Pi N R realinterest Y Q S Pi_star x_aux_1 x_aux_2 MC G g_ar;
varexo eps_g;
parameters betta siggma varphi phi_pi phi_y epsilon theta alppha tau G_share rho_g;

siggma  = 1;
varphi  = 5;
phi_pi  = 1.5;
phi_y   = 0.125;
theta   = 0.75;
betta   = 0.99;
alppha  = @{ALPHA};
epsilon = 9;
tau     = 0;
G_share = 0.18;
rho_g   = 0.9;

model;
    [name='FOC labor']
    W_real = C^siggma*N^varphi;
    [name='Euler equation']
    Q = betta*(C(+1)/C)^(-siggma)/Pi(+1);
    [name='Definition nominal rate']
    R = 1/Q;
    [name='Aggregate production']
    Y = (N/S)^(1-alppha);
    [name='Definition real rate']
    R = realinterest*Pi(+1);
    [name='Taylor rule (no smoothing), Gali eq.(22)']
    R = 1/betta*Pi^phi_pi*(Y/steady_state(Y))^phi_y;
    [name='Market clearing with government']
    Y = C + G;
    [name='Government consumption (lump-sum financed), 1% of SS GDP impact']
    G = G_share*steady_state(Y) + steady_state(Y)*g_ar;
    [name='AR(1) government-spending process']
    g_ar = rho_g*g_ar(-1) + eps_g;
    [name='Definition marginal cost']
    MC = W_real/((1-alppha)*Y/N*S);
    [name='LOM prices']
    1 = theta*Pi^(epsilon-1)+(1-theta)*(Pi_star)^(1-epsilon);
    [name='LOM price dispersion']
    S = (1-theta)*Pi_star^(-epsilon/(1-alppha))+theta*Pi^(epsilon/(1-alppha))*S(-1);
    [name='FOC price setting']
    Pi_star^(1+epsilon*(alppha/(1-alppha))) = x_aux_1/x_aux_2*(1-tau)*epsilon/(epsilon-1);
    [name='Price recursion 1']
    x_aux_1 = C^(-siggma)*Y*MC+betta*theta*Pi(+1)^(epsilon+alppha*epsilon/(1-alppha))*x_aux_1(+1);
    [name='Price recursion 2']
    x_aux_2 = C^(-siggma)*Y+betta*theta*Pi(+1)^(epsilon-1)*x_aux_2(+1);
end;

steady_state_model;
    S = 1; Pi_star = 1; Pi = 1;
    MC = (epsilon-1)/epsilon/(1-tau);
    R = 1/betta; Q = 1/R; realinterest = R;
    % alppha-general SS: S=1, Y=N^(1-alppha), W_real=MC*(1-alppha)*Y/N,
    % W_real=C*N^varphi, C=(1-G_share)*Y  ->  N=(MC*(1-alppha)/(1-G_share))^(1/(1+varphi))
    N = (MC*(1-alppha)/(1-G_share))^(1/(1+varphi));
    Y = N^(1-alppha);
    G = G_share*Y;
    C = Y - G;
    g_ar = 0;
    W_real = C^siggma*N^varphi;
    x_aux_1 = C^(-siggma)*Y*MC/(1-betta*theta);
    x_aux_2 = C^(-siggma)*Y/(1-betta*theta);
end;

steady;
check;

shocks;
    var eps_g; periods 1; values 0.01;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;
