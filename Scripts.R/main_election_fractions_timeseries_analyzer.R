rm(list=ls())
gc()

options(digits=22)

list.of.packages <- c("glue", "jsonlite", "curl", "httr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(httr)

bool.download.json <- TRUE
bool.generate.csv  <- TRUE
bool.backup.csv    <- TRUE

base_dir <- getwd()
if(!endsWith(base_dir,"StopTheSteal/Scripts.R"))
{
  stop(paste0("Invalid working directory '",base_dir,"'. Must end with 'StopTheSteal/Scripts.R'."))
}
working_dir <- paste0(base_dir,"/input/elections-assets/2020/data/api/2020-11-03/race-page")
str.input.file.path <- working_dir
#str.output.file.path <- paste0(working_dir, "/Output")
#setwd(working_dir)

state_strings <- c("alabama", "alaska", "arizona", "arkansas", "california",
                   "colorado", "connecticut", "delaware", "district-of-columbia", "florida",
                   "georgia", "hawaii", "idaho", "illinois", "indiana",
                   "iowa", "kansas", "kentucky", "louisiana", "maine",
                   "maryland", "massachusetts", "michigan", "minnesota", "mississippi",
                   "missouri", "montana", "nebraska", "nevada", "new-hampshire",
                   "new-jersey", "new-mexico", "new-york", "north-carolina", "north-dakota",
                   "ohio", "oklahoma", "oregon", "pennsylvania", "rhode-island",
                   "south-carolina", "south-dakota", "tennessee", "texas", "utah",
                   "vermont", "virginia", "washington", "west-virginia", "wisconsin",
                   "wyoming")

senate_state_strings <- c("alabama", "alaska", "arkansas", "colorado", "delaware", "georgia", 
                          "idaho", "illinois", "iowa", "kansas", "kentucky", "louisiana", 
                          "maine", "massachusetts", "michigan", "minnesota", "mississippi", 
                          "montana", "nebraska", "new-hampshire", "new-jersey", "new-mexico", 
                          "north-carolina", "oklahoma", "oregon", "rhode-island", "south-carolina", 
                          "south-dakota", "tennessee", "texas", "virginia", "west-virginia", 
                          "wyoming")

special_state_strings <- c("arizona", "georgia")

race_strings <- c("president", "senate", "special")

for(race_index in 1:length(race_strings))
{
  race <- race_strings[race_index]
  if(race == "special")
  {
    url_string <- "senate/0/special.json"
    path_string <- "special"
  } else if (race == "president")
  {
    url_string <- "president.json"
    path_string <- "president"
  } else if (race == "senate")
  {
    url_string <- "senate.json"
    path_string <- "senate"
  }
  
  for(state_index in 1:length(state_strings))
  {
    curr_state_name <- state_strings[state_index]
    json_path <- paste0(working_dir,"/",curr_state_name)
    json_path_name <- paste0(json_path,"/",path_string,".json")
    json_url <- glue::glue("https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/{curr_state_name}/{url_string}")
    backup_json_path_name <- paste0(json_path_name,".backup")
    if(bool.download.json)
    {
      resp <- GET(json_url)
      if (status_code(resp) == 200)
      {
        print(paste0("Downloading JSON for ", curr_state_name, ", ", path_string))
        res <- jsonlite::fromJSON(json_url)
        
        if(!dir.exists(json_path))
        {
          dir.create(json_path, recursive = T)
        }
        if(bool.backup.csv & file.exists(json_path_name))
        {
          if(file.exists(backup_json_path_name))
          {
            file.remove(backup_json_path_name)
          }
          file.rename(from = json_path_name, to = backup_json_path_name)
        }
        jsonlite::write_json(res, path = json_path_name)
      }
    } else if(bool.backup.csv)
    {
      if(dir.exists(json_path) & file.exists(json_path_name))
      {
        if(file.exists(backup_json_path_name))
        {
          file.remove(backup_json_path_name)
        }
        file.copy(from = json_path_name, to = backup_json_path_name)
      }
    }
    if(!bool.backup.csv & file.exists(backup_json_path_name))
    {
      file.remove(backup_json_path_name)
    }
    if(bool.generate.csv & file.exists(json_path_name))
    {
      print(paste0("Generating CSV for ", curr_state_name, ", ", path_string))
      res <- jsonlite::read_json(path = json_path_name)
      timeseries <- res$data$races[[1]]$timeseries
      n <- length(timeseries)
      df.timeseries <- data.frame(eevp_source=character(n),
                                  timestamp=character(n),
                                  votes=integer(n),
                                  eevp=double(n),
                                  stringsAsFactors=FALSE)
      arr.choices.in <- names(timeseries[[1]]$vote_shares)
      if(length(arr.choices.in) > 0)
      {
        arr.choices.out <- paste0("vote_shares_", arr.choices.in)
        for(k in 1:length(arr.choices.out))
        {
          df.timeseries[arr.choices.out[k]] <- 0.0
        }
      } else
      {
        arr.choices.out <- arr.choices.in
      }
      for(j in 1:n)
      {
        df.timeseries$eevp_source[j] <- timeseries[[j]]$eevp_source
        df.timeseries$timestamp[j] <- timeseries[[j]]$timestamp
        df.timeseries$votes[j] <- timeseries[[j]]$votes
        df.timeseries$eevp[j] <- timeseries[[j]]$eevp
        if(length(arr.choices.in) > 0)
        {
          for(k in 1:length(arr.choices.out))
          {
            df.timeseries[j,arr.choices.out[k]] <- timeseries[[j]]$vote_shares[[arr.choices.in[k]]]
          }
        }
      }
      posix_time <- as.POSIXlt(strptime(df.timeseries$timestamp, "%Y-%m-%dT%H:%M:%SZ"))
      curr_time <- unclass(posix_time)
      df.timeseries$sec_offset <- as.numeric(posix_time)
      df.timeseries$year <- curr_time$year + 1900
      df.timeseries$mon  <- curr_time$mon + 1
      df.timeseries$mday <- curr_time$mday
      df.timeseries$hour <- curr_time$hour
      df.timeseries$min <- curr_time$min
      df.timeseries$sec <- curr_time$sec
      df.timeseries <- df.timeseries[,c("eevp_source","timestamp","year","mon","mday","hour","min","sec","sec_offset",
                                        "votes","eevp", arr.choices.out)]
      #
      csv_path_name <- paste0(json_path,"/",path_string,".csv")
      write.csv(x = df.timeseries, file = csv_path_name, row.names = FALSE)
    }
  }
}
