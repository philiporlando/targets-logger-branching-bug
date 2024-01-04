`%>%` <- magrittr::`%>%`

set_logger <- function(log_file, log_dir = "./log", overwrite = TRUE) {
  if (!fs::dir_exists(log_dir)) {
    fs::dir_create(log_dir)
  }
  name <- log_file %>%
    fs::path_file() %>%
    fs::path_ext_remove()
  log_file <- fs::path(log_dir, glue::glue("{name}.log"))
  if (overwrite & fs::file_exists(log_file)) {
    message("Overwriting existing log file...")
    fs::file_delete(log_file)
  }
  logger::log_threshold(logger::TRACE)
  logger::log_appender(logger::appender_tee(log_file))
  return(log_file %>% fs::path_abs() %>% invisible())
}

test_logger <- function(i) {
  logger::log_info("{Sys.time()} this log fails for {i}...")  
}