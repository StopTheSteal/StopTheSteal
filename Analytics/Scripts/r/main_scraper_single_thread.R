# Scraper in R
rm(list=ls())
gc()

options(digits=22)
options(digits.secs=3)

list.of.packages <- c("httr", "curl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(httr)
library(curl)

# https://community.rstudio.com/t/internet-resources-should-fail-gracefully/49199/11
http_error_extended <- function(remote_file)
{
  try_GET <- function(x, ...)
  {
    tryCatch(
      GET(url = x, timeout(10), ...),
      error = function(e) conditionMessage(e),
      warning = function(w) conditionMessage(w)
    )
  }
  is_response <- function(x)
  {
    class(x) == "response"
  }
  # First check internet connection
  if (!curl::has_internet())
  {
    #message("No internet connection.")
    return(TRUE)
  }
  # Then try for timeout problems
  resp <- try_GET(remote_file)
  if (!is_response(resp))
  {
    #message(resp)
    return(TRUE)
  }
  # Then stop if status > 400
  if (httr::http_error(resp))
  { 
    #message_for_status(resp)
    return(TRUE)
  }
  
  # If you are using rvest as I do you can easily read_html in the response
  #xml2::read_html(resp)
  return(FALSE)
}

# Missing: AL,AZ,CA,CT,DC,ID,IL,IN,IA,KS,ME,MD,MA,MS,MO,NV,NH,NJ,NY,OH,OR,RI,TN,TX,UT,VT,VA,WI,WY
sa <- c("AK","AR","CO","DE","FL","GA","HI","KY","LA","MI","MN","MT","NE","NM","NC","ND","OK","PA","SC","SD","WA","WV")
pc <- c(   1,   1,   1,   1,   2,   1,   1,   1,   1,   2,   1,   1,   1,   1,   1,   1,   1,   2,   1,   1,   1,   1)
pv <- c("General-", "GeneralConcatenator-")
#i <- 19 # for all i | 1 <= i <= length(sa)
i <- 5
#sTimeStart <- "2020-11-04T00:00:28.000Z" # set around 11/03/2020
#sTimeEnd   <- "2020-11-04T00:01:00.000Z"
sTimeStart <- "2020-11-04T00:00:48.404Z" # set around 11/03/2020
sTimeEnd   <- "2020-11-04T00:00:48.406Z"
numTimeStart <- as.numeric(strptime(sTimeStart,"%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
numTimeEnd   <- as.numeric(strptime(sTimeEnd,  "%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
#
numTimeCurr  <- numTimeStart
json_urls_exist_all <- c()
intTimeIncrementMs <- 1
while(numTimeCurr <= numTimeEnd)
{
  json_urls <- c(NA)
  length(json_urls) <- min(1000, numTimeEnd - numTimeCurr + 1)
  ts0 <- format(as.POSIXct(numTimeCurr/1000.0, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
  for(iTimeIndex in 1:length(json_urls))
  {
    ts <- format(as.POSIXct(numTimeCurr/1000.0, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
    # ts <- "latest"
    json_urls[iTimeIndex] <- paste0("https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/",
                                    sa[i],pv[pc[i]],ts,".json")
    numTimeCurr <- numTimeCurr + intTimeIncrementMs
  }
  print(paste0("Processing '", sa[i], "' in a batch of size ", length(json_urls),
               " from '", ts0, "' with increments ", intTimeIncrementMs, " ms ..."))
  start_time  <- Sys.time()
  # If the timeout is exceeded in "httr::http_error", the following fatal error occurs:
  #
  # Error in curl::curl_fetch_memory(url, handle = handle) : 
  # Timeout was reached: [static01.nyt.com] Operation timed out after 120000 milliseconds with
  # 0 out of 0 bytes received
  #
  #json_urls_exist_curr <- json_urls[!sapply(X=json_urls, FUN = httr::http_error,
  #                                          config(followlocation = 0L), USE.NAMES = FALSE)]
  json_urls_exist_curr <- json_urls[!sapply(json_urls, FUN = http_error_extended)]
  end_time <- Sys.time()
  print(paste0("Completed in ", round(difftime(end_time, start_time, units = "secs"),3), " seconds."))
  print(json_urls_exist_curr)
  json_urls_exist_all <- c(json_urls_exist_all, json_urls_exist_curr)
}
json_urls_exist_all
