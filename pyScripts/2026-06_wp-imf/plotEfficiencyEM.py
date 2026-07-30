"""EMDE transmission of permanent spending-efficiency gap closures."""

from plotEfficiencyIRF import plot_efficiency_irfs


SCENARIOS = [
    ("EM_Model_HumanCapital_effgi_perm", "Infrastructure efficiency", "#1565C0"),
    ("EM_Model_HumanCapital_effge_perm", "Human-capital efficiency", "#6A1B9A"),
]


if __name__ == "__main__":
    plot_efficiency_irfs(SCENARIOS, "efficiencyEM_yd")
