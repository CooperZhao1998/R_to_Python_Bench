
# Task 4: join (inner, left, right) -> expected/004.csv
library(dplyr); library(readr)
fl <- read_csv("data/flights.csv", show_col_types = FALSE)
cr <- read_csv("data/carriers.csv", show_col_types = FALSE)

inner <- fl %>% inner_join(cr, by="carrier") %>%
  select(carrier, dep_time, dep_delay, arr_delay, dest, tailnum, name) %>%
  mutate(join_type = "inner")

left <- fl %>% left_join(cr, by="carrier") %>%
  select(carrier, dep_time, dep_delay, arr_delay, dest, tailnum, name) %>%
  mutate(join_type = "left")

right <- right_join(fl, cr, by="carrier") %>%
  select(carrier, dep_time, dep_delay, arr_delay, dest, tailnum, name) %>%
  mutate(join_type = "right")

out <- bind_rows(inner, left, right) %>%
  arrange(join_type, carrier, dep_time)
write_csv(out, "expected/004.csv", na = "")
