test_that("get_topic_categories() works", {
  withr::local_options(list(meetupr.use_oauth = FALSE))
  set_api_key("a good key")
  tc <- get_topic_categories(api_key = "a good key")

  expect_gte(ncol(tc), 5)
  expect_gte(nrow(tc), 20)

  tc_ll <- get_topic_categories(lat = "39.5501", lon = "105.7821")

  expect_type(tc_ll$id, "integer")
})
