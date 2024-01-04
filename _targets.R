library(targets)

controller <- crew::crew_controller_local(
  workers = future::availableCores() - 1,
  seconds_idle = 3
)

# Set target options:
tar_option_set(
  packages = c("logger"),
  format = "qs",
  controller = controller,
  garbage_collection = TRUE,
  memory = "transient",
  iteration = "vector"
)

source("R/log-utils.R")

list(
  tar_target(
    set_log, {
      set_logger("_targets.log", overwrite = TRUE)
      TRUE
    }
  ),
  tar_target(
    test_log_directly, {
      set_log # Establish dependency
      logger::log_info("{Sys.time()} this log works!")
    }
  ),
  tar_target(
    branches,
    {
      1:10
    }
  ),
  tar_target(
    test_log_from_function,
    test_logger(branches),
    pattern = map(branches)
  )
)
