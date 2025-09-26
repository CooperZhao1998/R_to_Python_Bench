
# Task 10: dataframe calculation and append -> expected/010.csv
library(dplyr); library(readr)
fl <- read_csv("data/flights.csv", show_col_types = FALSE)
extra <- read_csv("data/extra_rows.csv", show_col_types = FALSE)
summary1 <- fl %>%
  group_by(carrier, dest) %>%
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    flights = dplyr::n(),
    .groups = "drop"
  )
extra2 <- extra %>% select(carrier, dest, avg_dep_delay, flights)
out <- bind_rows(summary1, extra2) %>%
  arrange(carrier, dest)
write_csv(out, "expected/010.csv", na = "")
