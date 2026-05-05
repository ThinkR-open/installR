options(
  Ncpus = 6
)

# Skip sysreqs: the Dockerfile (bk-config.sh) already installs the
# system libraries we need. This avoids ~50 redundant `apt-get install`
# checks across the install run.
Sys.setenv(PKG_SYSREQS = "false")

# Forward CI tokens to GITHUB_PAT so pak/remotes use authenticated
# requests (60 → 5000 req/hr). Without this, the GH installs hit the
# unauthenticated rate limit after a couple of packages. Supports
# GitHub Actions (GITHUB_TOKEN) and GitLab CI (GITLAB_GITHUB_TOKEN /
# CI_GITHUB_TOKEN — pick whichever your CI sets).
if (Sys.getenv("GITHUB_PAT") == "") {
  for (var in c("GITHUB_TOKEN", "GITLAB_GITHUB_TOKEN", "CI_GITHUB_TOKEN")) {
    tok <- Sys.getenv(var)
    if (nzchar(tok)) {
      Sys.setenv(GITHUB_PAT = tok)
      break
    }
  }
}

# Install a recent pak from r-lib's distribution server. The CRAN
# snapshot pinned in this image (2022-03-09) only ships pak 0.2.1,
# which doesn't pick up Posit Package Manager binaries on Linux and
# ends up compiling everything from source. A modern pak transparently
# fetches pre-compiled binaries from PPM, cutting many minutes off
# the build.
install.packages(
  "pak",
  repos = sprintf(
    "https://r-lib.github.io/p/pak/stable/%s/%s/%s",
    .Platform$pkgType,
    R.Version()$os,
    R.Version()$arch
  )
)

# Bootstrap helper packages used by this script
for (p in c("progress", "cli", "attempt")) {
  if (!requireNamespace(p, quietly = TRUE)) {
    pak::pkg_install(p, ask = FALSE)
  }
}

