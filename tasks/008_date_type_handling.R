
# Task 8: date type handling -> expected/008.csv
library(dplyr); library(readr); library(lubridate)
df <- read_csv("data/events.csv", show_col_types = FALSE)
out <- df %>%
  mutate(
    ts_utc = with_tz(ymd_hms(timestamp, tz="UTC"), tzone = "UTC"),
    day = floor_date(ts_utc, "day"),
    hour = hour(ts_utc),
    wday = wday(ts_utc, label = TRUE, week_start = 1)
  ) %>%
  group_by(day, hour) %>%
  summarise(n = n(), .groups="drop") %>%
  arrange(day, hour)
write_csv(out, "expected/008.csv", na = "")
