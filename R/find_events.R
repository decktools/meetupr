
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
find_events <- function(lat = NULL, lon = NULL, radius = NULL, start_date_range = NULL, end_date_range = NULL, query = NULL, topic_category = NULL, fields = NULL, excluded_groups = NULL, order = NULL, api_key = NULL) {
  api_method <- "find/upcoming_events"

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, query = query, lat = lat, lon = lon, radius = radius, start_date_range = start_date_range, end_date_range = end_date_range, fields = fields, excluded_groups = excluded_groups, order = order)

  tibble::tibble(
    name = purrr::map_chr(res, "name_string"),
    lat = purrr::map_chr(res, "lat"),
    lon = purrr::map_chr(res, "lon"),
    city = purrr::map_chr(res, "city"),
    country = purrr::map_chr(res, "country"),
    country_standardized = purrr::map_chr(res, "localized_country_name"),
    state = purrr::map_chr(res, "state"),
    zip = purrr::map_chr(res, "state"),
    resource = res
  )
}

