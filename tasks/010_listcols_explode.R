
library(dplyr); library(tidyr); library(arrow); library(readr)
df <- read_csv("data/flights.csv", show_col_types = FALSE) %>%
  mutate(dest_split = strsplit(as.character(dest), "")) %>%
  select(carrier, dest_split)
out <- df %>% unnest(dest_split) %>%
  group_by(carrier, dest_split) %>%
  summarise(n = n(), .groups="drop") %>%
  arrange(carrier, dest_split)
write_parquet(out, "expected/010.parquet")
