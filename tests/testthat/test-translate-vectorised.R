context("translate-vectorised")

test_that("case_when converted to CASE WHEN", {
  expect_equal(
    translate_sql(case_when(x > 1L ~ "a")),
    sql("CASE\nWHEN (`x` > 1) THEN ('a')\nEND")
  )
})

test_that("even inside mutate", {
  out <- lazy_frame(x = 1:5) %>%
    mutate(y = case_when(x > 1L ~ "a")) %>%
    sql_build()

  expect_equal(
    out$select[[2]],
    "CASE\nWHEN (`x` > 1) THEN ('a')\nEND AS `y`"
  )
})

test_that("case_when translates correctly to ELSE when TRUE ~ is used 2", {
  out <- translate_sql(
    case_when(
      x == 1L ~ "yes",
      x == 0L ~ "no",
      TRUE    ~ "undefined")
  )

  expect_equal(
    out,
    sql("CASE\nWHEN (`x` = 1) THEN ('yes')\nWHEN (`x` = 0) THEN ('no')\nELSE ('undefined')\nEND")
  )
})
