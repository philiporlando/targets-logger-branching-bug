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
      logger::log_info("{Sys.time()} this is a single log!")
    }
  ),
  tar_target(
    branches,
    {
      1:10
    }
  ),
  # Uncomment this target to reproduce the bug
  # tar_target(
  #   test_log_with_branching,
  #   test_logger(set_log, i=branches),
  #   pattern = map(branches)
  # ),
  tar_target(
    test_log_without_branching,
    test_logger(set_log, i=1)
  )
)