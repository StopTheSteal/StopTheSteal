rm(list=ls())
gc()

options(digits=22)
options(digits.secs=3)

list.of.packages <- c("jsonlite", "httr", "caroline", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("jsonlite")
library("httr")
library("caroline")
library("dplyr")

base_dir <- getwd()
# "GenElec2020/VoterRollsAnalysis"
# "GenElec2020/StopTheSteal/Analytics/Scripts/r"
if(!endsWith(base_dir,"StopTheSteal/Analytics/Scripts/r"))
{
  stop(paste0("Invalid working directory '",base_dir,"'. Must end with 'StopTheSteal/Scripts.R'."))
}
working_dir <- base_dir
str.input.file.path <- working_dir
#setwd(working_dir)
source("library_election_timeseries_analyzer.R")

bool.rename.files <- FALSE # be careful with this indicator
bool.convert.json.to.csv <- FALSE  # set it to TRUE to convert the existing (downloaded) JSON data set into CSV data set.
bool.convert.csv.to.rds  <- FALSE
bool.aggregate.csv.by.county <- FALSE
str_election_date_YYYYMMDD <- "20210105"

# wget -O GA_S_1_5_2021`date +"%Y%m%d-%H%M%S"`.json https://static01.nyt.com/elections-assets/2020/data/api/2021-01-05/state-page/georgia.json
# GASenateSpecialRunoff_2021_01_05_17_58_00_000.json
# ...
# GASenateSpecialRunoff_2021_01_06_20_21_19_000.json
#######################################################################################################
if(bool.rename.files)
{
  json_path <- paste0(str.input.file.path,"/input/elections-assets/2020/data/precincts")
  f <- as.data.frame(list.files(path = json_path, pattern = "nyt_GASenateSpecialRunoff-latest_.*json"), header=FALSE)
  colnames(f) <- 'files.old'
  f$files.new <- sapply(f$files.old,function(x) gsub("^[^.]*.",paste(gsub(".[^.]*$", "", x), '000.', sep='_'),x))
  f$files.new <- gsub("-", "_", f$files.new)
  f$files.new <- gsub("_latest", "", f$files.new)
  f$files.new <- gsub("^nyt_", "", f$files.new)
  file.rename(as.vector(paste0(json_path,"/",f$files.old)),
              as.vector(paste0(json_path,"/",f$files.new)))
}

if(bool.convert.json.to.csv)
{
  negligible.choice.fraction.upper.threshold <- 0.05 # all election "choices" with votes fraction below this threshold are merged into "votes_others" choice.
  arrStateAbbrs_Special <- c("GA")
  arrStateNames_Special <- c("Georgia") # GA
  list_file_prefixes_Special <- list(GA = "GASenateSpecialRunoff_")
  json_path <- paste0(str.input.file.path,"/input/elections-assets/2020/data/precincts")
  f <- as.data.frame(list.files(path = json_path, pattern = "GASenateSpecialRunoff_.*json"), header=FALSE)
  colnames(f) <- 'file_names'
  f <- f[order(f$file_names),]
  list_file_postfixes_Special <- list(
    GA = gsub("\\.json$","",gsub("^GASenateSpecialRunoff_","", f)))
  
  df_state_ids <- data.frame(
    sid              = numeric(),
    state_abbr       = character(),
    state_name       = character(),
    time_origin_ms   = numeric(),
    stringsAsFactors = FALSE)
  for(sid in 1:length(arrStateAbbrs_Special))
  {
    state_abbr <- arrStateAbbrs_Special[sid]
    state_name <- arrStateNames_Special[sid]
    file_prefix <- list_file_prefixes_Special[[state_abbr]]
    file_postfixes <- list_file_postfixes_Special[[state_abbr]]
    #
    if (state_abbr %in% c("GA"))
    {
      lst_precinct_ids <- generate.precinct.csv2(base_dir = base_dir,
                                                 sid = sid,
                                                 state_abbr = state_abbr,
                                                 file_prefix = file_prefix,
                                                 file_postfixes = file_postfixes,
                                                 orig_file_postfixes = FALSE,
                                                 str_election_date_YYYYMMDD = str_election_date_YYYYMMDD)
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
                                negligible.choice.fraction.upper.threshold = negligible.choice.fraction.upper.threshold,
                                orig_file_postfixes = FALSE,
                                str_election_date_YYYYMMDD = str_election_date_YYYYMMDD)
  } # END for(sid in 1:length(arrStateAbbrs))
  #
  df_state_ids <- df_state_ids[order(df_state_ids$state_name),]
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  write.csv(x = df_state_ids, file = paste0(csv_path,"/","state", str_election_date_YYYYMMDD,".csv"), row.names = FALSE)
} # END if(bool.convert.json.to.csv)

##########################################################################################################

if(bool.convert.csv.to.rds)
{
  # Save all "csv" files as "rds" files. Then use "rds" files for the subsequent statistical analysis.
  for(iStateIndex in 1:length(arrStateAbbrs_Special))
  {
    state_abbr <- arrStateAbbrs_Special[iStateIndex]
    generate.rds.from.csv(base_dir = base_dir, state_abbr = state_abbr, bool.save.state = (iStateIndex == 1),
                          str_election_date_YYYYMMDD = str_election_date_YYYYMMDD)
  }
} # END if(bool.convert.csv.to.rds)

if(bool.aggregate.csv.by.county)
{
  str.input.path <- paste0(base_dir, "/input/elections-assets/2020/data/precincts/rds")
  df_state20210105 <- readRDS(paste0(str.input.path,"/","state20210105.rds"))
  df_GA20210105_county <- readRDS(paste0(str.input.path,"/","GA20210105_county.rds"))
  df_GA20210105_county_vote_type <- readRDS(paste0(str.input.path,"/","GA20210105_county_vote_type.rds"))
  df_GA20210105_precinct <- readRDS(paste0(str.input.path,"/","GA20210105_precinct.rds"))
  df_GA20210105_precinct_vote_type <- readRDS(paste0(str.input.path,"/","GA20210105_precinct_vote_type.rds"))
  df_GA20210105_precinct_vote_type_count_ts <- readRDS(paste0(str.input.path,"/","GA20210105_precinct_vote_type_count_ts.rds"))
  df_GA20210105_vote_type <- readRDS(paste0(str.input.path,"/","GA20210105_vote_type.rds"))

  df_GA20210105_precinct_vote_type_count_ts$tally <- as.integer(df_GA20210105_precinct_vote_type_count_ts$tally)
  df_GA20210105_precinct_vote_type_count_ts$votes_warnockr <- as.integer(df_GA20210105_precinct_vote_type_count_ts$votes_warnockr)
  df_GA20210105_precinct_vote_type_count_ts$votes_loefflerk <- as.integer(df_GA20210105_precinct_vote_type_count_ts$votes_loefflerk)
  
  df_GA20210105_precinct_vote_type_count_ts.by_sid <-
    df_GA20210105_precinct_vote_type_count_ts %>%
    group_by(time_offset_ms, sid) %>%
    summarise(tally=sum(tally),
              votes_warnockr=sum(votes_warnockr),
              votes_loefflerk=sum(votes_loefflerk))
  
  df_GA20210105_precinct_vote_type_count_ts.by_sid_vid <-
    df_GA20210105_precinct_vote_type_count_ts %>%
    group_by(time_offset_ms, sid, vid) %>%
    summarise(tally=sum(tally),
              votes_warnockr=sum(votes_warnockr),
              votes_loefflerk=sum(votes_loefflerk))
  
  df_GA20210105_precinct_vote_type_count_ts.by_sid_cid <-
    df_GA20210105_precinct_vote_type_count_ts %>%
    group_by(time_offset_ms, sid, cid) %>%
    summarise(tally=sum(tally),
              votes_warnockr=sum(votes_warnockr),
              votes_loefflerk=sum(votes_loefflerk))
  
  df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid <-
    df_GA20210105_precinct_vote_type_count_ts %>%
    group_by(time_offset_ms, sid, cid, vid) %>%
    summarise(tally=sum(tally),
              votes_warnockr=sum(votes_warnockr),
              votes_loefflerk=sum(votes_loefflerk))
  
  nrow(df_GA20210105_precinct_vote_type_count_ts) # 1,242,956
  nrow(df_GA20210105_precinct_vote_type_count_ts.by_sid) # 117
  nrow(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid) # 468 = 4 * 117
  nrow(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid) # 18,602 = 4 * 116.99371069182389
  nrow(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid) # 74,408 = 4 * 117 * 158.991452991453
  length(unique(df_GA20210105_precinct_vote_type_count_ts$time_offset_ms)) # 117
  length(unique(df_GA20210105_county$sid)) # 1
  length(unique(df_GA20210105_vote_type$vid)) # 4
  length(unique(df_GA20210105_county$cid)) # 159

  #######################################################################################################################
  # Save/Plot the following time series:
  #
  # 1. Entire state (1)                  # df_GA20210105_precinct_vote_type_count_ts.by_sid
  # 2. Entire state, each vote type (4). # df_GA20210105_precinct_vote_type_count_ts.by_sid_vid
  # 3. Each county (159)                 # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid
  # 4. Each county, each vote type (636) # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid
  
  # 1. Entire state (1)                  # df_GA20210105_precinct_vote_type_count_ts.by_sid
  if(FALSE)
  {
    #head(df_GA20210105_precinct_vote_type_count_ts.by_sid)
    df_curr_ts <- df_GA20210105_precinct_vote_type_count_ts.by_sid
    df_curr_ts <- df_curr_ts[order(df_curr_ts$time_offset_ms),]
    plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_warnockr / df_curr_ts$tally * 100)
    lines(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_loefflerk / df_curr_ts$tally * 100)
  }
  
  # 2. Entire state, each vote type (4). # df_GA20210105_precinct_vote_type_count_ts.by_sid_vid
  if(FALSE)
  {
    #head(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid)
    arr_vids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid$vid)
    arr_vids <- arr_vids[order(arr_vids)]
    for(int_curr_vid in arr_vids)
    {
      df_curr_ts <- df_GA20210105_precinct_vote_type_count_ts.by_sid_vid[
        df_GA20210105_precinct_vote_type_count_ts.by_sid_vid$vid == int_curr_vid,]
      plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_warnockr / df_curr_ts$tally * 100)
      lines(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_loefflerk / df_curr_ts$tally * 100)
    }
  }
  # 3. Each county (159)                 # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid
  if(FALSE)
  {
    #head(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid)
    arr_cids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid$cid)
    arr_cids <- arr_cids[order(arr_cids)]
    for(int_curr_cid in arr_cids)
    {
      if(int_curr_cid <= 5)
      {
        df_curr_ts <- df_GA20210105_precinct_vote_type_count_ts.by_sid_cid[
          df_GA20210105_precinct_vote_type_count_ts.by_sid_cid$cid == int_curr_cid,]
        plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_warnockr / df_curr_ts$tally * 100)
        lines(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_loefflerk / df_curr_ts$tally * 100)
      }
    }
  }
  # 4. Each county, each vote type (636) # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid
  if(FALSE)
  {
    #head(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid)
    arr_vids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$vid)
    arr_vids <- arr_vids[order(arr_vids)]
    arr_cids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$cid)
    arr_cids <- arr_cids[order(arr_cids)]
    for(int_curr_vid in arr_vids)
    {
      for(int_curr_cid in arr_cids)
      {
        if(int_curr_cid <= 5)
        {
          df_curr_ts <- df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid[
            df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$vid == int_curr_vid &
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$cid == int_curr_cid,]
          if(min(df_curr_ts$tally) < max(df_curr_ts$tally)) 
          {
            if(min(df_curr_ts$votes_warnockr) < max(df_curr_ts$votes_warnockr) &
               min(df_curr_ts$votes_loefflerk) < max(df_curr_ts$votes_loefflerk))
            {
              plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_warnockr / df_curr_ts$tally * 100)
              lines(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_loefflerk / df_curr_ts$tally * 100)
            } else if(min(df_curr_ts$votes_warnockr) < max(df_curr_ts$votes_warnockr) &
                      min(df_curr_ts$votes_loefflerk) == max(df_curr_ts$votes_loefflerk))
            {
              plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_warnockr / df_curr_ts$tally * 100)
            } else if(min(df_curr_ts$votes_warnockr) == max(df_curr_ts$votes_warnockr) &
                      min(df_curr_ts$votes_loefflerk) < max(df_curr_ts$votes_loefflerk))
            {
              plot(x = df_curr_ts$time_offset_ms, y = df_curr_ts$votes_loefflerk / df_curr_ts$tally * 100)
            }
          }
        }
      }
    } # END for(int_curr_vid in arr_vids)
  }
  
  
  # TBD: convert to fractional format
  # ...
}

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
