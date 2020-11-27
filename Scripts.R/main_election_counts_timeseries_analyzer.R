rm(list=ls())
gc()

options(digits=22)
options(digits.secs=3)

list.of.packages <- c("jsonlite", "httr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("jsonlite")
library("httr")

base_dir <- getwd()
if(!endsWith(base_dir,"StopTheSteal/Scripts.R"))
{
  stop(paste0("Invalid working directory '",base_dir,"'. Must end with 'StopTheSteal/Scripts.R'."))
}
working_dir <- base_dir
str.input.file.path <- working_dir
#setwd(working_dir)
source("library_election_timeseries_analyzer.R")

bool.download.json       <- FALSE # set it to TRUE to download the JSON dataset and overwrite the existing JSON dataset.
bool.convert.json.to.csv <- TRUE  # set it to TRUE to convert the existing (downloaded) JSON dataset into CSV dataset.

if(bool.download.json)
{
  download.json(base_dir = base_dir)
}

#######################################################################################################

if(bool.convert.json.to.csv)
{
  df_state_ids <- data.frame(
    sid              = numeric(),
    state_abbr       = character(),
    state_name       = character(),
    time_origin_ms   = numeric(),
    stringsAsFactors = FALSE)
  for(sid in 1:length(arrStateAbbrs))
  {
    state_abbr <- arrStateAbbrs[sid]
    state_name <- arrStateNames[sid]
    file_prefix <- list_file_prefixes[[state_abbr]]
    file_postfixes <- list_file_postfixes[[state_abbr]]
    #
    if(state_abbr %in% c("PA", "FL"))
    {
      lst_county_ids <- generate.county.csv(base_dir = base_dir,
                                           sid = sid,
                                           state_abbr = state_abbr,
                                           file_prefix = file_prefix,
                                           file_postfixes = file_postfixes)
      ht_county_ids <- lst_county_ids[["ht_county_ids"]]
      df_county_ids <- lst_county_ids[["df_county_ids"]]
      rm(lst_county_ids)
      #
      lst_county_vote_type_ids <- generate.county.vote.type.csv(base_dir = base_dir,
                                                                sid = sid,
                                                                state_abbr = state_abbr,
                                                                file_prefix = file_prefix,
                                                                file_postfixes = file_postfixes,
                                                                ht_county_ids = ht_county_ids,
                                                                df_county_ids = df_county_ids)
      ht_county_ids    <- lst_county_vote_type_ids[["ht_county_ids"]]
      df_county_ids    <- lst_county_vote_type_ids[["df_county_ids"]]
      ht_vote_type_ids <- lst_county_vote_type_ids[["ht_vote_type_ids"]]
      df_vote_type_ids <- lst_county_vote_type_ids[["df_vote_type_ids"]]
      rm(lst_county_vote_type_ids)
      #
      lst_precinct_ids <- generate.precinct.csv(base_dir = base_dir,
                                                sid = sid,
                                                state_abbr = state_abbr,
                                                file_prefix = file_prefix,
                                                file_postfixes = file_postfixes,
                                                ht_county_ids = ht_county_ids,
                                                df_county_ids = df_county_ids)
      ht_county_ids   <- lst_precinct_ids[["ht_county_ids"]]
      df_county_ids   <- lst_precinct_ids[["df_county_ids"]]
      ht_precinct_ids <- lst_precinct_ids[["ht_precinct_ids"]]
      df_precinct_ids <- lst_precinct_ids[["df_precinct_ids"]]
      rm(lst_precinct_ids)
      #
      lst_precinct_vote_type_ids <- generate.precinct.vote.type.csv(base_dir = base_dir,
                                                                    sid = sid,
                                                                    state_abbr = state_abbr,
                                                                    file_prefix = file_prefix,
                                                                    file_postfixes = file_postfixes,
                                                                    ht_county_ids = ht_county_ids,
                                                                    df_county_ids = df_county_ids,
                                                                    ht_precinct_ids = ht_precinct_ids,
                                                                    df_precinct_ids = df_precinct_ids,
                                                                    ht_vote_type_ids = ht_vote_type_ids,
                                                                    df_vote_type_ids = df_vote_type_ids)
      ht_county_ids    <- lst_precinct_vote_type_ids[["ht_county_ids"]]
      df_county_ids    <- lst_precinct_vote_type_ids[["df_county_ids"]]
      ht_precinct_ids  <- lst_precinct_vote_type_ids[["ht_precinct_ids"]]
      df_precinct_ids  <- lst_precinct_vote_type_ids[["df_precinct_ids"]]
      ht_vote_type_ids <- lst_precinct_vote_type_ids[["ht_vote_type_ids"]]
      df_vote_type_ids <- lst_precinct_vote_type_ids[["df_vote_type_ids"]]
      df_precinct_vote_type_ids <- lst_precinct_vote_type_ids[["df_precinct_vote_type_ids"]]
      time_origin_ms <- lst_precinct_vote_type_ids[["time_origin_ms"]]
      rm(lst_precinct_vote_type_ids)
    } else if (state_abbr %in% c("NC", "MI", "GA"))
    {
      lst_precinct_ids <- generate.precinct.csv2(base_dir = base_dir,
                                                 sid = sid,
                                                 state_abbr = state_abbr,
                                                 file_prefix = file_prefix,
                                                 file_postfixes = file_postfixes)
      ht_vote_type_ids <- lst_precinct_ids[["ht_vote_type_ids"]]
      df_vote_type_ids <- lst_precinct_ids[["df_vote_type_ids"]]
      ht_county_ids    <- lst_precinct_ids[["ht_county_ids"]]
      df_county_ids    <- lst_precinct_ids[["df_county_ids"]]
      ht_precinct_ids  <- lst_precinct_ids[["ht_precinct_ids"]]
      df_precinct_ids  <- lst_precinct_ids[["df_precinct_ids"]]
      df_county_vote_type_ids <- lst_precinct_ids[["df_county_vote_type_ids"]]
      df_precinct_vote_type_ids <- lst_precinct_ids[["df_precinct_vote_type_ids"]]
      time_origin_ms <- lst_precinct_ids[["time_origin_ms"]]
      rm(lst_precinct_ids)
    }
    df_state_ids_row <- data.frame(
      sid              = numeric(1),
      state_abbr       = character(1),
      state_name       = character(1),
      time_origin_ms   = numeric(1),
      stringsAsFactors = FALSE)
    df_state_ids_row$sid[1]            <- sid
    df_state_ids_row$state_abbr[1]     <- state_abbr
    df_state_ids_row$state_name[1]     <- state_name
    df_state_ids_row$time_origin_ms[1] <- time_origin_ms
    df_state_ids <- rbind(df_state_ids, df_state_ids_row)
    #
    # Generate CSV with votes. Create CSV with "time_offset_ms" for each state, and start "time_offset_ms" from 0.
    # time_offset_ms, sid, cid, pid, vid, votes_tally, <votes_choice1>, <votes_choice2>, ...
    generate.precinct.votes.csv(base_dir = base_dir,
                                time_origin_ms = time_origin_ms,
                                sid = sid,
                                state_abbr = state_abbr,
                                file_prefix = file_prefix,
                                file_postfixes = file_postfixes,
                                ht_vote_type_ids = ht_vote_type_ids,
                                ht_county_ids = ht_county_ids,
                                ht_precinct_ids = ht_precinct_ids)
  } # END for(sid in 1:length(arrStateAbbrs))
  #
  df_state_ids <- df_state_ids[order(df_state_ids$state_abbr),]
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  write.csv(x = df_state_ids, file = paste0(csv_path,"/","state",".csv"), row.names = FALSE)
} # END if(bool.convert.json.to.csv)
