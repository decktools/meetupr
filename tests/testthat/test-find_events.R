test_that("find_events() works", {
  withr::local_options(list(meetupr.use_oauth = FALSE))
  set_api_key("a good key")

  events <- find_events(api_key = "a good key")

  expect_s3_class(events, "tbl_df")

  expect_gte(nrow(events), 20)

  expect_error(find_events(lat = 1))
})
