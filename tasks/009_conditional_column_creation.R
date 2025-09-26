
# Task 9: conditional column creation -> expected/009.csv
library(dplyr); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  mutate(bucket = case_when(
    is.na(dep_delay) ~ NA_character_,
    dep_delay <= 0 ~ "on_time_or_early",
    dep_delay <= 15 ~ "minor",
    dep_delay <= 60 ~ "moderate",
    TRUE ~ "severe"
  )) %>%
  select(carrier, dep_delay, bucket) %>%
  arrange(carrier, dep_delay)
write_csv(out, "expected/009.csv", na = "")
