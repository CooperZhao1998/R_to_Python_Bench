
library(dplyr); library(arrow); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  group_by(carrier) %>%
  arrange(dep_delay, .by_group=TRUE) %>%
  mutate(rn = row_number()) %>%
  filter(rn <= 3) %>%
  ungroup() %>%
  select(carrier, dep_delay, rn)
write_parquet(out, "expected/008.parquet")