# CRAN packages: one pak call, parallel resolution + download
cran_pkgs <- c(
  "abind",
  "arsenal",
  "attachment",
  "attempt",
  "bbmle",
  "bit64",
  "bslib",
  "bookdown",
  "broom",
  "bsicons",
  "car",
  "cartography",
  "ceramic",
  "chron",
  "class",
  "cluster",
  "colorspace",
  "colourpicker",
  "covr",
  "cowplot",
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
  "emojifont",
  "evaluate",
  "explor",
  "extrafont",
  "FactoMineR",
  "fcuk",
  "flextable",
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
  "gstat",
  "gt",
  "gtable",
  "gtExtras",
  "h2o",
  "haven",
  "here",
  "hflights",
  "highr",
  "Hmisc",
  "htmltools",
  "httr",
  "icarus",
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
  "mapsf",
  "mapview",
  "markdown",
  "MASS",
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
  "pkgnet",
  "plotly",
  "prettydoc",
  "proto",
  "proustr",
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
  "renv",
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
  "rosm",
  "roxygen2",
  "rpart",
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
  "sqldf",
  "stars",
  "styler",
  "survival",
  "targets",
  "tcltk2",
  "terra",
  "thematic",
  "thinkr",
  "tidystringdist",
  "tidytext",
  "tidyverse",
  "tinytex",
  "tmap",
  "togglr",
  "topicmodels",
  "transformr",
  "tseries",
  "units",
  "usethis",
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

# GitHub-only packages (those not on CRAN, or where we want a specific fork).
# inca3 and checkhelper used to be installed from R-Universe; merged here so
# everything off-CRAN goes through the same remotes::install_github path —
# avoids pak subprocess CA-bundle issues and keeps one resilient code path.
gh_pkgs <- c(
  "ThinkR-open/cranology",
  "hadley/emo",
  "ropensci/rnaturalearthhires",
  "statnmap/cartomisc",
  "ThinkR-open/prenoms",
  "ThinkR-open/shopping",
  "ThinkR-open/inca3",
  "ThinkR-open/checkhelper"
)

pkg_name <- function(x) {
  if (grepl("/", x)) sub("^.*/", "", x) else x
}

cli::cat_rule("Bulk CRAN install (single pak call)")

cran_ok <- attempt::attempt({
  pak::pkg_install(
    cran_pkgs,
    upgrade = FALSE,
    ask = FALSE
  )
})

if (attempt::is_try_error(cran_ok)) {
  cli::cat_bullet(
    "Bulk CRAN install errored — aborting",
    bullet = "cross"
  )
  stop("Bulk CRAN install failed; not all packages were installed.")
}

# pak::pkg_install can return success even when individual packages were
# skipped due to "dependency conflict" (typically base-recommended pkgs
# pinned by the running R session: MASS, lattice, cluster, ...). Check
# the actual installed set and abort if anything is missing — otherwise
# the build silently ships an incomplete image.
post_install <- as.data.frame(installed.packages())$Package
cran_missing <- setdiff(cran_pkgs, post_install)
if (length(cran_missing) > 0) {
  cli::cat_bullet(
    sprintf(
      "Bulk CRAN install left %d package(s) uninstalled: %s",
      length(cran_missing),
      paste(cran_missing, collapse = ", ")
    ),
    bullet = "cross"
  )
  stop("Bulk CRAN install incomplete; aborting.")
}

cli::cat_bullet(
  "Bulk CRAN install completed",
  bullet = "tick"
)

cli::cat_rule("GitHub packages (one by one for resilience)")

# Use remotes::install_github rather than pak: pak runs in a subprocess that
# does not always inherit GITHUB_PAT set via Sys.setenv() in the parent, which
# triggers "Cannot query GitHub, are you offline?" failures even when the
# token is present. remotes reads the env var directly in-process.
gh_failed <- c()

library(progress)
pb <- progress_bar$new(total = length(gh_pkgs))

for (pkg in gh_pkgs) {
  pb$tick()
  cli::cat_line()

  installed <- as.data.frame(installed.packages())$Package
  if (pkg_name(pkg) %in% installed) {
    cli::cat_rule(
      sprintf(
        "%s is already installed, skipping",
        pkg
      )
    )
    next()
  }

  cli::cat_bullet(
    sprintf(
      "Installing %s",
      pkg
    ),
    bullet = "play"
  )

  res <- attempt::attempt({
    remotes::install_github(
      pkg,
      upgrade = "never"
    )
  })

  if (
    attempt::is_try_error(res) ||
      !(pkg_name(pkg) %in% as.data.frame(installed.packages())$Package)
  ) {
    cli::cat_bullet(
      sprintf("Failed: %s", pkg),
      bullet = "cross"
    )
    gh_failed <- c(
      gh_failed,
      pkg
    )
  } else {
    cli::cat_bullet(
      sprintf(
        "OK: %s",
        pkg
      ),
      bullet = "tick"
    )
  }
}


# Reconcile: which packages from the full request list ended up installed?
all_requested <- c(
  cran_pkgs,
  gh_pkgs
)

final_installed <- as.data.frame(
  installed.packages()
)$Package

success <- all_requested[
  vapply(
    all_requested,
    function(x) pkg_name(x) %in% final_installed,
    logical(1)
  )
]
failed <- setdiff(all_requested, success)

cli::cat_rule("Installation phase ended")

# tutor: forced reinstall to guarantee a known learnr version pairing
cli::cat_rule("Installing thinkr-open/tutor")

if ("learnr" %in% as.data.frame(installed.packages())$Package) {
  remove.packages("learnr")
}

tutor_ok <- attempt::attempt({
  remotes::install_github(
    "thinkr-open/tutor",
    force = TRUE,
    upgrade = FALSE
  )
})

# Drop learnr's bundled tutorials so only tutor's are exposed
unlink(
  system.file("tutorials", package = "learnr"),
  recursive = TRUE,
  force = TRUE
)

if (attempt::is_try_error(tutor_ok)) {
  cli::cat_bullet("Failed: tutor", bullet = "cross")
  failed <- c(failed, "tutor")
} else {
  cli::cat_bullet("OK: tutor", bullet = "tick")
  success <- c(success, "tutor")
}

# keyring forced from source (needs libsecret bindings on this image)
cli::cat_rule("Force-installing keyring from source")
install.packages(
  "keyring",
  repos = "http://cran.rstudio.com",
  type = "source"
)

cli::cat_line()
cli::cat_rule("The following package(s) are installed:")
cli::cat_bullet(success, bullet = "tick")
cli::cat_line()
cli::cat_rule("The following package(s) failed to install:")
cli::cat_bullet(failed, bullet = "cross")

cli::cat_rule("Installing PhantomJS (via webshot)")
webshot::install_phantomjs()
system("cp ~/bin/phantomjs /usr/local/share/phantomjs")
system("chmod 0755 /usr/local/share/phantomjs")
system("ln -sf /usr/local/share/phantomjs /usr/local/bin")
cli::cat_bullet("PhantomJS installed", bullet = "tick")

cli::cat_rule("Installing tinytex")

tinytex_installed <- FALSE

# tinytex's default repo (tlnet.yihui.org) intermittently serves HTML
# instead of the tlpdb file, which corrupts the install. `repository`
# is honored by install_tinytex() itself; the option only affects
# post-install tlmgr calls — both must be set to fully bypass yihui.
tlmgr_repo <- "https://mirror.ctan.org/systems/texlive/tlnet"
options(
  tinytex.tlmgr.repo = tlmgr_repo
)

# 1) daily (default — fastest when it works, but can 404)
res <- attempt::attempt({
  tinytex::install_tinytex(
    force = TRUE,
    repository = tlmgr_repo
  )
})
if (!attempt::is_try_error(res)) {
  tinytex_installed <- TRUE
} else {
  cli::cat_bullet(
    "tinytex daily install failed, trying latest",
    bullet = "cross"
  )
}

# 2) latest
if (!tinytex_installed) {
  res <- attempt::attempt({
    tinytex::install_tinytex(
      force = TRUE,
      version = "latest",
      repository = tlmgr_repo
    )
  })
  if (!attempt::is_try_error(res)) {
    tinytex_installed <- TRUE
  } else {
    cli::cat_bullet(
      "tinytex latest install failed, trying pinned version",
      bullet = "cross"
    )
  }
}

# 3) pinned fallback
if (!tinytex_installed) {
  res <- attempt::attempt({
    tinytex::install_tinytex(
      force = TRUE,
      version = "v2026.05",
      repository = tlmgr_repo
    )
  })
  if (!attempt::is_try_error(res)) {
    tinytex_installed <- TRUE
  }
}

if (tinytex_installed) {
  cli::cat_bullet("tinytex installed", bullet = "tick")
} else {
  cli::cat_bullet(
    "tinytex install failed (all fallbacks exhausted)",
    bullet = "cross"
  )
  stop("tinytex install failed (all fallbacks exhausted)")
}
