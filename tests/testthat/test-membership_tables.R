input_table <- data.frame(
    re1 = c("Semi-deciduous Forest","Deciduous Forest","Wet Montane Forest","Dry Montane Forest"),
    efg1 = c("T1.1", "T1.2", "T1.1", "T1.2"),
    memb1 = c(80,80,70,50),
    efg2 = c("T1.2", "T1.1", "T1.3", "T1.3"),
    memb2 = c(20,20,30,50)
)
result1 <- membership_table(
    input_table, 
    "re1",
    c("efg1","efg2","efg3"),
    c("memb1","memb2"),
    target="T1.3")

result2 <- membership_table(
    input_table, 
    "re1",
    dplyr::starts_with("efg"),
    dplyr::starts_with("memb"),
    target="T1.3")

test_that("variants of column selection produce same results", {
  expect_equal(result1, result2)
})
