
# Task 7: string handling -> expected/007.csv
library(dplyr); library(readr); library(stringr)
df <- read_csv("data/messages.csv", show_col_types = FALSE)
out <- df %>%
  mutate(
    text_clean = str_squish(str_to_lower(text)),
    has_email = str_detect(text_clean, "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"),
    email_domain = str_extract(text_clean, "(?<=@)[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"),
    word_count = str_count(text_clean, "\\S+")
  ) %>%
  select(id, text_clean, has_email, email_domain, word_count) %>%
  arrange(id)
write_csv(out, "expected/007.csv", na = "")
