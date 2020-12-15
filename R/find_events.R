#' Find events by meetup groups
#'
#' Provide a search query, a latitude + longitude combination, and/or \code{topic_category} values to find events
#'
#' @param query Character. Raw full text search query.
#' @param topic_category Character vector
#' @param lat Approximate target latitude
#' @param lon Approximate target longitude
#' @param radius Radius (in miles) to search from the center of \code{lat, lon}
#' @param start_date_range Character. Start date range for events to return (format: YYYY-MM-DDTHH:MM:SS)
#' @param end_date_range Character. End date range for events to return (format: YYYY-MM-DDTHH:MM:SS)
#' @param fields Extra optional fields to populate in the response
#' @param order One of "best" or "time". The sort order of returned events. "best" orders events by recommendation score, while "time" orders events by the by the event's start time in increasing order. Defaults to "best."
#' @param excluded_groups IDs for groups to exclude from the returned events
#' @template api_key
#'
#' @return A tibble with columns prefixed with \code{event_}, \code{venue_}, and \code{group}
#' @export
#'
#' @examples
#' \dontrun{
#' ll <- get_locations("New York City")
#' find_events(ll$lat, ll$lon, radius = 10, query = "ultimate frisbee")
#'
#' topics <- get_topics()
#' mvmt_ids <- topics %>%
#'   dplyr::filter(name == "Movements") %>%
#'   dplyr::pull(category_ids)
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

  purrr::map(res$events, .wrangle_event) %>%
    dplyr::bind_rows()
}
