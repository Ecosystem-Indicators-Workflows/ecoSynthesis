make_test_input_table <- function() {
  data.frame(
    re1 = c(
      "Semi-deciduous Forest",
      "Deciduous Forest",
      "Wet Montane Forest",
      "Dry Montane Forest"
    ),
    efg_1 = c("T1.1", "T1.2", "T1.1", "T1.2"),
    memb_1 = c(80, 80, 70, 50) / 100,
    efg_2 = c("T1.2", "T1.1", "T1.3", "T1.3"),
    memb_2 = c(20, 20, 30, 50) / 100
  )
}

make_test_membership_tbl <- function() {
  # "HSW" VEGCODE is used as a test case because it has multiple memberships and interpreters in the TASVEG_xref dataset.
  data.frame(
    stringsAsFactors = FALSE,
    VEGCODE = c("HSW", "HSW", "HSW", "HSW", "HSW", "HSW"),
    efg = c("T6.4", "T6.4", "T6.4", "TF7.2", "T6.4", "TF1.6"),
    memb = c(1, 1, 0.95, 0.05, 0.5, 0.5),
    interp = c(
      "Frightened Flamingo",
      "Worrysome Wren",
      "Pointless Panda",
      "Pointless Panda",
      "Tantalising Tarantula",
      "Tantalising Tarantula"
    ),
    round = c(1L, 1L, 1L, 1L, 1L, 1L)
  ) |>
    membership_tbl(
      source_id = "VEGCODE",
      target_id = "efg",
      membership = "memb",
      interpreter = "interp"
    )
}

test_memb <- function() {
  membership_tbl(
    data.frame(
      source = c("S1", "S1", "S2", "S1", "S2"),
      target = c("X", "Y", "X", "X", "X"),
      membership = c(0.5, 0.5, 1, 1, 1),
      interpreter = c("A", "A", "A", "B", "B"),
      roundnr = c(1, 1, 1, 1, 1)
    ),
    source_id = "source",
    target_id = "target",
    interpreter = "interpreter",
    round = "roundnr"
  )
}
