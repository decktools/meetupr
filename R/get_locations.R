#' Get locations for meetup groups
#'
#' Provide either a search query or a latitude + longitude combination to find a location
#'
#' @param query Search query: a city/town name or zip code
#' @param lat Latitude (optional)
#' @param lon Longitude (optional)
#' @template api_key
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' get_locations("New York City")
#' get_locations("12345")
#' }
get_locations <- function(query = NULL, lat = NULL, lon = NULL, api_key = NULL) {
  api_method <- "find/locations"

  if (length(c(lat, lon)) == 1) {
    stop("Eiher both or neither `lat` & `lon` must be set.")
  }

  res <- .fetch_results(api_method, api_key, query = query, lat = lat, lon = lon)

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
