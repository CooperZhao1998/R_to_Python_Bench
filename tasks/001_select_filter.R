
library(dplyr); library(arrow); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  select(carrier, dep_delay, arr_delay) %>%
  filter(!is.na(dep_delay), dep_delay > 10, arr_delay <= 60) %>%
  arrange(carrier, dep_delay)
write_parquet(out, "expected/001.parquet")
