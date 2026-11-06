.onAttach <- function(libname, pkgname) {
  # Only display the message in interactive sessions
  if (interactive()) {
    # Use cli formatting to create a styled alert or header
    cli::cli_rule(paste0(
      "Welcome to {.pkg {pkgname}} (v{utils::packageVersion(pkgname)})"
    ))
    cli::cli_alert_warning(paste0(
      "This package is currently in {.strong BETA}."
    ))
    issue_url <- "https://github.com/Ecosystem-Indicators-Workflows/ecoSynthesis/issues"
    cli::cli_inform(c(
      "i" = "Features and functions are subject to change.",
      "x" = "Please report any bugs or feedback to {.url {issue_url}}."
    ))
  }
}
