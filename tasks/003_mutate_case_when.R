
library(dplyr); library(arrow); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  mutate(delay_bucket = case_when(
    is.na(dep_delay) ~ NA_character_,
    dep_delay <= 0 ~ "on_time_or_early",
    dep_delay <= 15 ~ "minor",
    dep_delay <= 60 ~ "moderate",
    TRUE ~ "severe"
  )) %>%
  select(carrier, dep_delay, delay_bucket) %>%
  arrange(carrier, dep_delay)
write_parquet(out, "expected/003.parquet")
