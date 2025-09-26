# ai_outputs/001.py  (Pandas reference)
import pandas as pd

# Read CSV (or Parquet if you prefer and it exists)
df = pd.read_csv("data/flights.csv", parse_dates=["dep_time"])
out = (
    df.loc[:, ["carrier","dep_delay","arr_delay"]]
      .loc[lambda d: d["dep_delay"].notna()]
      .loc[lambda d: (d["dep_delay"] > 10) & (d["arr_delay"] <= 60)]
      .sort_values(["carrier","dep_delay"], kind="mergesort")
)
