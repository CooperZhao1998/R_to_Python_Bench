# ai_outputs/002.py  (Pandas reference) — writes ai_outputs/002.csv
import pandas as pd
df = pd.read_csv("data/flights.csv", parse_dates=["dep_time"]).copy()
df["dep_date"] = df["dep_time"].dt.date
out = (
    df.groupby(["carrier","dep_date"], as_index=False)
      .agg(n=("dep_time","size"),
           avg_dep_delay=("dep_delay", lambda s: pd.Series(s, dtype="float64").mean(skipna=True)))
      .sort_values(["carrier","dep_date"], kind="mergesort")
)
out.to_csv("ai_outputs/002.csv", index=False)
