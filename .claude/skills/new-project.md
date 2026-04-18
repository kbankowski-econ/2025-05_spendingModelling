---
name: new-project
description: Set up a new chart project by replicating the standard structure from an existing project.
user-invocable: true
---

# New Project Skill

When the user asks to create a new chart project:

1. **Pick a source project** to replicate (e.g., `pyScripts/2026-04_EDN_nabe-symposium/`).

2. **Create the new directory** at `pyScripts/<new-project-name>/` and copy:
   - `chartConfig.json` (styling config with palette, fonts, dimensions)
   - `fiscal_common.py` (shared utilities including `get_chart_dims_px`)
   - `tasks.py` (empty task runner template)
   - `fiscal_config.json` (update `base_path` to `../../docu/<new-project-name>`)
   - `chartTable.csv` (empty, header only)

3. **Create the output directory** at `docu/<new-project-name>/`.

4. **Update `fiscal_config.json`** to point to the new output directory.

5. **Update `tasks.py`** with the new project name in the docstring.

6. **Clear `chartTable.csv`** to just the header row:
   ```
   id,pngFile,task,Title,Subtitle,Sources,Notes,Width,Height
   ```

7. **Remove `__pycache__`** if copied.

8. **Commit** with message like "add <project-name> project scaffold".
