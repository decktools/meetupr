#' Get topic categories for meetup groups
#'
#' @param lat Latitude (optional)
#' @param lon Longitude (optional)
#' @param fields Character, character vector or characters separated by comma of optional fields to append to the response
#' @template api_key
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' get_topic_categories()
#' }
get_topic_categories <- function(lat = NULL, lon = NULL, fields = NULL, api_key = NULL) {
  api_method <- "find/topic_categories"

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, lat = lat, lon = lon, fields = fields)

  purrr::map(res, wrangle_topic) %>%
    bind_rows()
}

wrangle_topic <- function(x) {
  photo_idx <- which(names(x) == "photo")

  x[-photo_idx] %>%
    tibble::as_tibble() %>%
    tidyr::unnest(category_ids)
}
