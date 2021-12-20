options(
  repos = c(
    REPO_NAME = "https://packagemanager.rstudio.com/cran/__linux__/bionic/2021-12-14"
  ),
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
      "abind",
      "abn",
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
      "gbm",
      "ggplot2",
      "ggraph",
      "ggthemes",
      "golem",
      "gplots",
      "graphics",
      "grDevices",
      "grid",
      "gtable",
      "h2o",
      "haven",
      "hflights",
      "highr",
      "Hmisc",
      "htmltools",
      "httr",
      "icarus",
      "jpeg",
      "knitr",
      "labeling",
      "lattice",
      "latticeExtra",
      "leaps",
      "markdown",
      "MASS",
      "methods",
      "microbenchmark",
      "mime", "munsell",
      "nnet",
      "nycflights13",
      "openxlsx",
      "packrat",
      "pander",
      "pkgbuild",
      "pkgconfig",
      "pkgload",
      "plotly",
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
      "rmarkdown",
      "rmdformats",
      "roxygen2",
      "rpart",
      "rusk",
      "flextable",
      "rvest",
      "sandwich",
      "sas7bdat",
      "scales",
      "scatterplot3d",
      "shinyBS",
      "shinydashboard",
      "shinyWidgets",
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
      "vroom",
      "webshot",
      "writexl",
      "xaringan",
      "XLConnect",
      "XLConnectJars",
      "xtable",
      "xts",
      "zoo",
      "learnr",
      "pagedown",
      "tinytex",
      "ThinkR-open/prenoms",
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
      "thinkr-open/golem@master"
    )
  )
)

failed <- c()
success <- c()

cli::cat_rule("Starting packages installation")

library(progress)
pb <- progress_bar$new(total = length(to_install))

packs <- as.data.frame(installed.packages())

for (i in seq_along(to_install)) {
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
    failed <- c(failed, pak)
  } else {
    cli::cat_bullet(
      sprintf(
        "%s installed", pak
      ),
      bullet = "tick"
    )
    success <- c(success, pak)
  }
}

cli::cat_rule("Installation ended.")

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
tinytex::install_tinytex()
cli::cat_bullet("tinytex installed", bullet = "tick")