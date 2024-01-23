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
  "abind",
  "arsenal",
  "attachment",
  "attempt",
  "bbmle",
  "bit64",
  "bookdown",
  "broom",
  "car",
  "cartography",
  "ceramic",
  "checkhelper",
  "chron",
  "class",
  "cluster",
  "colorspace",
  "colourpicker",
  "compiler",
  "covr",
  "cowplot",
  "cowsay",
  "ThinkR-open/cranology",
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
  "hadley/emo",
  "emojifont",
  "evaluate",
  "explor",
  "extrafont",
  "FactoMineR",
  "fcuk",
  "flextable",
  "flux",
  "forecast",
  "foreign",
  "formatR",
  "Formula",
  "fortunes",
  "furrr",
  "fusen",
  "future.callr",
  "gapminder",
  "gbm",
  "geofacet",
  "geoR",
  "geosapi",
  "gert",
  "gganimate",
  "ggimage",
  "ggmap",
  "ggplot2",
  "ggpubr",
  "ggraph",
  "ggrepel",
  "ggspatial",
  "ggtext",
  "ggthemes",
  "git2r",
  "gitlabr",
  "golem",
  "gplots",
  "graphics",
  "grDevices",
  "grid",
  "gstat",
  "gt",
  "gtable",
  "gtExtras",
  "h2o",
  "hadley/emo",
  "haven",
  "here",
  "hflights",
  "highr",
  "Hmisc",
  "htmltools",
  "httr",
  "icarus",
  "ThinkR-open/inca3",
  "interp",
  "jpeg",
  "kableExtra",
  "keyring",
  "knitr",
  "labeling",
  "lattice",
  "latticeExtra",
  "leaflet",
  "leaps",
  "learnr",
  "lwgeom",
  "magick",
  "mapdata",
  "mapdeck",
  "mapedit",
  "maps",
  "mapview",
  "markdown",
  "MASS",
  "methods",
  "microbenchmark",
  "mime",
  "mongolite",
  "munsell",
  "ncdf4",
  "nnet",
  "nycflights13",
  "openxlsx",
  "packrat",
  "pacman",
  "pagedown",
  "pander",
  "password",
  "patchwork",
  "pkgbuild",
  "pkgconfig",
  "pkgdown",
  "pkgload",
  "plotly",
  "prettydoc",
  "proto",
  "proustr",
  "pryr",
  "quarto",
  "R6",
  "randomForest",
  "raster",
  "rasterVis",
  "rayshader",
  "RColorBrewer",
  "Rcpp",
  "readr",
  "readxl",
  "remedy",
  "remotes",
  "reprex",
  "reshape",
  "reshape2",
  "rgl",
  "rJava",
  "RJSONIO",
  "rmapshaper",
  "rmarkdown",
  "rmdformats",
  "rnaturalearth",
  "rnaturalearthdata",
  "ropensci/rnaturalearthhires",
  "rosm",
  "roxygen2",
  "rpart",
  "rstudio/renv",
  "rvest",
  "sandwich",
  "sas7bdat",
  "scales",
  "scatterplot3d",
  "SensoMineR",
  "sf",
  "shinipsum",
  "shinyBS",
  "shinydashboard",
  "shinyjs",
  "shinyWidgets",
  "showtext",
  "skimr",
  "sp",
  "spelling",
  "splines",
  "sqldf",
  "stars",
  "statnmap/cartomisc",
  "stats",
  "stringr",
  "styler",
  "survival",
  "targets",
  "tcltk",
  "tcltk2",
  "terra",
  "thematic",
  "thinkr",
  "ThinkR-open/inca3",
  "ThinkR-open/prenoms",
  "ThinkR-open/shopping",
  "tidystringdist",
  "tidytext",
  "tidyverse",
  "tinytex",
  "tmap",
  "togglr",
  "tools",
  "topicmodels",
  "transformr",
  "tseries",
  "units",
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
  "zoo"
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
    pak::pak(
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
  rtes::install_github(
    "thinkr-open/tutor",
    force = TRUE,
    upgrade = FALSE
  )
})

# Rve the tutorials from learnr so that we only use the ones
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
cli::cat_rule("force keyring installation from source")
install.packages('keyring',repos='http://cran.rstudio.com')


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



