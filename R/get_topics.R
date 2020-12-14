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
#' get_topics()
#' }
get_topics <- function(lat = NULL, lon = NULL, fields = NULL, api_key = NULL) {
  api_method <- "find/topic_categories"

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, lat = lat, lon = lon, fields = fields)

  purrr::map(res, wrangle_topic) %>%
    bind_rows()
}

wrangle_topic <- function(x) {
  best_topics_idx <- which(names(x) == "best_topics")
  category_ids_idx <- which(names(x) == "group")

  extra <-
    x[-c(best_topics_idx, category_ids_idx)] %>%
    tibble::as_tibble()

  topic <-
    x$best_topics %>%
    tibble::as_tibble() %>%
    dplyr::rename_all(
      ~ paste0("topic_", .)
    )

  category <-
    x$category_ids %>%
    tibble::as_tibble() %>%
    dplyr::rename_all(
      ~ paste0("category_", .)
    )

  extra %>%
    dplyr::bind_cols(topic) %>%
    dplyr::bind_cols(category)
}
