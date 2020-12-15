test_that("find_events() works", {
  events <- find_events()

  expect_s3_class(events, "tbl_df")

  expect_gte(nrow(events), 20)

  expect_error(find_events(lat = 1))
})
