"""AE efficiency-gap closures with corresponding fiscal-shock IRFs."""

from plotEfficiencyIRF import plot_efficiency_irfs


SCENARIOS = [
    ("Model_HumanCapital_effgi_perm", "Infrastructure efficiency", "#1565C0", "solid"),
    ("Model_HumanCapital_effge_perm", "Human-capital efficiency", "#6A1B9A", "solid"),
    ("Model_HumanCapital_effgrd_perm", "R&D efficiency", "#2E7D32", "solid"),
    ("Model_HumanCapital_exp_igi_perm", "Infrastructure spending", "#1565C0", "dot"),
    ("Model_HumanCapital_exp_ige_perm", "Human-capital spending", "#6A1B9A", "dot"),
    ("Model_HumanCapital_exp_grd_perm", "R&D spending", "#2E7D32", "dot"),
]


if __name__ == "__main__":
    plot_efficiency_irfs(SCENARIOS, "efficiencyAE_yd")
