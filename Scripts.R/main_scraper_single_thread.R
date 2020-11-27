# Scraper in R
rm(list=ls())
gc()
options(digits.secs=3)
# Missing: AL,AZ,CA,CT,DC,ID,IL,IN,IA,KS,ME,MD,MA,MS,MO,NV,NH,NJ,NY,OH,OR,RI,TN,TX,UT,VT,VA,WI,WY
sa <- c("AK","AR","CO","DE","FL","GA","HI","KY","LA","MI","MN","MT","NE","NM","NC","ND","OK","PA","SC","SD","WA","WV")
pc <- c(   1,   1,   1,   1,   2,   1,   1,   1,   1,   2,   1,   1,   1,   1,   1,   1,   1,   2,   1,   1,   1,   1)
pv <- c("General-", "GeneralConcatenator-")
i <- 6 # for all i | 1 <= i <= length(sa)
sTimeStart <- "2020-11-03T23:40:53.084Z" # set around 11/03/2020
sTimeEnd   <- "2020-11-04T00:11:04.660Z"
dTimeStart <- as.numeric(strptime(sTimeStart,"%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
dTimeEnd   <- as.numeric(strptime(sTimeEnd,  "%Y-%m-%dT%H:%M:%OSZ"))*1000.0 + 0.001
dTimeCurr  <- dTimeStart
while(dTimeCurr <= dTimeEnd)
{
  ts <- format(as.POSIXct(dTimeCurr/1000.0, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
  # ts <- "latest"
  json_url <- paste0("https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/",
                     sa[i],pv[pc[i]],ts,".json")
  if(httr::status_code(httr::GET(json_url)) == 200)
  {
    print(json_url)
  }
  dTimeCurr <- dTimeCurr + 1
}
