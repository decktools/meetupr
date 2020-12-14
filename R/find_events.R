
#' Get locations for meetup groups
#'
#' Provide either a search query or a latitude + longitude combination to find a location
#'
#' @param lat Latitude (optional)
#' @param lon Longitude (optional)
#' @param radius
#' @param start_date_range
#' @param start_time_range
#' @param end_date_range
#' @param end_time_range
#' @param query
#' @param topic_category
#' @param fields
#' @param order
#' @param excluded_groups
#' @template api_key
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' ll <- get_locations("New York City")
#' find_events(ll$lat, ll$lon, radius = 10, query = "ultimate frisbee")
#' }
find_events <- function(lat = NULL, lon = NULL, radius = NULL, start_date_range = NULL, end_date_range = NULL, query = NULL, topic_category = NULL, fields = NULL, excluded_groups = NULL, order = NULL, api_key = NULL) {
  api_method <- "find/upcoming_events"

  # If topic_id is a vector, change it to single string of comma separated values
  if (length(topic_id) > 1) {
    topic_id <- paste(topic_id, collapse = ",")
  }
  # If fields is a vector, change it to single string of comma separated values
  if (length(fields) > 1) {
    fields <- paste(fields, collapse = ",")
  }

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, text = query, lat = lat, lon = lon, radius = radius, start_date_range = start_date_range, end_date_range = end_date_range, fields = fields, excluded_groups = excluded_groups, order = order)

  purrr::map(res$events, wrangle_event) %>%
    bind_rows()
}


wrangle_event <- function(x) {
  venue_idx <- which(names(x) == "venue")
  group_idx <- which(names(x) == "group")

  event <-
    x[-c(venue_idx, group_idx)] %>%
    tibble::as_tibble() %>%
    dplyr::rename_all(
      ~ paste0("event_", .)
    )

  venue <-
    x$venue %>%
    tibble::as_tibble() %>%
    dplyr::rename_all(
      ~ paste0("venue_", .)
    )

  group <-
    x$venue %>%
    tibble::as_tibble() %>%
    dplyr::rename_all(
      ~ paste0("group_", .)
    )

  event %>%
    dplyr::bind_cols(venue) %>%
    dplyr::bind_cols(group)
}
