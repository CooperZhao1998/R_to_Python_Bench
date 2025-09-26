# ai_outputs/001.py  (Pandas reference) — writes ai_outputs/001.csv
import pandas as pd
df = pd.read_csv("data/flights.csv", parse_dates=["dep_time"])
out = (
    df.loc[:, ["carrier","dep_delay","arr_delay","dest"]]
      .loc[lambda d: d["dep_delay"].notna()]
      .loc[lambda d: (d["dep_delay"] > 10) & (d["arr_delay"] <= 60)]
      .sort_values(["carrier","dep_delay","dest"], kind="mergesort")
)
out.to_csv("ai_outputs/001.csv", index=False)
