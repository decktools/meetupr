
#' Get locations for meetup groups
#'
#' Provide either a search query or a latitude + longitude combination to find a location
#'
#' @param query
#' @param topic_category
#' @param lat Latitude (optional)
#' @param lon Longitude (optional)
#' @param radius
#' @param start_date_range
#' @param start_time_range
#' @param end_date_range
#' @param end_time_range
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
#'
#' topics <- get_topics()
#' mvmt_ids <- topics %>% dplyr::filter(name == "Movements") %>% dplyr::pull(category_ids)
#' find_events(ll$lat, ll$lon, radius = 10, topic_category = mvmt_ids)
#' }
find_events <- function(query = NULL, topic_category = NULL, lat = NULL, lon = NULL, radius = NULL, start_date_range = NULL, end_date_range = NULL, fields = NULL, excluded_groups = NULL, order = NULL, api_key = NULL) {
  api_method <- "find/upcoming_events"

  # If fields is a vector, change it to single string of comma separated values
  if (length(fields) > 1) {
    fields <- paste(fields, collapse = ",")
  }
  # If topic_category is a vector, change it to single string of comma separated values
  if (length(topic_category) > 1) {
    topic_category <- paste(topic_category, collapse = ",")
  }

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, text = query, topic_category = topic_category, lat = lat, lon = lon, radius = radius, start_date_range = start_date_range, end_date_range = end_date_range, fields = fields, excluded_groups = excluded_groups, order = order)

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
