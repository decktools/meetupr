test_that("get_locations() works", {
  pland <- get_locations("portland maine")

  expect_equal(pland$lat, "43.660000")
})
