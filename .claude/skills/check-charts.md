---
name: check-charts
description: Verify all charts in chartTable.csv — check dimensions match, no orphan files, consistent formatting.
user-invocable: true
---

# Check Charts Skill

When the user asks to check chart consistency, run these checks on the target project:

1. **Dimensions check**: For each row in `chartTable.csv`, verify the PNG exists and its pixel dimensions match `Width × Height` (cm) at scale=2 (1 cm = 37.795 px, doubled).

2. **Orphan check**: List any PNG files in the output directory (`docu/<project>/`) that are NOT referenced in `chartTable.csv`. Offer to delete them.

3. **Title consistency**: Check all Title entries for:
   - Embedded line breaks (should be removed).
   - "US" vs "U.S." vs "USA" (standardize to "US").
   - Proper Title Case.

4. **Subtitle consistency**: Check all Subtitle entries are in parentheses.

5. **Sources consistency**: Check:
   - Prefix: "Source:" (singular, no semicolons in body) or "Sources:" (plural).
   - Ends with a period.
   - No embedded line breaks.

6. **Notes consistency**: Check:
   - Prefix: "Note:" or empty.
   - Year ranges use en-dash (–) not hyphen (-).
   - No embedded line breaks.

7. **Report results** as a table showing OK/ISSUE per row.
