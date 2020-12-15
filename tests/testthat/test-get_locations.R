test_that("get_locations() works", {
  withr::local_options(list(meetupr.use_oauth = FALSE))
  set_api_key("a good key")

  pland <- get_locations("portland maine", api_key = "a good key")

  expect_equal(pland$lat, "43.660000")
})
