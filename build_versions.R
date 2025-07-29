if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}

if (!requireNamespace("tidyr", quietly = TRUE)) {
  install.packages("tidyr")
}

# Set same time zone as in Gitlab CI
# Default rocker images are in UTC
Sys.setenv("TZ" = "Europe/Paris")

first_day_current_month <- format(
  Sys.Date(),
  "%Y-%m-01"
) |> as.Date()

first_day_last_month <- format(
  first_day_current_month - 1,
  "%Y-%m-01"
) |> as.Date()

list_of_r_versions <- jsonlite::fromJSON(
  "https://api.r-hub.io/rversions/r-versions"
) |> tail(5)

list_of_r_versions$date <- as.Date(list_of_r_versions$date)

all_dates <- seq.Date(
  from = list_of_r_versions$date[1],
  Sys.Date(),
  by = "day"
) |>
  data.frame(
    dates = _
  ) |>
  merge(
    list_of_r_versions,
    by.x = "dates",
    by.y = "date",
    all.x = TRUE
  ) |>
  tidyr::fill(version, nickname)

version_for_default_container <- all_dates[
  all_dates$dates == first_day_last_month,
  "version"
]

version_for_next_container <- all_dates[
  all_dates$dates == first_day_current_month,
  "version"
]

# Now we'll get the PPM date. It's a bit trickier cause we
# need to be sure the snapshot exists for the date we want.
get_closest_ppm_available_date <- \(date){
  while (TRUE) {
    if (
      (
        curlGetHeaders(
          sprintf(
            "https://packagemanager.posit.co/cran/%s/src/contrib/PACKAGES",
            date
          )
        ) |> attr("status")
      ) == 200
    ) {
      break
    } else {
      date <- as.Date(date) - 1
    }
  }
  date
}

ppm_date_for_default <- get_closest_ppm_available_date(
  first_day_last_month
)

ppm_date_for_next <- get_closest_ppm_available_date(
  first_day_current_month
)

writeLines(
  c(
    version_for_default_container,
    version_for_next_container
  ) |> as.character(),
  "versions"
)
writeLines(
  c(
    ppm_date_for_default,
    ppm_date_for_next
  ) |> as.character(),
  "ppm_dates"
)
writeLines(
  c(
    first_day_last_month,
    first_day_current_month
  ) |> as.character(),
  "dates"
)
