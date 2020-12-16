
<!-- README.md is generated from README.Rmd. Please edit the Rmd file -->

# meetupr

[![Build
Status](https://travis-ci.org/rladies/meetupr.svg?branch=master)](https://travis-ci.org/rladies/meetupr)

R interface to the Meetup API (v3)

**Authors:** [Lucy D’Agostino McGowan](http://www.lucymcgowan.com),
[Gabriela de Queiroz](http://gdequeiroz.github.io/), [Erin
LeDell](http://www.stat.berkeley.edu/~ledell/), [Olga
Mierzwa-Sulima](https://github.com/olgamie), [Claudia
Vitolo](https://github.com/cvitolo)<br/>
[MIT](https://opensource.org/licenses/MIT) **License:**
[MIT](https://opensource.org/licenses/MIT)

## Installation

To install the development version from GitHub:

    # install.packages("remotes")
    remotes::install_github("rladies/meetupr")

A released version will be on CRAN
[soon](https://github.com/rladies/meetupr/issues/24).

## Usage

### Authentication

In order to use this package, you can use our built-in
[OAuth](https://www.meetup.com/meetup_api/auth/) credentials
(recommended), or if you prefer, you can supply your own by setting the
`meetupr.consumer_key` and `meetupr.consumer_secret` variables.

Each time you use the package, you will be prompted to log in to your
meetup.com account. The first time you run any of the **meetupr**
functions in your session, R will open a browser window, prompting you
to “Log In and Grant Access” (to the **meetupr** “application”).

*Note: As of August 15, 2019, Meetup.com switched from an API key based
authentication system to OAuth 2.0, so we [added
support](https://github.com/rladies/meetupr/issues/51) for OAuth. For
backwards compatibility, the functions all still have an `api_key`
argument which is no longer used and will eventually be
[deprecated](https://github.com/rladies/meetupr/issues/59).*

### Functions

We currently have the following functions:

-   `get_members()`
-   `get_boards()`
-   `get_events()`  
-   `get_event_attendees()`  
-   `get_event_comments()`
-   `get_event_rsvps()`
-   `get_locations()`
-   `get_topic_categories()`
-   `find_events()`
-   `find_groups()`
-   `find_topics()`

Each will output a tibble with information extracted into from the API
as well as a `list-col` named `*_resource` with all API output. For
example, the following code will get all upcoming events for the
[R-Ladies San Francisco](https://meetup.com/rladies-san-francisco)
meetup.

    library(meetupr)

    urlname <- "rladies-san-francisco"
    events <- get_events(urlname, "past")
    #> Meetup is moving to OAuth *only* as of 2019-08-15. Set
    #> `meetupr.use_oauth = FALSE` in your .Rprofile, to use
    #> the legacy `api_key` authorization.
    #> Downloading 60 record(s)...
    dplyr::arrange(events, desc(created))
    #> # A tibble: 60 x 21
    #>    id    name  created             status time                local_date
    #>    <chr> <chr> <dttm>              <chr>  <dttm>              <date>    
    #>  1 2730… A co… 2020-09-04 14:04:50 past   2020-09-10 18:30:00 2020-09-10
    #>  2 2724… Tang… 2020-08-06 15:24:51 past   2020-08-27 20:30:00 2020-08-27
    #>  3 2679… R-La… 2020-01-16 13:08:03 past   2020-01-30 20:00:00 2020-01-30
    #>  4 2663… Dece… 2019-11-11 17:10:10 past   2019-12-10 21:00:00 2019-12-10
    #>  5 2651… Work… 2019-09-23 15:28:24 past   2019-10-16 21:00:00 2019-10-16
    #>  6 2632… Augu… 2019-07-17 13:29:10 past   2019-08-07 21:00:00 2019-08-07
    #>  7 2627… R-La… 2019-06-28 18:24:12 past   2019-07-21 14:00:00 2019-07-21
    #>  8 2626… Baye… 2019-06-26 23:11:16 past   2019-07-17 21:00:00 2019-07-17
    #>  9 2610… Mini… 2019-04-30 20:49:52 past   2019-05-18 16:30:00 2019-05-18
    #> 10 2590… NLP … 2019-02-15 17:36:58 past   2019-03-12 21:00:00 2019-03-12
    #> # … with 50 more rows, and 15 more variables: local_time <chr>,
    #> #   waitlist_count <int>, yes_rsvp_count <int>, venue_id <int>,
    #> #   venue_name <chr>, venue_lat <dbl>, venue_lon <dbl>, venue_address_1 <chr>,
    #> #   venue_city <chr>, venue_state <chr>, venue_zip <chr>, venue_country <chr>,
    #> #   description <chr>, link <chr>, resource <list>

Next we can look up all R-Ladies groups by “topic id”. You can find
topic ids for associated tags by querying
[here](https://secure.meetup.com/meetup_api/console/?path=/find/topics).
The `topic_id` for topic, “R-Ladies”, is `1513883`.

    groups <- find_groups(topic_id = 1513883)
    #> Downloading 137 record(s)...
    dplyr::arrange(groups, desc(created))
    #> # A tibble: 137 x 21
    #>        id name  urlname created             members status organizer   lat
    #>     <int> <chr> <chr>   <dttm>                <int> <chr>  <chr>     <dbl>
    #>  1 3.38e7 R-La… rladie… 2020-06-13 01:50:37     409 active R-Ladies… -1.29
    #>  2 3.34e7 R-La… rladie… 2020-02-22 12:51:34     105 active R-Ladies… 52.4 
    #>  3 3.34e7 R-La… rladie… 2020-02-22 12:39:39      10 active R-Ladies… 43.3 
    #>  4 3.32e7 R-La… rladie… 2020-01-12 12:47:12     297 active R-Ladies… 25.7 
    #>  5 3.32e7 R-La… rladie… 2020-01-12 12:39:04      27 active R-Ladies… 51.8 
    #>  6 3.31e7 R-La… rladie… 2019-12-15 14:50:22      77 active R-Ladies… 38.9 
    #>  7 3.31e7 R-La… rladie… 2019-12-15 08:30:12      43 active R-Ladies…  6.93
    #>  8 3.31e7 R-La… rladie… 2019-11-30 11:55:10      37 active R-Ladies… 30.0 
    #>  9 3.31e7 R-La… rladie… 2019-11-30 11:09:20       7 active R-Ladies… 43.0 
    #> 10 3.30e7 R-La… rladie… 2019-11-23 14:14:43      77 active R-Ladies… 19.0 
    #> # … with 127 more rows, and 13 more variables: lon <dbl>, city <chr>,
    #> #   state <chr>, country <chr>, timezone <chr>, join_mode <chr>,
    #> #   visibility <chr>, who <chr>, organizer_id <int>, organizer_name <chr>,
    #> #   category_id <int>, category_name <chr>, resource <list>

## How can you contribute?

We are looking for new people to join the list of contributors! Please
take a look at the open
[issues](https://github.com/rladies/meetupr/issues), file a new issue,
contribute tests, or improve the documentation. We are also looking to
expand the set of functions to include more endpoints from the [Meetup
API](https://www.meetup.com/meetup_api/). Lastly, we’d also love to
[hear about](https://github.com/rladies/meetupr/issues/74) any
applications of the **meetupr** package, so we can compile a list of
demos!

Please note that the this project is released with a [Contributor Code
of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you
agree to abide by its terms.
