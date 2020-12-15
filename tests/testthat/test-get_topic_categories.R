test_that("get_topic_categories() works", {
  tc <- get_topic_categories()

  expect_gte(ncol(tc), 5)
  expect_gte(nrow(tc), 20)

  tc_ll <- get_topic_categories(lat = "39.5501", lon = "105.7821")

  expect_type(tc_ll$id, "integer")
})
