
library(tidyr); library(dplyr); library(arrow); library(readr)
df <- read_csv("data/daily_counts.csv", show_col_types = FALSE)
out <- df %>%
  pivot_longer(cols = starts_with("cnt_"),
               names_to = "metric",
               values_to = "value") %>%
  mutate(metric = sub("^cnt_", "", metric)) %>%
  group_by(date, metric) %>%
  summarise(total = sum(value, na.rm = TRUE), .groups="drop") %>%
  pivot_wider(names_from = metric, values_from = total) %>%
  arrange(date)
write_parquet(out, "expected/007.parquet")
