# r2py-bench-csv
A reproducible benchmark to test AI's ability to convert **R (tidyverse)** to **Python (Pandas/Polars)** on dataframe manipulation.

## Tasks (all outputs are CSV)
1. **select + filter** → expected/001.csv
2. **groupby + aggregate** → expected/002.csv
3. **missing value handle** → expected/003.csv
4. **join (inner, left, right)** → expected/004.csv (combined with a `join_type` column)
5. **pivot** → expected/005.csv
6. **window function** → expected/006.csv
7. **string handling** → expected/007.csv
8. **date type handling** → expected/008.csv
9. **conditional column creation** → expected/009.csv
10. **dataframe calculation and append** → expected/010.csv

## Data
- `data/flights.csv`, `data/carriers.csv`: Joins, windows, conditionals, missing values.
- `data/daily_counts.csv`: Pivot tests.
- `data/events.csv`: Datetime parsing + grouping.
- `data/messages.csv`: String/regex cleaning, domain extraction.
- `data/extra_rows.csv`: Appending to summary in Task 10.

## How to create ground-truth (R)
In R:
```r
setwd("r2py-bench-csv")
source("harness/r_make_expected.R")
```

## How to grade (Python)
```bash
cd r2py-bench-csv
pip install pandas numpy
python harness/grade_python.py
```

## Prompting AIs
Use `harness/ai_prompt_template.txt`. Ensure each AI script **writes** the result to `ai_outputs/NNN.csv` (no index).

## Notes
- Task 4 merges **inner/left/right** outputs together with a `join_type` column for a single CSV.
- If your real R code differs, drop it into `tasks/`, output to `expected/###.csv`, update `task_manifest.json`, and re-run the grader.
