options(
  Ncpus = 6
)

update.packages(ask = FALSE)

install.packages("pak")

if (!requireNamespace("progress", quietly = TRUE)) {
  pak::pkg_install("progress")
}
if (!requireNamespace("cli", quietly = TRUE)) {
  pak::pkg_install("cli")
}
if (!requireNamespace("attempt", quietly = TRUE)) {
  pak::pkg_install("attempt")
}

to_install <- unique(
  sort(
    c(
      "password",
      "abind",
      "ggtext",
      "patchwork",
      "cowplot",
      "showtext",
      "arsenal",
      "attachment",
      "attempt",
      "bbmle",
      "bit64",
      "broom",
      "bookdown",
      "car",
      "chron",
      "class",
      "cluster",
      "colorspace",
      "compiler",
      "cowsay",
      "data.table",
      "DBI",
      "devEMF",
      "devtools",
      "dichromat",
      "digest",
      "doSNOW",
      "dplyr",
      "DT",
      "dygraphs",
      "e1071",
      "ellipse",
      "evaluate",
      "explor",
      "FactoMineR",
      "fcuk",
      "forecast",
      "foreign",
      "formatR",
      "Formula",
      "fortunes",
      "fusen",
      "gapminder",
      "gert",
      "gbm",
      "ggplot2",
      "ggraph",
      "ggthemes",
      "git2r",
      "gitlabr",
      "golem",
      "gplots",
      "graphics",
      "grDevices",
      "grid",
      "gtable",
      "h2o",
      "hadley/emo",
      "haven",
      "hflights",
      "highr",
      "Hmisc",
      "htmltools",
      "httr",
      "icarus",
      "interp",
      "jpeg",
      "keyring",
      "knitr",
      "labeling",
      "lattice",
      "latticeExtra",
      "leaps",
      "markdown",
      "MASS",
      "methods",
      "microbenchmark",
      "mime",
      "mongolite",
      "munsell",
      "nnet",
      "nycflights13",
      "openxlsx",
      "packrat",
      "pacman",
      "pander",
      "pkgbuild",
      "pkgconfig",
      "pkgdown",
      "pkgload",
      "plotly",
      "prettydoc",
      "proto",
      "proustr",
      "pryr",
      "R6",
      "randomForest",
      "raster",
      "RColorBrewer",
      "Rcpp",
      "readr",
      "readxl",
      "remedy",
      "rstudio/renv",
      "reprex",
      "reshape",
      "reshape2",
      "rJava",
      "RJSONIO",
      "rmarkdown",
      "rmdformats",
      "roxygen2",
      "rpart",
      "flextable",
      "rvest",
      "sandwich",
      "sas7bdat",
      "scales",
      "scatterplot3d",
      "shinyBS",
      "shinydashboard",
      "shinyWidgets",
      "shinipsum",
      "skimr",
      "spelling",
      "splines",
      "sqldf",
      "stats",
      "stringr",
      "styler",
      "survival",
      "tcltk",
      "tcltk2",
      "thinkr",
      "tidystringdist",
      "tidytext",
      "tidyverse",
      "togglr",
      "tools",
      "topicmodels",
      "tseries",
      "usethis",
      "utils",
      "V8",
      "visdat",
      "vroom",
      "webshot",
      "writexl",
      "xaringan",
      "xaringanExtra",
      "xtable",
      "xts",
      "zoo",
      "learnr",
      "pagedown",
      "tinytex",
      "ThinkR-open/prenoms",
      "ThinkR-open/inca3",
      "ThinkR-open/shopping",
      "sf",
      "leaflet",
      "raster",
      "terra",
      "rosm",
      "gstat",
      "maps",
      "mapdata",
      "ncdf4",
      "sp",
      "geoR",
      "ggmap",
      "here",
      "Rcpp",
      "units",
      "lwgeom",
      "stars",
      "ggspatial",
      "extrafont",
      "ggrepel",
      "tmap",
      "rnaturalearth",
      "rnaturalearthdata",
      "gganimate",
      "terra",
      "ceramic",
      "mapview",
      "mapedit",
      "rgl",
      "rgeos",
      "magick",
      "colourpicker",
      "cartography",
      "shinyjs",
      "transformr",
      "geofacet",
      "mapdeck",
      "ropensci/rnaturalearthhires",
      "statnmap/cartomisc",
      "remotes",
      "golem",
      "covr",
      "furrr"
    )
  )
)

failed <- c()
success <- c()

cli::cat_rule("Starting packages installation")

library(progress)
pb <- progress_bar$new(
  total = length(to_install)
)

for (i in seq_along(to_install)) {

  packs <- as.data.frame(installed.packages())

  pb$tick()

  cli::cat_line()

  pak <- to_install[i]

  if (pak %in% packs$Package) {
    cli::cat_rule(
      sprintf(
        "%s is already installed, skipping",
        pak
      )
    )
    next()
  }

  cli::cat_bullet(
    sprintf(
      "Starting %s installation",
      pak
    ),
    bullet = "play"
  )

  tst <- attempt::attempt({
    pak::pkg_install(
      pak,
      upgrade = FALSE
    )
  })

  if (attempt::is_try_error(tst)) {
    cli::cat_bullet(
      sprintf(
        "Error installing %s",
        pak
      ),
      bullet = "cross"
    )
    failed <- c(
      failed,
      pak
    )
  } else {
    cli::cat_bullet(
      sprintf(
        "%s installed",
        pak
      ),
      bullet = "tick"
    )
    success <- c(success, pak)
  }
}

cli::cat_rule("Installation ended.")


# LATEST thinkr-open/tutor
# Just to be sure we have the correct version of {learnr}
remove.packages("learnr")

tst <- attempt::attempt({
  remotes::install_github(
    "thinkr-open/tutor",
    force = TRUE,
    upgrade = FALSE
  )
})

# Remove the tutorials from learnr so that we only use the ones
# from {tutor}
unlink(
  system.file(
    "tutorials",
    package = "learnr"
  ),
  TRUE,
  TRUE
)

if (attempt::is_try_error(tst)) {
  cli::cat_bullet(
    sprintf(
      "Error installing %s",
      "tutor"
    ),
    bullet = "cross"
  )
  failed <- c(
    failed,
    pak
  )
} else {
  cli::cat_bullet(
    sprintf(
      "%s installed",
      "tutor"
    ),
    bullet = "tick"
  )
  success <- c(
    success,
    pak
  )
}

cli::cat_line()
cli::cat_line()
cli::cat_rule("The following package(s) have been installed:")
cli::cat_bullet(success, bullet = "tick")
cli::cat_line()
cli::cat_rule("The following package(s) failed to install:")
cli::cat_bullet(failed, bullet = "cross")

cli::cat_line()
cli::cat_rule("Installing webshot")
webshot::install_phantomjs()
system("cp ~/bin/phantomjs /usr/local/share/phantomjs")
system("chmod 0755 /usr/local/share/phantomjs")
system("ln -sf /usr/local/share/phantomjs /usr/local/bin")
cli::cat_bullet("PhantomJS installed", bullet = "tick")

cli::cat_line()
cli::cat_rule("Installing tinytex")
tinytex::install_tinytex(force = TRUE)
cli::cat_bullet("tinytex installed", bullet = "tick")
