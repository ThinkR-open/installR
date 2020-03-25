percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}
mon_print <- function(synth){
  N<-nrow(synth)
  if( is.null(N)){
    N<-1
  synth <-
   matrix(synth,nrow=1)
  
  }
  
  for ( i in 1:N){
    tp <- synth[i,]
    tp[1]  <-stringr::str_pad(tp[1],15,side="right")
    cat(tp,"\n")
  }
}


##  source("http://guyader.pro/R/install.R")
try(setInternet2(use = TRUE),silent=TRUE)
packs <- installed.packages()
exc <- names(packs[,'Package'])
  local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org/"; options(repos=r)})
  # update.packages(ask=FALSE)
  ainstaller<-unique(sort(c("abind", "abn", "arsenal", "attachment", "attempt", "bbmle", 
                          "bit64", "broom", "car", "chron", "class", "cluster", "colorspace", 
                          "compiler", "data.table", "DBI", "devEMF", "devtools", "dichromat", 
                          "digest", "doSNOW", "dplyr", "DT", "dygraphs", "e1071", "ellipse", 
                          "evaluate", "explor", "FactoMineR", "fcuk", "forecast", 
                          "foreign", "formatR", "Formula", "fortunes", "gapminder", "gbm", 
                          "ggplot2", "ggraph", "ggthemes", "golem", "gplots", "graphics", 
                          "grDevices", "grid", "gtable", "h2o", "haven", "hflights", "highr", 
                          "Hmisc", "htmltools", "httr", "icarus", "jpeg", "knitr", "labeling", 
                          "lattice", "latticeExtra", "leaps", "markdown", "MASS", "methods", 
                          "microbenchmark", "mime", "munsell", "nnet", "nycflights13", 
                          "openxlsx", "packrat", "pkgbuild", "pkgconfig", "pkgload", "plotly", 
                          "proto", "proustr", "pryr", "R6", "randomForest", "raster", "RColorBrewer", 
                          "Rcpp", "readr", "readxl", "remotes", "reprex", "reshape", "reshape2", 
                          "rJava", "rmarkdown", "rmdformats", "roxygen2", "rpart", "rusk", "flextable",
                          "rvest", "sandwich", "sas7bdat", "scales", "scatterplot3d", "shinyBS", 
                          "shinydashboard", "shinyWidgets", "skimr", "splines", "sqldf", 
                          "stats", "stringr", "survival", "tcltk", "tcltk2", "thinkr", 
                          "tidystringdist", "tidytext", "tidyverse", "togglr", "tools", 
                          "topicmodels", "tseries", "usethis", "utils", "vroom", "writexl", 
                          "xaringan", "XLConnect", "XLConnectJars", "xtable", "xts", "zoo","learnr","golem","remedy"
)))

  
 
if( exists(x="from_thinkR")){ainstaller<-from_thinkR
cat("\n\n INSTALLATION COMPLETE THINKR\n\n\n")
rm(from_thinkR)
}

  vrai_liste <- ainstaller
  try(vrai_liste <- unique(unlist(tools::package_dependencies(ainstaller,recursive = TRUE))))
  
  
  for ( elpa in ainstaller){
    exc <-names(installed.packages()[,'Package'])
    cat("progression : ",
        percent(sum(is.element(ainstaller,exc))/length(ainstaller),digits=0)
        ," - ",
        percent(sum(is.element(vrai_liste,exc))/length(vrai_liste),digits=0)
        ,"\n\n")  
    if(is.element(elpa,exc)){
      cat(elpa," est deja present \n")
      
    }
if(!is.element(elpa,exc)){
  cat(elpa," va etre installe \n")
  
  try(utils:::install.packages(elpa,dependencies = TRUE))
packs <- installed.packages()
exc <- names(packs[,'Package'])
if(is.element(elpa,exc)){
cat("      Tout s'est bien passe pour ",elpa,"\n")
}
}
}

cat("\n\n\n ***FIN DU SCRIPT*** \n\n\n")

cat("installations depuis github")

try(remotes::install_github( "ThinkR-open/prenoms"  ,upgrade = "always"))
#try(remotes::install_github("ThinkR-open/remedy" ,upgrade = "always"))
try(remotes::install_github("ThinkR-open/shopping" ,upgrade = "always"))
#try(remotes::install_github("Thinkr-open/golem" ,upgrade = "always"))
~#try(remotes::install_github("rstudio/parsons"),upgrade = "never")
cat("    FIN - installations depuis github")


packs <- installed.packages()
exc <- names(packs[,'Package'])

cat("\n\n\nla liste ci dessous indique le statut des differents packages : \n\n")

synth <- cbind(ainstaller,is.element(ainstaller,exc))
manque <- synth[synth[,2]=="FALSE",]

try(mon_print(synth),silent = TRUE)



cat("\n\n\nla liste ci dessous indique les packages manquants : \n\n")

try(mon_print(manque),silent = TRUE)

if (NROW(manque)==0){cat("Parfait, il n'y a aucun package manquant\n\n\n")}
try(silent=TRUE,rm(ainstaller,elpa,exc,packs,percent,mon_print,synth,manque,vrai_liste))
