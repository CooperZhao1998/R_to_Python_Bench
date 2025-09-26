
# Task 2: groupby + aggregate  -> expected/002.csv
library(dplyr); library(readr); library(lubridate)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  mutate(dep_date = as.Date(dep_time)) %>%
  group_by(carrier, dep_date) %>%
  summarise(
    n = dplyr::n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(carrier, dep_date)
write_csv(out, "expected/002.csv", na = "")
