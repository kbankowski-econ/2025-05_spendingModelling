# Why is infrastructure investment more inflationary than government consumption?

*Draft response to the question: in a standard DSGE model demand shocks are
inflationary and supply shocks deflationary, so shouldn't the infrastructure
shock — which also expands supply — produce* less *inflation than government
consumption, especially after some time?*

The supply-side intuition is correct about the mechanism but not about where it
shows up. The model contains exactly the predicted result — in the temporary
case. Three demand-side channels dominate during the build-out phase.

## 1. Wealth effects run in opposite directions

Government consumption is pure waste, so it triggers a large negative wealth
effect: consumption drops 1.7 percent on impact and stays depressed, and labor
supply rises persistently (+0.3 percent). Both are *dis*inflationary — this is
why the government-consumption shock is nearly price-neutral (about 0.05
percentage point) despite being "pure demand."

Infrastructure raises permanent income. Consumption falls only half as much on
impact and turns *positive* from about year 8, reaching +2.4 percent by 2050.

## 2. Crowding-in is itself demand

Public capital raises the marginal product of private capital, so private
investment rises strongly (+1.7 percent at 10 years, +3 percent at 25 years).
Installing that private capacity is current demand.

Appendix "Government Consumption: Robustness to Model Structure" makes the
underlying point: inflation in this model operates through the private-capital
adjustment channel — once private capital and its factor-demand conditions are
removed, real marginal cost and inflation stay at steady state. Infrastructure
triggers a far larger private-capital adjustment than government consumption,
hence more inflation.

## 3. Capacity arrives with a lag, demand does not

Public capital builds over decades, while the purchases, the consumption
response, and the investment response are front-loaded. Throughout the
transition, demand runs slightly ahead of the capacity being created.

## Where the supply-side intuition does appear

It appears twice in the reported results.

**Within the permanent infrastructure path.** Inflation peaks around year 5
(0.33 percentage point) and then falls steadily (0.15 by year 25) as capacity
comes online: the supply effect increasingly offsets the demand pressure.

**In the temporary shock (decisive).** Under the persistent AR(1) expansion,
infrastructure inflation crosses below government consumption around year 10
and turns outright **negative** (−0.02 percentage point) from about year 15.
Spending has faded, but the accumulated public capital persists — what remains
is exactly the deflationary supply shock. Under a permanent expansion that
crossover never occurs, because demand (consumption plus crowding-in
investment) grows in step with capacity indefinitely.

## Bottom line

The ranking is not an anomaly. It is the standard result for productive public
spending in New Keynesian models with investment adjustment: during the
build-out phase, productive spending is *more* inflationary than wasteful
spending precisely because it is more expansionary, and the supply-side
disinflation dominates only after the demand impulse fades.

## Reference numbers (AE calibration, +1 percent of GDP, debt-financed)

Permanent shocks (annualized percentage-point deviations):

| Quarter | Inflation, Gc | Inflation, infra | C, Gc | C, infra | Ip, infra | L, Gc | L, infra |
|---|---|---|---|---|---|---|---|
| 1 | 0.07 | 0.26 | −1.69 | −0.79 | −0.29 | 0.57 | 0.79 |
| 20 (5y) | 0.05 | 0.33 | −1.58 | −0.30 | +0.46 | 0.32 | 0.29 |
| 40 (10y) | 0.04 | 0.30 | −1.45 | +0.53 | +1.65 | 0.32 | 0.30 |
| 100 (25y) | 0.02 | 0.15 | −1.19 | +2.43 | +3.03 | 0.30 | 0.14 |

Temporary shocks (AR(1), persistence 0.9), inflation only:

| Quarter | Gc | Infrastructure |
|---|---|---|
| 1 | 0.10 | 0.18 |
| 20 (5y) | 0.05 | 0.07 |
| 40 (10y) | 0.03 | 0.00 |
| 60 (15y) | 0.02 | −0.02 |
| 100 (25y) | 0.01 | −0.02 |

Source: `figures/standardShocksAEPerm.csv` and `figures/standardShocksAE.csv`.

## Possible paper edit

A referee with the same intuition will ask this. Two or three sentences in
Section 4.1 could preempt it, noting (i) the opposing wealth effects, (ii) the
crowding-in channel, and (iii) the temporary-shock sign flip visible in the
appendix figure.
