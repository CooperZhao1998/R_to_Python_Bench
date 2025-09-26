
# Task 6: window function -> expected/006.csv
library(dplyr); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE)
out <- df %>%
  group_by(carrier) %>%
  arrange(dep_delay, .by_group = TRUE) %>%
  mutate(
    rn = dplyr::row_number(),
    rnk = dplyr::dense_rank(dep_delay)
  ) %>%
  filter(rn <= 3) %>%
  ungroup() %>%
  select(carrier, dep_delay, rn, rnk) %>%
  arrange(carrier, rn, dep_delay)
write_csv(out, "expected/006.csv", na = "")
