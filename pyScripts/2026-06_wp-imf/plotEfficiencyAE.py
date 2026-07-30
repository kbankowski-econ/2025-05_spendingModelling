"""AE transmission of permanent spending-efficiency gap closures."""

from plotEfficiencyIRF import plot_efficiency_irfs


SCENARIOS = [
    ("Model_HumanCapital_effgi_perm", "Infrastructure efficiency", "#1565C0"),
    ("Model_HumanCapital_effge_perm", "Human-capital efficiency", "#6A1B9A"),
    ("Model_HumanCapital_effgrd_perm", "R&D efficiency", "#2E7D32"),
]


if __name__ == "__main__":
    plot_efficiency_irfs(SCENARIOS, "efficiencyAE_yd")
