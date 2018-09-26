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
  ainstaller<-unique(sort(c("abind","arsenal", "abn","remotes", "bbmle", "bit64", "CADFtest","rmdformats","writexl",
                            "pryr","ggraph","togglr","shinyBS",
                            
                            "car", "chron", "usethis","reprex","rusk","gapminder","shinyWidgets",
                       "class", "cluster", "colorspace", "compiler", "data.table", "DBI", 
                       "devEMF", "devtools", "dichromat", "digest", "doSNOW", "dplyr","dygraphs", 
                       "e1071", "ellipse", "evaluate", "explor", "FactoMineR", "Factoshiny", "plotly",
                        "forecast", "foreign", "formatR", "Formula", "fortunes", 
                       "ggplot2", "ggthemes", "gmm", "gplots", "graphics", "grDevices", 
                       "grid", "gtable", "haven", "hflights", "highr", "Hmisc", "htmltools", 
                       "jpeg", "knitr", "labeling", "lattice", "latticeExtra", "leaps", 
                       "markdown", "MASS", "methods", "mime", "moments", "munsell", 
                        "nls2", "nnet", "nortest", "openxlsx", "packrat", "plyr","fcuk", 
                       "proto", "pvclust", "raster", "Rcmdr", "RcmdrMisc", "RcmdrPlugin.FactoMineR", 
                       "RColorBrewer", "Rcpp", "readr", "readxl",  
                       "reshape", "reshape2", "rJava", "rmarkdown", "roxygen2", "rtable", 
                       "sandwich", "sas7bdat", "scales", "scatterplot3d", "SensoMineR", 
                       "splines", "sqldf", "stats", "stringr", "survival", "tcltk", 
                       "tcltk2", "tidyverse", "tools", "tseries", "utils", "XLConnect", 
                       "XLConnectJars", "xtable", "xts", "zoo","shinydashboard","fcuk","attempt",
                       "icarus", "proustr", "rvest", "httr", "R6", "tidytext", "tidystringdist",
                       "topicmodels","broom", "h2o", "rpart", "randomForest", "gbm","thinkr","rusk", 
                       "rmdformats", "shinydashboard", "microbenchmark", "nycflights13", "reprex"
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

try(remotes::install_github( "ThinkR-open/prenoms" ))
try(remotes::install_github("ThinkR-open/remedy"))
try(remotes::install_github("ThinkR-open/shopping"))
try(remotes::install_github("Thinkr-open/shinytemplate"))
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
