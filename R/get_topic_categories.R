#' Get topic categories for meetup groups
#'
#' @param lat Character. Latitude (optional)
#' @param lon Character. Longitude (optional)
#' @param fields Character. Character vector or characters separated by comma of optional fields to append to the response
#' @template api_key
#'
#' @return A tibble with the following columns:
#'    * id
#'    * shortname
#'    * name
#'    * sort_name
#'    * category_ids
#'
#' @references
#' \url{https://www.meetup.com/meetup_api/docs/find/topic_categories/}
#'
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

  purrr::map(res, .wrangle_topic) %>%
    dplyr::bind_rows()
}
