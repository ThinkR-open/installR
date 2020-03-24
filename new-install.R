packs <- as.data.frame(installed.packages())
if (! "remotes" %in% packs$Package ){
  install.packages("remotes")
}
remotes::install_cran("withr")
remotes::install_cran("progress")
remotes::install_cran("cli")
remotes::install_version("attempt", "0.3.0")

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
      "splines", 
      "sqldf",
      "stats", 
      "stringr", 
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
      "writexl",
      "xaringan", 
      "XLConnect",
      "XLConnectJars", 
      "xtable", 
      "xts", 
      "zoo", 
      "learnr"
    )
  )
)

failed <- c()
success <- c()

withr::with_options(
  c(repos =  "https://cran.rstudio.com"), {
    cli::cat_rule("Starting packages installation")
    
    library(progress)
    pb <- progress_bar$new(total = length(to_install))
    
    for (i in seq_along(to_install)){
      pb$tick()
      cli::cat_line()
      pak <- to_install[i]
      cli::cat_bullet(
        sprintf(
          "Starting %s installation", 
          pak
        ), bullet = "play"
      )
      
      tst <- attempt::attempt({
        remotes::install_cran(
          pak, 
          quiet = TRUE
        )
      })
      if (attempt::is_try_error(tst)){
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
    
  }
)

cli::cat_rule("Ended CRAN Installation. Starting GitHub Installation.")

to_install <- c(
  "ThinkR-open/prenoms", 
  "ThinkR-open/shopping"
)

withr::with_options(
  c(repos =  "https://cran.rstudio.com"), {
    cli:cat_rule("Starting packages installation")
    
    library(progress)
    pb <- progress_bar$new(total = length(to_install))
    
    for (i in seq_along(to_install)){
      cli::cat_line()
      pb$tick()
      pak <- to_install[i]
      cli::cat_bullet(
        sprintf(
          "Starting %s installation", 
          i
        ), bullet = "play"
      )
      
      tst <- attempt::attempt({
        remotes::install_github(
          pak,
          upgrade = "always", 
          quiet = TRUE
        )
      })
      if (attempt::is_try_error(tst)){
        cli::cat_bullet(
          sprintf(
            "Error installing %s", pak
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
    
  }
)

cli::cat_line()
cli::cat_line()
cli::cat_rule("The following package(s) have been installed:")
cli::cat_bullet(success, bullet="tick")
cli::cat_rule("The following package(s) failed to install:")
cli::cat_bullet(failed, bullet="cross")