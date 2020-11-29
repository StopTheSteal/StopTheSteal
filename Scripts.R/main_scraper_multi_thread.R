# https://www.gis-blog.com/increasing-the-speed-of-raster-processing-with-r-part-23-parallelisation/
# https://stackoverflow.com/questions/59680543/use-of-brick-raster-within-doparallel-parallel-loop-in-r
#
# Multithreaded Scraper in R
rm(list=ls())
gc()
options(digits.secs=3)
list.of.packages <- c("foreach", "doParallel", "httr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library("foreach")
library("doParallel")

sa          <- c("AK","AR","CO","DE","FL","GA","HI","KY","LA","MI","MN","MT","NE","NM","NC","ND","OK","PA","SC","SD","WA","WV")
pc          <- c(   1,   1,   1,   1,   2,   1,   1,   1,   1,   2,   1,   1,   1,   1,   1,   1,   1,   2,   1,   1,   1,   1)
pv          <- c("General-", "GeneralConcatenator-")
i           <- 6 # for all i | 1 <= i <= length(sa)
sTimeStartG <- "2020-11-04T00:11:04.659Z" # set around 11/03/2020
sTimeEndG   <- "2020-11-04T00:11:05.659Z"
dTimeStartG <- as.numeric(strptime(sTimeStartG,"%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
dTimeEndG   <- as.numeric(strptime(sTimeEndG,  "%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
UseCores    <- parallel::detectCores()-1
sq          <- seq(dTimeStartG,dTimeEndG,(dTimeEndG-dTimeStartG)/UseCores)
intervals   <- list(beg=ceiling(sq[1:(length(sq)-1)]-0.001)+0.001,end=floor(sq[2:length(sq)]-0.001)+0.001)
start_time  <- Sys.time()
cl          <- parallel::makeCluster(UseCores)
doParallel::registerDoParallel(cl)
res_global <- foreach(j=1:length(intervals[[1]])) %dopar%
  {
    library("httr")
    options(digits.secs=3)
    res_local <- ""
    dTimeStartL <- intervals[[1]][j]
    dTimeEndL   <- intervals[[2]][j]
    dTimeCurrL  <- dTimeStartL
    while(dTimeCurrL <= dTimeEndL)
    {
      ts <- format(as.POSIXct(dTimeCurrL/1000.0, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
      # ts <- "latest"
      json_url <- paste0("https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/",
                         sa[i],pv[pc[i]],ts,".json")
      status_code <- tryCatch({httr::status_code(httr::GET(json_url, config = httr::config(connecttimeout = 20)))},
                              error=function(cond){return(200)},
                              warning=function(cond){return(200)})#,
                              #finally={})
      if(status_code == 200)
      {
        res_local <- paste0(res_local,"|",json_url)
      }
      dTimeCurrL <- dTimeCurrL + 1
    }
    return(res_local)
  }
stopCluster(cl)
end_time <- Sys.time()
print(paste0("Run ", round(difftime(end_time, start_time, units = "secs"),3), " secs on ", UseCores,
             " Cores to scrap ", (dTimeEndG - dTimeStartG)/1000.0 + 0.001, " secs"))
print(paste(res_global, collapse = ''))
