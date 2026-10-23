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
