
library(dplyr); library(arrow); library(readr)
fl <- read_csv("data/flights.csv", show_col_types = FALSE)
cr <- read_csv("data/carriers.csv", show_col_types = FALSE) %>% filter(name %in% c("Delta Air Lines Inc.","United Air Lines Inc."))
out <- fl %>% semi_join(cr, by="carrier") %>% arrange(carrier, dep_time)
write_parquet(out, "expected/005.parquet")
