
library(dplyr); library(arrow); library(lubridate); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  mutate(dep_date = as.Date(dep_time)) %>%
  group_by(carrier, dep_date) %>%
  summarise(
    n = dplyr::n(),
    avg_delay = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(carrier, dep_date)
write_parquet(out, "expected/002.parquet")
