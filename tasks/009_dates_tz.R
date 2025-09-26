
library(dplyr); library(lubridate); library(arrow); library(readr)
df <- read_csv("data/events.csv", show_col_types = FALSE)
out <- df %>%
  mutate(
    ts_utc = with_tz(ymd_hms(timestamp, tz="UTC"), tzone = "UTC"),
    day = floor_date(ts_utc, "day")
  ) %>%
  group_by(user_id, day) %>%
  summarise(n = n(), .groups="drop") %>%
  arrange(user_id, day)
write_parquet(out, "expected/009.parquet")
