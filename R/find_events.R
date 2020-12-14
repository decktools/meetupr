
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
#'
#' }
#'
ll <- get_locations("New York City")
find_events(ll$lat, ll$lon, radius = 1, query = "ultimate frisbee")


find_events <- function(lat = NULL, lon = NULL, radius = NULL, start_date_range = NULL, end_date_range = NULL, query = NULL, topic_category = NULL, fields = NULL, excluded_groups = NULL, order = NULL, api_key = NULL) {
  api_method <- "find/upcoming_events"

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, query = query, lat = lat, lon = lon, radius = radius, start_date_range = start_date_range, end_date_range = end_date_range, fields = fields, excluded_groups = excluded_groups, order = order)

  browser()

  purrr::map(res$events, wrangle_event)
}


wrangle_event <- function(x) {
  event <-
    tibble::tibble(
      id = x$id,
      link = x$link,
      event_name = x$name,
      description = x$description,
      status = x$status,
      rsvp_limit = x$rsvp_limit,
      local_date = x$local_date,
      local_time = x$local_time,
      duration = x$duration,
      waitlist_count = x$waitlist_count,
      yes_rsvp_count = x$yes_rsvp_count,
      how_to_find_us = x$how_to_find_us,
      visibility = x$visibility,
      member_pay_fee = x$member_pay_fee,
      created_at = x$created
    )

  venue_idx <- which(names(x) == "venue")
  group_idx <- which(names(x) == "group")

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

