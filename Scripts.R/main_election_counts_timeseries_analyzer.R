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
negligible.choice.fraction.upper.threshold <- 0.01 # all election "choices" with votes fraction below this
                                                   # threshold are merged into "votes_others" choice.

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
      df_choices <- lst_county_ids[["df_choices"]]
      rm(lst_county_ids)
      #
      lst_county_vote_type_ids <- generate.county.vote.type.csv(base_dir = base_dir,
                                                                sid = sid,
                                                                state_abbr = state_abbr,
                                                                file_prefix = file_prefix,
                                                                file_postfixes = file_postfixes,
                                                                ht_county_ids = ht_county_ids,
                                                                df_county_ids = df_county_ids,
                                                                df_choices = df_choices)
      ht_county_ids    <- lst_county_vote_type_ids[["ht_county_ids"]]
      df_county_ids    <- lst_county_vote_type_ids[["df_county_ids"]]
      ht_vote_type_ids <- lst_county_vote_type_ids[["ht_vote_type_ids"]]
      df_vote_type_ids <- lst_county_vote_type_ids[["df_vote_type_ids"]]
      df_choices <- lst_county_vote_type_ids[["df_choices"]]
      rm(lst_county_vote_type_ids)
      #
      lst_precinct_ids <- generate.precinct.csv(base_dir = base_dir,
                                                sid = sid,
                                                state_abbr = state_abbr,
                                                file_prefix = file_prefix,
                                                file_postfixes = file_postfixes,
                                                ht_county_ids = ht_county_ids,
                                                df_county_ids = df_county_ids,
                                                df_choices = df_choices)
      ht_county_ids   <- lst_precinct_ids[["ht_county_ids"]]
      df_county_ids   <- lst_precinct_ids[["df_county_ids"]]
      ht_precinct_ids <- lst_precinct_ids[["ht_precinct_ids"]]
      df_precinct_ids <- lst_precinct_ids[["df_precinct_ids"]]
      df_choices <- lst_precinct_ids[["df_choices"]]
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
                                                                    df_vote_type_ids = df_vote_type_ids,
                                                                    df_choices = df_choices)
      ht_county_ids    <- lst_precinct_vote_type_ids[["ht_county_ids"]]
      df_county_ids    <- lst_precinct_vote_type_ids[["df_county_ids"]]
      ht_precinct_ids  <- lst_precinct_vote_type_ids[["ht_precinct_ids"]]
      df_precinct_ids  <- lst_precinct_vote_type_ids[["df_precinct_ids"]]
      ht_vote_type_ids <- lst_precinct_vote_type_ids[["ht_vote_type_ids"]]
      df_vote_type_ids <- lst_precinct_vote_type_ids[["df_vote_type_ids"]]
      df_precinct_vote_type_ids <- lst_precinct_vote_type_ids[["df_precinct_vote_type_ids"]]
      time_origin_ms <- lst_precinct_vote_type_ids[["time_origin_ms"]]
      df_choices <- lst_precinct_vote_type_ids[["df_choices"]]
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
      df_choices <- lst_precinct_ids[["df_choices"]]
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
    # Generate CSV with vote counts. Create CSV with "time_offset_ms" for each state, and start the "time_offset_ms" from 0.
    # ("state.csv"."time_origin_ms" + "time_offset_ms") is the standard offset from the year 1970.
    # Column names {time_offset_ms, sid, cid, pid, vid, tally, votes_<choice1>, votes_<choice2>, votes_<choice3> ...}
    generate.precinct.votes.csv(base_dir = base_dir,
                                time_origin_ms = time_origin_ms,
                                sid = sid,
                                state_abbr = state_abbr,
                                file_prefix = file_prefix,
                                file_postfixes = file_postfixes,
                                ht_vote_type_ids = ht_vote_type_ids,
                                ht_county_ids = ht_county_ids,
                                ht_precinct_ids = ht_precinct_ids,
                                df_choices = df_choices,
                                negligible.choice.fraction.upper.threshold = negligible.choice.fraction.upper.threshold)
  } # END for(sid in 1:length(arrStateAbbrs))
  #
  df_state_ids <- df_state_ids[order(df_state_ids$state_abbr),]
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  write.csv(x = df_state_ids, file = paste0(csv_path,"/","state",".csv"), row.names = FALSE)
} # END if(bool.convert.json.to.csv)

##########################################################################################################
#
# TBD: save all "csv" files as "Rda" files. Then use "Rda" files for the subsequent statistical analysis.
#
# save(foo,file="data.Rda")
# load("data.Rda")
#
##########################################################################################################
#
# Summary of Tasks:
#
# 1. Precincts in all time slices.
#
#    a. Total tally and each choice counts must be monotonically non-decreasing along the time line.
#       Any decrease pay point election fraud. A decrease for one election choice and an increase in
#       another election choice may point to "vote flipping".
#    b. Total tally and each choice count must start from zero at the minimum time slice.
#    c. Total tally must be equal to the sum of all choice counts.
#    d. Total tally must not exceed the total number of registered voters, which must be available
#       for such validation.
#    e. Turnout (i.e. the total tally over the number of registered votes) should not be too low or
#       too high, especially for larger precincts. This validation requires both a benchmark (e.g.
#       last election cycle or concurrent race) and a measure: hypergeometric cumulative density
#       function.
#
# 2. Time line of vote tally.
#
#    a. Convert irregular intervals into the regular (fixed-length) ones. Both types of intervals
#       are discrete, but the regular ones should be as short as possible to proxy the continuous
#       time line. Vote counts from short irregular intervals must be aggregated; vote counts from
#       long irregular intervals must be summed up; vote counts from adjacent irregular intervals
#       may need to be split between the newly created adjacent regular intervals.
#    b. Plot regular interval-specific tally increases along the time line with regular intervals.
#       Observe and comment on the spikes in tally increases on the time line. These spikes may point
#       to election fraud ("ballot stuffing").
#
# 3. Vote counts for election choices.
#
#    a. Convert the time-sorted flow of vote tally counts from variable-size batches into the
#       fixed-size batches. Both types of batches are discrete, but the fixed-size ones should be
#       as small as possible to proxy continuous time line. Vote counts from small variable-size
#       batches must be aggregated; vote counts from large variable-size batches must be summed up;
#       vote counts from adjacent variable-size batches may need to be split between the newly
#       created adjacent fixed-size batches.
#    b. Plot fixed-size batch-specific vote percent for each election choice, on top of the final
#       statewide vote percent (as a proxy for the "true" result) for each election choice. Observe
#       and comment on the long periods on the time line, when one election choice has unusually high
#       or low vote percent in inflows, compared with the statewide final results. These long periods
#       may point to election fraud ("ballot stuffing").
#
##########################################################################################################
