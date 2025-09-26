
# Task 3: missing value handle  -> expected/003.csv
library(dplyr); library(readr); library(tidyr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  mutate(
    dep_delay_filled = if_else(is.na(dep_delay), 0, dep_delay),
    arr_delay_filled = coalesce(arr_delay, 0)
  ) %>%
  filter(!is.na(dest)) %>%
  select(carrier, dest, dep_delay, arr_delay, dep_delay_filled, arr_delay_filled) %>%
  arrange(carrier, dest, dep_delay_filled, arr_delay_filled)
write_csv(out, "expected/003.csv", na = "")
