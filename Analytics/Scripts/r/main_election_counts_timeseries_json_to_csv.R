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
#library("lubridate")

base_dir <- getwd()
# "GenElec2020/VoterRollsAnalysis"
# "GenElec2020/StopTheSteal/Analytics/Scripts/r"
if(!endsWith(base_dir,"StopTheSteal/Analytics/Scripts/r"))
{
  stop(paste0("Invalid working directory '",base_dir,"'. Must end with 'StopTheSteal/Scripts.R'."))
}
working_dir <- base_dir
str.input.file.path <- working_dir
str.output.file.path <- paste0(base_dir, "/output")
#setwd(working_dir)
source("library_election_timeseries_analyzer.R")

bool.rename.files <- FALSE # be careful with this indicator
bool.convert.json.to.csv <- FALSE  # set it to TRUE to convert the existing (downloaded) JSON data set into CSV data set.
bool.convert.csv.to.rds  <- FALSE
bool.aggregate.csv.by.county <- FALSE
bool.save.to.csv <- FALSE
bool.save.to.pdf <- FALSE
bool.analyze.county.tail <- FALSE
bool.analyze.precinct.tail <- TRUE
str_election_date_YYYYMMDD <- "20210105"
#str_election_date_YYYYMMDD <- "20210105V2"
str_elec_year <- "2021"
str_elec_month <- "Jan"
race <- "senate"
json_url <- "https://static01.nyt.com/elections-assets/2020/data/api/2021-01-05/precincts/GASenateSpecialRunoff-latest.json"
my_github_base <- "https://github.com/StopTheSteal/StopTheSteal/tree/main/Analytics/Scripts/r"

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

if(bool.rename.files)
{
  json_path <- paste0(str.input.file.path,"/input/elections-assets/2020/data/precincts")
  f <- as.data.frame(list.files(path = json_path, pattern = "JSON-NYT-Precinct-.*json"), header=FALSE)
  colnames(f) <- 'files.old'
  f$files.new <- gsub("JSON-NYT-Precinct-([0-9]{4})([0-9]{2})([0-9]{2})-([0-9]{2})([0-9]{2})\\.json",
                      "GASenateSpecialRunoffV2_\\1_\\2_\\3_\\4_\\5_00_000.json", f$files.old)
  file.rename(as.vector(paste0(json_path,"/",f$files.old)),
              as.vector(paste0(json_path,"/",f$files.new)))
}


if(bool.convert.json.to.csv)
{
  negligible.choice.fraction.upper.threshold <- 0.05 # all election "choices" with votes fraction below this threshold are merged into "votes_others" choice.
  arrStateAbbrs_Special <- c("GA")
  arrStateNames_Special <- c("Georgia") # GA
  str_file_prefix <- "GASenateSpecialRunoff_"
  #str_file_prefix <- "GASenateSpecialRunoffV2_"
  list_file_prefixes_Special <- list(GA = str_file_prefix)
  json_path <- paste0(str.input.file.path,"/input/elections-assets/2020/data/precincts")
  f <- as.data.frame(list.files(path = json_path, pattern = paste0(str_file_prefix,".*json")), header=FALSE)
  colnames(f) <- 'file_names'
  f <- f[order(f$file_names),]
  list_file_postfixes_Special <- list(GA = gsub("\\.json$","",gsub(paste0("^",str_file_prefix),"", f)))
  
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
  #    By [ PDF { interval, plot type } ] 210105_st_GA_ct_all_vt_all.pdf
  # 2. Entire state, each vote type (4). # df_GA20210105_precinct_vote_type_count_ts.by_sid_vid
  #    By [ vote type, PDF { interval, plot type } ] 210105_st_GA_ct_all_vt_<value>.pdf
  # 3. Each county (159)                 # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid
  #    By [ county, PDF { interval, plot type } ] 210105_st_GA_ct_<value>_vt_all.pdf
  # 4. Each county, each vote type (636) # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid
  #    By [ county, vote type, PDF { interval, plot type } ] 210105_st_GA_ct_<value>_vt_<value>.pdf

  lst_lst_str_plot_intervals <-
    list(interval1 = list(min_time = "2021-01-05T19:38:33Z", max_time = "2021-01-09T12:52:06Z"),
         interval2 = list(min_time = "2021-01-05T19:38:33Z", max_time = "2021-01-06T01:00:00Z"),
         interval3 = list(min_time = "2021-01-06T00:00:00Z", max_time = "2021-01-09T12:52:06Z"))
  
  # 1. Entire state (1)                  # df_GA20210105_precinct_vote_type_count_ts.by_sid
  if(TRUE)
  {
    str_elec_type <- "Runoff Election 2021"
    for(county_name in c("all"))
    {
      for(vote_type in c("all"))
      {
        df_election_fractions <- prepare.fraction.data(
          df_election_counts = df_GA20210105_precinct_vote_type_count_ts.by_sid,
          df_state = df_state20210105)
        if(!is.null(df_election_fractions))
        {
          state_name <- df_election_fractions$state_abbr[1]
          output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                                     "ussen_", "st_", state_name, "_", "ct_", county_name, "_", "vt_", vote_type)
          if(bool.save.to.csv)
          {
            csv_output_path <- paste0(base_dir,"/output/csv")
            csv_output_file_name <- paste0(output_file_name, ".csv")
            write.csv(x = df_election_fractions, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
          }
          if(bool.save.to.pdf)
          {
            pdf_output_path <- paste0(base_dir,"/output/pdf")
            pdf_output_file_name <- paste0(output_file_name, ".pdf")
            pdf(file=paste0(pdf_output_path,"/",pdf_output_file_name), width=11, height=8.5, paper="special")
          }
          # In other cases, add "county name" and/or "vote type" to variable "str_elec_type"
          plot.election.results(df_election_fractions = df_election_fractions,
                                state_name = state_name,
                                race = race,
                                str_elec_year = str_elec_year,
                                str_elec_month = str_elec_month,
                                str_elec_type = str_elec_type,
                                json_url = json_url,
                                my_github_base = my_github_base,
                                lst_lst_str_plot_intervals = lst_lst_str_plot_intervals)
          if(bool.save.to.pdf)
          {
            dev.off()
            dev.flush()
          }
        } # END if(!is.null(df_election_fractions))
      } # END for(vote_type in c("all"))
    } # END for(county_name in c("all"))
  } # END if(TRUE)
  
  # 2. Entire state, each vote type (4). # df_GA20210105_precinct_vote_type_count_ts.by_sid_vid
  if(TRUE)
  {
    arr_vids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid$vid)
    arr_vids <- arr_vids[order(arr_vids)]
    for(county_name in c("all"))
    {
      for(int_curr_vid in arr_vids)
      {
        df_election_fractions <- prepare.fraction.data(
          df_election_counts = df_GA20210105_precinct_vote_type_count_ts.by_sid_vid[
            df_GA20210105_precinct_vote_type_count_ts.by_sid_vid$vid == int_curr_vid,],
          df_state = df_state20210105)
        if(!is.null(df_election_fractions))
        {
          state_name <- df_election_fractions$state_abbr[1]
          vote_type <- df_GA20210105_vote_type$vote_type[df_GA20210105_vote_type$vid == int_curr_vid &
                                                           df_GA20210105_vote_type$sid == df_election_fractions$sid[1]]
          str_elec_type <- paste0("Runoff Election (", vote_type, ") 2021")
          output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                                     "ussen_", "st_", state_name, "_", "ct_", county_name, "_", "vt_", substr(vote_type,1,5))
          if(bool.save.to.csv)
          {
            csv_output_path <- paste0(base_dir,"/output/csv")
            csv_output_file_name <- paste0(output_file_name, ".csv")
            write.csv(x = df_election_fractions, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
          }
          if(bool.save.to.pdf)
          {
            pdf_output_path <- paste0(base_dir,"/output/pdf")
            pdf_output_file_name <- paste0(output_file_name, ".pdf")
            pdf(file=paste0(pdf_output_path,"/",pdf_output_file_name), width=11, height=8.5, paper="special")
          }
          if(TRUE)
          {
            plot.election.results(df_election_fractions = df_election_fractions,
                                  state_name = state_name,
                                  race = race,
                                  str_elec_year = str_elec_year,
                                  str_elec_month = str_elec_month,
                                  str_elec_type = str_elec_type,
                                  json_url = json_url,
                                  my_github_base = my_github_base,
                                  lst_lst_str_plot_intervals = lst_lst_str_plot_intervals)
          }
          if(bool.save.to.pdf)
          {
            dev.off()
            dev.flush()
          }
        } # END if(!is.null(df_election_fractions))
      } # END for(int_curr_vid in arr_vids)
    } # END for(county_name in c("all"))
  }

  # 3. Each county (159)                 # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid
  if(TRUE)
  {
    #head(df_GA20210105_precinct_vote_type_count_ts.by_sid_vid)
    arr_cids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid$cid)
    arr_cids <- arr_cids[order(arr_cids)]
    arr_cids <- c(arr_cids, -1)
    arr_cids_others <- c()
    for(int_curr_cid in arr_cids)
    {
      for(vote_type in c("all"))
      {
        if(int_curr_cid != -1)
        {
          df_election_fractions <- prepare.fraction.data(
            df_election_counts = df_GA20210105_precinct_vote_type_count_ts.by_sid_cid[
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid$cid == int_curr_cid,],
            df_state = df_state20210105)
        } else if(length(arr_cids_others) > 0)
        {
          df_election_fractions <- prepare.fraction.data(
            df_election_counts = df_GA20210105_precinct_vote_type_count_ts.by_sid_cid[
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid$cid %in% arr_cids_others,],
            df_state = df_state20210105)
        } else
        {
          next
        }
        if(!is.null(df_election_fractions))
        {
          state_name <- df_election_fractions$state_abbr[1]
          if(int_curr_cid != -1)
          {
            county_name <- df_GA20210105_county$county_name[df_GA20210105_county$cid == int_curr_cid &
                                                              df_GA20210105_county$sid == df_election_fractions$sid[1]]
          } else
          {
            county_name <- "OTHERS"
          }
          if(min(df_election_fractions$tally) == max(df_election_fractions$tally))
          {
            print(paste0("Skipping county ", county_name, " because of constant tally.")) # skipped 12 counties because of constant tally.
            arr_cids_others <- c(arr_cids_others, int_curr_cid)
            # c("BANKS","CHATTAHOOCHEE","EVANS","FLOYD","LINCOLN","MONTGOMERY,"QUITMAN,"STEWART","TALIAFERRO","TREUTLEN,"WEBSTER","WHEELER")
            next
          }
          if(int_curr_cid != -1)
          {
            str_elec_type <- paste0("Runoff Election (in ", county_name, ") 2021")
          } else
          {
            str_elec_type <- paste0("Runoff Election (in ", length(arr_cids_others), " ", county_name, ") 2021")
          }
          output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                                     "ussen_", "st_", state_name, "_", "ct_", county_name, "_", "vt_", substr(vote_type,1,5))
          if(bool.save.to.csv)
          {
            csv_output_path <- paste0(base_dir,"/output/csv")
            csv_output_file_name <- paste0(output_file_name, ".csv")
            write.csv(x = df_election_fractions, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
          }
          if(bool.save.to.pdf)
          {
            pdf_output_path <- paste0(base_dir,"/output/pdf")
            pdf_output_file_name <- paste0(output_file_name, ".pdf")
            pdf(file=paste0(pdf_output_path,"/",pdf_output_file_name), width=11, height=8.5, paper="special")
          }
          plot.election.results(df_election_fractions = df_election_fractions,
                                state_name = state_name,
                                race = race,
                                str_elec_year = str_elec_year,
                                str_elec_month = str_elec_month,
                                str_elec_type = str_elec_type,
                                json_url = json_url,
                                my_github_base = my_github_base,
                                lst_lst_str_plot_intervals = lst_lst_str_plot_intervals)
          if(bool.save.to.pdf)
          {
            dev.off()
            dev.flush()
          }
        } # END if(!is.null(df_election_fractions))
      } # END for(vote_type in c("all"))
    } # END for(int_curr_cid in arr_cids)
  }

  # 4. Each county, each vote type (636) # df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid
  if(TRUE)
  {
    arr_vids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$vid)
    arr_vids <- arr_vids[order(arr_vids)]
    arr_cids <- unique(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$cid)
    arr_cids <- arr_cids[order(arr_cids)]
    #
    arr_cids <- c(arr_cids, -1)
    #
    list_cids_per_vid <- list(
      arr_cids_vid_1_others <- c(),
      arr_cids_vid_2_others <- c(),
      arr_cids_vid_3_others <- c(),
      arr_cids_vid_4_others <- c()
    )
    for(int_curr_cid in arr_cids)
    {
      for(int_curr_vid in arr_vids)
      {
        if(int_curr_cid != -1)
        {
          df_election_counts_par_val <- df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid[
            df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$cid == int_curr_cid &
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$vid == int_curr_vid,]
          if(max(df_election_counts_par_val$tally) == 0)
          {
            next
          }
          df_election_fractions <- prepare.fraction.data(
            df_election_counts = df_election_counts_par_val,
            df_state = df_state20210105)
        } else if(length(list_cids_per_vid[[int_curr_vid]]) > 0)
        {
          df_election_fractions <- prepare.fraction.data(
            df_election_counts = df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid[
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$vid == int_curr_vid &
              df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid$cid %in% list_cids_per_vid[[int_curr_vid]],],
            df_state = df_state20210105)
        } else
        {
          next
        }
        if(!is.null(df_election_fractions))
        {
          state_name <- df_election_fractions$state_abbr[1]
          if(int_curr_cid != -1)
          {
            county_name <- df_GA20210105_county$county_name[df_GA20210105_county$cid == int_curr_cid &
                                                              df_GA20210105_county$sid == df_election_fractions$sid[1]]
          } else
          {
            county_name <- "OTHERS"
          }
          vote_type <- df_GA20210105_vote_type$vote_type[df_GA20210105_vote_type$vid == int_curr_vid &
                                                         df_GA20210105_vote_type$sid == df_election_fractions$sid[1]]
          if(min(df_election_fractions$tally[df_election_fractions$tally > 0]) == max(df_election_fractions$tally[df_election_fractions$tally > 0]))
          {
            print(paste0("Skipping county ", county_name, ", vote type ", vote_type,
                         " because of constant tally."))
            # c("BANKS","CHATTAHOOCHEE","EVANS","FLOYD","LINCOLN","MONTGOMERY,"QUITMAN,"STEWART","TALIAFERRO","TREUTLEN,"WEBSTER","WHEELER")
            list_cids_per_vid[[int_curr_vid]] <- c(list_cids_per_vid[[int_curr_vid]], int_curr_cid)
            next
          }
          if(int_curr_cid != -1)
          {
            str_elec_type <- paste0("Runoff Election (in ", county_name, ", ", vote_type, ") 2021")
          } else
          {
            str_elec_type <- paste0("Runoff Election (in ", length(list_cids_per_vid[[int_curr_vid]]), " ", county_name, ", ", vote_type, ") 2021")
          }
          output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                                     "ussen_", "st_", state_name, "_", "ct_", county_name, "_", "vt_", substr(vote_type,1,5))
          if(bool.save.to.csv)
          {
            csv_output_path <- paste0(base_dir,"/output/csv")
            csv_output_file_name <- paste0(output_file_name, ".csv")
            write.csv(x = df_election_fractions, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
          }
          if(bool.save.to.pdf)
          {
            pdf_output_path <- paste0(base_dir,"/output/pdf")
            pdf_output_file_name <- paste0(output_file_name, ".pdf")
            pdf(file=paste0(pdf_output_path,"/",pdf_output_file_name), width=11, height=8.5, paper="special")
          }
          plot.election.results(df_election_fractions = df_election_fractions,
                                state_name = state_name,
                                race = race,
                                str_elec_year = str_elec_year,
                                str_elec_month = str_elec_month,
                                str_elec_type = str_elec_type,
                                json_url = json_url,
                                my_github_base = my_github_base,
                                lst_lst_str_plot_intervals = lst_lst_str_plot_intervals)
          if(bool.save.to.pdf)
          {
            dev.off()
            dev.flush()
          }
        } # END if(!is.null(df_election_fractions))
      } # END for(int_curr_vid in arr_vids)
    } # END for(int_curr_cid in arr_cids)
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
}

if(FALSE)
{
  output_file_name <- "210105_ussen_st_GA_ct_all_vt_all"
  csv_output_path <- paste0(base_dir,"/output/csv")
  csv_output_file_name <- paste0(output_file_name, ".csv")
  df_election_fractions <- read.csv(file = paste0(csv_output_path,"/",csv_output_file_name),
                                    quote = "\"", row.names = NULL, stringsAsFactors = FALSE, check.names = FALSE,
                                    strip.white = TRUE, sep = ',', header = TRUE)
  df_election_fractions$phyper_final_loefflerk <- NA
  df_election_fractions$phyper_current_loefflerk <- NA
  n_timeslices <- nrow(df_election_fractions)
  for(int_timeslice_index in 2:n_timeslices)
  {
    df_election_fractions$phyper_final_loefflerk[int_timeslice_index] <-
      stats::phyper(q = df_election_fractions$votes_loefflerk[n_timeslices] - df_election_fractions$votes_loefflerk[int_timeslice_index - 1],
                    m = df_election_fractions$votes_loefflerk[n_timeslices],
                    n = df_election_fractions$votes_warnockr[n_timeslices],
                    k = df_election_fractions$tally[n_timeslices] - df_election_fractions$tally[int_timeslice_index - 1],
                    lower.tail = TRUE)
    if(df_election_fractions$tally[int_timeslice_index - 1] >=
       df_election_fractions$tally[n_timeslices] - df_election_fractions$tally[int_timeslice_index - 1])
    {
      df_election_fractions$phyper_current_loefflerk[int_timeslice_index] <-
        stats::phyper(q = df_election_fractions$votes_loefflerk[n_timeslices] - df_election_fractions$votes_loefflerk[int_timeslice_index - 1],
                      m = df_election_fractions$votes_loefflerk[int_timeslice_index - 1],
                      n = df_election_fractions$votes_warnockr[int_timeslice_index - 1],
                      k = df_election_fractions$tally[n_timeslices] - df_election_fractions$tally[int_timeslice_index - 1],
                      lower.tail = TRUE)
    }
  }
}

if(bool.analyze.county.tail)
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
  
  df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid <-
    df_GA20210105_precinct_vote_type_count_ts %>%
    group_by(time_offset_ms, sid, cid, vid) %>%
    summarise(tally=sum(tally),
              votes_warnockr=sum(votes_warnockr),
              votes_loefflerk=sum(votes_loefflerk))

  df_election_ts_by_county_vote_type <- merge(x = df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid,
                                 y = df_state20210105[,c(
                                   "sid", "time_origin_ms")], by = "sid")
  df_election_ts_by_county_vote_type$sec_offset <- (df_election_ts_by_county_vote_type$time_origin_ms + df_election_ts_by_county_vote_type$time_offset_ms)/1000.0
  colnames(df_election_ts_by_county_vote_type)[colnames(df_election_ts_by_county_vote_type)=="votes_warnockr"] <- "votes_democrat"
  colnames(df_election_ts_by_county_vote_type)[colnames(df_election_ts_by_county_vote_type)=="votes_loefflerk"] <- "votes_republican"
  df_election_ts_by_county_vote_type <- merge(x = df_election_ts_by_county_vote_type, y = df_GA20210105_county_vote_type,
                                              by = c("sid", "cid", "vid"))
  df_election_ts_by_county_vote_type <- df_election_ts_by_county_vote_type[,c("vote_type", "county_name", "county_fips", "sec_offset",
                                                                              "tally", "votes_democrat", "votes_republican")]
  
  df_election_ts_by_county_vote_type_all <-
    df_election_ts_by_county_vote_type %>%
    group_by(county_name,county_fips,sec_offset) %>%
    summarise(tally=sum(tally),
              votes_democrat=sum(votes_democrat),
              votes_republican=sum(votes_republican))
  df_election_ts_by_county_vote_type_all$vote_type <- "all"
  nc <- ncol(df_election_ts_by_county_vote_type_all)
  df_election_ts_by_county_vote_type_all <- df_election_ts_by_county_vote_type_all[,c(nc,1:(nc-1))]
  df_election_ts_by_county_vote_type <- rbind(df_election_ts_by_county_vote_type,df_election_ts_by_county_vote_type_all)

  df_election_ts_by_county_vote_type <- df_election_ts_by_county_vote_type[
    order(df_election_ts_by_county_vote_type$vote_type,
          df_election_ts_by_county_vote_type$county_name,
          df_election_ts_by_county_vote_type$sec_offset),]
  rownames(df_election_ts_by_county_vote_type) <- NULL

  nrow(df_GA20210105_precinct_vote_type_count_ts) # 1,349,196
  nrow(df_GA20210105_precinct_vote_type_count_ts.by_sid_cid_vid) # 80,768 = 4 * 127 * 158.99212598425197
  nrow(df_election_ts_by_county_vote_type) # 80,768 = 4 * 127 * 158.99212598425197
  length(unique(df_GA20210105_precinct_vote_type_count_ts$time_offset_ms)) # 127
  length(unique(df_GA20210105_county$sid)) # 1
  length(unique(df_GA20210105_vote_type$vid)) # 4
  length(unique(df_GA20210105_county$cid)) # 159
  
  # Subsequently, during the 10-minute period between "2021-01-05; 23:13:33" and "2021-01-05 23:22:09"
  # Subsequent 54 batches (from "2021-01-05; 23:25:11" to "2021-01-09 12:52:06")
  # All 55 last batches (from "2021-01-05 23:22:09" to "2021-01-09 12:52:06")
  lst_lst_str_tail_intervals <-
    list(tail_last_54 = list(min_time_excl = "2021-01-05T23:22:09Z", max_time_incl = "2021-01-09T12:52:06Z"), # from "2021-01-05T23:25:11Z"
         tail_last_55 = list(min_time_excl = "2021-01-05T23:13:33Z", max_time_incl = "2021-01-09T12:52:06Z"), # from "2021-01-05T23:22:09Z"
         tail_55th = list(min_time_excl = "2021-01-05T23:13:33Z", max_time_incl = "2021-01-05T23:22:09Z")) # from "2021-01-05T23:22:09Z"
  
  df_head_tail_diff <- data.frame(
    interval_name          = character(),
    int_tail_min_time_excl = numeric(),
    int_tail_max_time_incl = numeric(),
    str_tail_min_time_excl = character(),
    str_tail_max_time_incl = character(),
    vote_type              = character(),
    county_name            = character(),
    tally_inc              = numeric(),
    votes_inc_democrat     = numeric(),
    votes_inc_republican   = numeric(),
    stringsAsFactors       = FALSE)
  
  state_abbr <- "GA"
  #state_name <- df_state20210105$state_name[df_state20210105$state_abbr == state_abbr]
  df_vote_types <- merge(x = df_GA20210105_vote_type, y = df_state20210105, by = "sid")
  arr_vote_types <- c("all",df_vote_types$vote_type[df_vote_types$state_abbr == state_abbr #&
                                              #df_vote_types$vote_type %in% c("early", "electionday")
                                              ])
  df_counties <- merge(x = df_GA20210105_county, y = df_state20210105, by = "sid")
  arr_counties <- df_counties$county_name[df_counties$state_abbr == state_abbr]

  for(int_tail_index in 1:length(lst_lst_str_tail_intervals))
  {
    str_min_time_excl <- lst_lst_str_tail_intervals[[int_tail_index]]$min_time_excl
    str_max_time_incl <- lst_lst_str_tail_intervals[[int_tail_index]]$max_time_incl
    int_min_time_excl <- as.numeric(strptime(str_min_time_excl, "%Y-%m-%dT%H:%M:%OSZ"))
    int_max_time_incl <- as.numeric(strptime(str_max_time_incl, "%Y-%m-%dT%H:%M:%OSZ"))
    for(str_vote_type in arr_vote_types) # "early", "electionday"
    {
      for(str_county in arr_counties) # 159
      {
        df_curr_ts_c_vt_full <- df_election_ts_by_county_vote_type[df_election_ts_by_county_vote_type$vote_type == str_vote_type &
                                                                df_election_ts_by_county_vote_type$county_name == str_county,
                                                              c("sec_offset", "tally", "votes_democrat", "votes_republican")]
        df_curr_ts_c_vt_full <- df_curr_ts_c_vt_full[order(df_curr_ts_c_vt_full$sec_offset),]
        n <- nrow(df_curr_ts_c_vt_full)
        df_curr_ts_c_vt_full$tally_inc <- c(df_curr_ts_c_vt_full$tally[1],
                                            df_curr_ts_c_vt_full$tally[2:n] - df_curr_ts_c_vt_full$tally[1:(n-1)])
        df_curr_ts_c_vt_full$votes_inc_democrat <- c(df_curr_ts_c_vt_full$votes_democrat[1],
                                                     df_curr_ts_c_vt_full$votes_democrat[2:n] - df_curr_ts_c_vt_full$votes_democrat[1:(n-1)])
        df_curr_ts_c_vt_full$votes_inc_republican <- c(df_curr_ts_c_vt_full$votes_republican[1],
                                                       df_curr_ts_c_vt_full$votes_republican[2:n] - df_curr_ts_c_vt_full$votes_republican[1:(n-1)])
        
        df_curr_ts_c_vt_head <- df_curr_ts_c_vt_full[df_curr_ts_c_vt_full$sec_offset <= int_min_time_excl #|
                                                  #int_max_time_incl < df_curr_ts_c_vt_full$sec_offset
                                                  ,]
        df_curr_ts_c_vt_tail <- df_curr_ts_c_vt_full[int_min_time_excl < df_curr_ts_c_vt_full$sec_offset &
                                                       df_curr_ts_c_vt_full$sec_offset <= int_max_time_incl,]

        df_head_tail_diff <- rbind(
          df_head_tail_diff,
          data.frame(
            interval_name          = "full",
            int_tail_min_time_excl = int_min_time_excl,
            int_tail_max_time_incl = int_max_time_incl,
            str_tail_min_time_excl = str_min_time_excl,
            str_tail_max_time_incl = str_max_time_incl,
            vote_type              = str_vote_type,
            county_name            = str_county,
            tally_inc              = sum(df_curr_ts_c_vt_full$tally_inc),
            votes_inc_democrat     = sum(df_curr_ts_c_vt_full$votes_inc_democrat),
            votes_inc_republican   = sum(df_curr_ts_c_vt_full$votes_inc_republican)
          ))
        df_head_tail_diff <- rbind(
          df_head_tail_diff,
          data.frame(
            interval_name          = "head",
            int_tail_min_time_excl = int_min_time_excl,
            int_tail_max_time_incl = int_max_time_incl,
            str_tail_min_time_excl = str_min_time_excl,
            str_tail_max_time_incl = str_max_time_incl,
            vote_type              = str_vote_type,
            county_name            = str_county,
            tally_inc              = sum(df_curr_ts_c_vt_head$tally_inc),
            votes_inc_democrat     = sum(df_curr_ts_c_vt_head$votes_inc_democrat),
            votes_inc_republican   = sum(df_curr_ts_c_vt_head$votes_inc_republican)
          ))
        df_head_tail_diff <- rbind(
          df_head_tail_diff,
          data.frame(
            interval_name          = "tail",
            int_tail_min_time_excl = int_min_time_excl,
            int_tail_max_time_incl = int_max_time_incl,
            str_tail_min_time_excl = str_min_time_excl,
            str_tail_max_time_incl = str_max_time_incl,
            vote_type              = str_vote_type,
            county_name            = str_county,
            tally_inc              = sum(df_curr_ts_c_vt_tail$tally_inc),
            votes_inc_democrat     = sum(df_curr_ts_c_vt_tail$votes_inc_democrat),
            votes_inc_republican   = sum(df_curr_ts_c_vt_tail$votes_inc_republican)
          ))
      } # END for(str_county in arr_counties)
    } # END for(str_vote_type in arr_vote_types)
  } # END for(int_tail_index in 1:length(lst_lst_str_tail_intervals))

  df_tail_summary <- df_head_tail_diff[, c(
    "interval_name", "int_tail_min_time_excl","int_tail_max_time_incl", "str_tail_min_time_excl", "str_tail_max_time_incl",
    "vote_type", "county_name")]
  df_tail_summary$tally_cv_interv <- NA
  df_tail_summary$votes_dem_cv_interv <- NA
  df_tail_summary$votes_rep_cv_interv <- NA
  #
  df_tail_summary$tally_cv_interv_cv_full <- NA
  df_tail_summary$tally_cv_interv_all_interv <- NA
  #
  df_tail_summary$votes_dem_cv_interv_cv_full <- NA
  df_tail_summary$votes_rep_cv_interv_cv_full <- NA
  df_tail_summary$votes_dem_cv_interv_all_interv <- NA
  df_tail_summary$votes_rep_cv_interv_all_interv <- NA
  #
  df_tail_summary$votes_dem_cv_interv_tally_cv_interv <- NA
  df_tail_summary$votes_rep_cv_interv_tally_cv_interv <- NA
  #
  for(int_row_index in 1:nrow(df_tail_summary))
  {
    interval_name <- df_tail_summary$interval_name[int_row_index]
    int_tail_min_time_excl <- df_tail_summary$int_tail_min_time_excl[int_row_index]
    int_tail_max_time_incl <- df_tail_summary$int_tail_max_time_incl[int_row_index]
    vote_type <- df_tail_summary$vote_type[int_row_index]
    county_name <- df_tail_summary$county_name[int_row_index]
    #
    # Counts
    df_tail_summary$tally_cv_interv[int_row_index] <-
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name]
    df_tail_summary$votes_dem_cv_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name]
    df_tail_summary$votes_rep_cv_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name]
    # a. Tally in the Tail;
    #    1. % in the Tail relative to (Head + Tail) for this county
    df_tail_summary$tally_cv_interv_cv_full[int_row_index] <-
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name] /
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == "full" &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name]
    #     2. % in the Tail for this county relative to total Tail tally for all counties
    df_tail_summary$tally_cv_interv_all_interv[int_row_index] <-
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name] /
      sum(df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                        df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                        df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                        df_head_tail_diff$vote_type == vote_type])
    #         b. Vote counts in the Tail;
    #           1. % in the Tail relative vs (Head + Tail) for this county
    df_tail_summary$votes_dem_cv_interv_cv_full[int_row_index] <-
      df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name] /
      df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == "full" &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name]
    df_tail_summary$votes_rep_cv_interv_cv_full[int_row_index] <-
      df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name] /
      df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == "full" &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name]
    #   2. % in the Tail for this county for this election choice relative to total Tail votes for all counties for this election choice
    df_tail_summary$votes_dem_cv_interv_all_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name] /
      sum(df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == interval_name &
                                        df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                        df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                        df_head_tail_diff$vote_type == vote_type])
    df_tail_summary$votes_rep_cv_interv_all_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name] /
      sum(df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == interval_name &
                                                 df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                                 df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                                 df_head_tail_diff$vote_type == vote_type])
    #  c. Vote % in the Tail
    #    1. % of Dem/Rep count in the Tail relative to Tally in the Tail
    df_tail_summary$votes_dem_cv_interv_tally_cv_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_democrat[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name] /
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name]
    df_tail_summary$votes_rep_cv_interv_tally_cv_interv[int_row_index] <-
      df_head_tail_diff$votes_inc_republican[df_head_tail_diff$interval_name == interval_name &
                                             df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                             df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                             df_head_tail_diff$vote_type == vote_type &
                                             df_head_tail_diff$county_name == county_name] /
      df_head_tail_diff$tally_inc[df_head_tail_diff$interval_name == interval_name &
                                    df_head_tail_diff$int_tail_min_time_excl == int_tail_min_time_excl &
                                    df_head_tail_diff$int_tail_max_time_incl == int_tail_max_time_incl &
                                    df_head_tail_diff$vote_type == vote_type &
                                    df_head_tail_diff$county_name == county_name]
  }
  df_tail_summary$tally_cv_interv_cv_full[is.na(df_tail_summary$tally_cv_interv_cv_full)] <- 0
  df_tail_summary$tally_cv_interv_all_interv[is.na(df_tail_summary$tally_cv_interv_all_interv)] <- 0
  df_tail_summary$votes_dem_cv_interv_cv_full[is.na(df_tail_summary$votes_dem_cv_interv_cv_full)] <- 0
  df_tail_summary$votes_rep_cv_interv_cv_full[is.na(df_tail_summary$votes_rep_cv_interv_cv_full)] <- 0
  df_tail_summary$votes_dem_cv_interv_all_interv[is.na(df_tail_summary$votes_dem_cv_interv_all_interv)] <- 0
  df_tail_summary$votes_rep_cv_interv_all_interv[is.na(df_tail_summary$votes_rep_cv_interv_all_interv)] <- 0
  df_tail_summary$votes_dem_cv_interv_tally_cv_interv[is.na(df_tail_summary$votes_dem_cv_interv_tally_cv_interv)] <- 0
  df_tail_summary$votes_rep_cv_interv_tally_cv_interv[is.na(df_tail_summary$votes_rep_cv_interv_tally_cv_interv)] <- 0
  
  df_tail_summary <- df_tail_summary[order(
    df_tail_summary$interval_name,
    df_tail_summary$int_tail_min_time_excl,
    df_tail_summary$int_tail_max_time_incl,
    df_tail_summary$vote_type,
    -df_tail_summary$tally_cv_interv_all_interv,
    df_tail_summary$county_name
  ),]
  
  output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                             "ussen_", "st_", state_abbr, "_summary")
  csv_output_path <- paste0(base_dir,"/output/csv")
  csv_output_file_name <- paste0(output_file_name, ".csv")
  write.csv(x = df_tail_summary, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
  
  # for each vote type in (Early Voting, Election Day): "Suspect Vote Type"
  #   for each county
  #     Create Head and Tail
  #     If a county adds votes in the tail, then call it "Tail County"
  #       For {"Suspect Vote Type", "Tail County"}, compute:
  #         a. Tally in the Tail;
  #           1. % in the Tail relative to (Head + Tail) for this county
  #           2. % in the Tail for this county relative to total Tail tally for all counties
  #         b. Vote counts in the Tail;
  #           1. % in the Tail relative vs (Head + Tail) for this county
  #           2. % in the Tail for this county for this election choice relative to total Tail votes for all counties for this election choice
  #         c. Vote % in the Tail
  #           1. % of Dem/Rep count in the Tail relative to Tally in the Tail
  # Drop insignificant counties from the Tail:
  # 1. Small Tally fraction within the Tail
  # 2. Consistent % vote choices between Head and Tail.
}

if(bool.analyze.precinct.tail)
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

  lst_str_tail_interval_last_54_batches = list(min_time_excl = "2021-01-05T23:22:09Z", max_time_incl = "2021-01-09T12:52:06Z")
  #
  str_min_time_excl <- lst_str_tail_interval_last_54_batches$min_time_excl
  str_max_time_incl <- lst_str_tail_interval_last_54_batches$max_time_incl
  int_min_time_excl <- as.numeric(strptime(str_min_time_excl, "%Y-%m-%dT%H:%M:%OSZ"))
  int_max_time_incl <- as.numeric(strptime(str_max_time_incl, "%Y-%m-%dT%H:%M:%OSZ"))
  #
  str_state_abbr <- "GA"
  str_county_name <- "DEKALB"
  str_vote_type <- "early"
  time_origin_ms <- df_state20210105$time_origin_ms[df_state20210105$state_abbr == str_state_abbr]
  sid <- df_state20210105$sid[df_state20210105$state_abbr == str_state_abbr]
  cid <- df_GA20210105_county$cid[df_GA20210105_county$sid == sid & df_GA20210105_county$county_name == str_county_name]
  vid <- df_GA20210105_vote_type$vid[df_GA20210105_vote_type$sid == sid & df_GA20210105_vote_type$vote_type == str_vote_type]
  
  df_GA20210105_precinct_vote_type_count_ts.selected.precincts <-
    df_GA20210105_precinct_vote_type_count_ts[df_GA20210105_precinct_vote_type_count_ts$sid == sid &
                                                df_GA20210105_precinct_vote_type_count_ts$cid == cid &
                                                df_GA20210105_precinct_vote_type_count_ts$vid == vid &
                                                time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms > int_min_time_excl * 1000 &
                                                time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms <= int_max_time_incl * 1000,
                                              c("time_offset_ms", "sid", "cid", "pid", "tally", "votes_warnockr", "votes_loefflerk")]
  df_election_ts_by_precinct <- merge(
    x = df_GA20210105_precinct_vote_type_count_ts.selected.precincts,
    y = df_GA20210105_precinct[,c(
      "sid", "cid", "pid", "precinct_id", "precinct_geo_id")],
    by = c("sid", "cid", "pid"))
  df_election_ts_by_precinct$sec_offset <- (time_origin_ms + df_election_ts_by_precinct$time_offset_ms) / 1000
  options(digits.secs=0)
  df_election_ts_by_precinct$date_time <- format(as.POSIXct(df_election_ts_by_precinct$sec_offset, origin = "1970-01-01"), "%Y-%m-%dT%H:%M:%OSZ")
  df_election_ts_by_precinct <- df_election_ts_by_precinct[,c("pid", "precinct_id", "precinct_geo_id",
                                                              "sec_offset", "date_time",
                                                              "tally", "votes_warnockr","votes_loefflerk")]
  df_election_ts_by_precinct <- df_election_ts_by_precinct[order(df_election_ts_by_precinct$precinct_geo_id,
                                                                 df_election_ts_by_precinct$sec_offset),]
  nrow(df_election_ts_by_precinct) # 10,314
  df_precinct_selected <- unique(df_election_ts_by_precinct[,c("pid", "precinct_id","precinct_geo_id")])
  nrow(df_precinct_selected) # 191 precincts
  #
  n <- length(df_precinct_selected$pid)
  df_election_ts_for_precincts <- NULL
  df_election_ts_for_precincts_head <- NULL
  df_election_ts_for_precincts_tail <- NULL
  for(pid_ind in 1:n)
  {
    pid <- df_precinct_selected$pid[pid_ind]
    df_GA20210105_precinct_vote_type_count_ts.selected.precinct <-
      df_GA20210105_precinct_vote_type_count_ts[df_GA20210105_precinct_vote_type_count_ts$sid == sid &
                                                  df_GA20210105_precinct_vote_type_count_ts$cid == cid &
                                                  df_GA20210105_precinct_vote_type_count_ts$vid == vid &
                                                  df_GA20210105_precinct_vote_type_count_ts$pid == pid,
                                                #time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms > int_min_time_excl * 1000 &
                                                #time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms <= int_max_time_incl * 1000,
                                                c("time_offset_ms", "sid", "cid", "pid", "tally", "votes_warnockr", "votes_loefflerk")]
    df_election_ts_for_precinct <- merge(
      x = df_GA20210105_precinct_vote_type_count_ts.selected.precinct,
      y = df_GA20210105_precinct[,c(
        "sid", "cid", "pid", "precinct_id", "precinct_geo_id")],
      by = c("sid", "cid", "pid"))
    df_election_ts_for_precinct$sec_offset <- (time_origin_ms + df_election_ts_for_precinct$time_offset_ms) / 1000
    options(digits.secs=0)
    df_election_ts_for_precinct$date_time <- format(as.POSIXct(df_election_ts_for_precinct$sec_offset, origin = "1970-01-01"), "%Y-%m-%dT%H:%M:%OSZ")
    df_election_ts_for_precinct <- df_election_ts_for_precinct[,c("pid", "precinct_id", "precinct_geo_id",
                                                                  "sec_offset", "date_time",
                                                                  "tally", "votes_warnockr","votes_loefflerk")]
    df_election_ts_for_precinct <- df_election_ts_for_precinct[order(df_election_ts_for_precinct$precinct_geo_id,
                                                                     df_election_ts_for_precinct$sec_offset),]
    colnames(df_election_ts_for_precinct)[colnames(df_election_ts_for_precinct)=="votes_warnockr"] <- "votes_democrat"
    colnames(df_election_ts_for_precinct)[colnames(df_election_ts_for_precinct)=="votes_loefflerk"] <- "votes_republican"
    n <- nrow(df_election_ts_for_precinct)
    
    df_election_ts_for_precinct$tally_inc <- c(df_election_ts_for_precinct$tally[1],
                                               df_election_ts_for_precinct$tally[2:n] - df_election_ts_for_precinct$tally[1:(n-1)])
    df_election_ts_for_precinct$votes_inc_democrat <- c(df_election_ts_for_precinct$votes_democrat[1],
                                                        df_election_ts_for_precinct$votes_democrat[2:n] - df_election_ts_for_precinct$votes_democrat[1:(n-1)])
    df_election_ts_for_precinct$votes_inc_republican <- c(df_election_ts_for_precinct$votes_republican[1],
                                                          df_election_ts_for_precinct$votes_republican[2:n] - df_election_ts_for_precinct$votes_republican[1:(n-1)])
    df_election_ts_for_precinct$tally <- NULL
    df_election_ts_for_precinct$votes_democrat <- NULL
    df_election_ts_for_precinct$votes_republican <- NULL
    
    df_election_ts_for_precinct_head <- df_election_ts_for_precinct[df_election_ts_for_precinct$sec_offset <= int_min_time_excl #|
                                                                    #int_max_time_incl < df_election_ts_for_precinct$sec_offset
                                                                    ,]
    df_election_ts_for_precinct_tail <- df_election_ts_for_precinct[int_min_time_excl < df_election_ts_for_precinct$sec_offset &
                                                                      df_election_ts_for_precinct$sec_offset <= int_max_time_incl,]
    if(is.null(df_election_ts_for_precincts))
    {
      df_election_ts_for_precincts <- df_election_ts_for_precinct
    } else
    {
      df_election_ts_for_precincts <- rbind(df_election_ts_for_precincts, df_election_ts_for_precinct)
    }
    if(is.null(df_election_ts_for_precincts_head))
    {
      df_election_ts_for_precincts_head <- df_election_ts_for_precinct_head
    } else
    {
      df_election_ts_for_precincts_head <- rbind(df_election_ts_for_precincts_head, df_election_ts_for_precinct_head)
    }
    if(is.null(df_election_ts_for_precincts_tail))
    {
      df_election_ts_for_precincts_tail <- df_election_ts_for_precinct_tail
    } else
    {
      df_election_ts_for_precincts_tail <- rbind(df_election_ts_for_precincts_tail, df_election_ts_for_precinct_tail)
    }
  }
  #
  n <- length(df_precinct_selected$pid)
  df_head_tail_diff <- data.frame(
    interval_name                 = character(n * 3), # full, head, tail
    int_min_time_excl             = numeric(n * 3),
    int_min_time_incl             = numeric(n * 3),
    int_max_time_incl             = numeric(n * 3),
    str_min_time_excl             = character(n * 3),
    str_min_time_incl             = character(n * 3),
    str_max_time_incl             = character(n * 3),
    vote_type                     = character(n * 3),
    county_name                   = character(n * 3),
    pid                           = numeric(n * 3),
    precinct_id                   = character(n * 3),
    precinct_geo_id               = character(n * 3),
    tally_inc                     = numeric(n * 3),
    votes_inc_democrat            = numeric(n * 3),
    votes_inc_republican          = numeric(n * 3),
    tally_interv_full             = numeric(n * 3),
    tally_interv_all_interv       = numeric(n * 3),
    votes_dem_interv_full         = numeric(n * 3),
    votes_rep_interv_full         = numeric(n * 3),
    votes_dem_interv_all_interv   = numeric(n * 3),
    votes_rep_interv_all_interv   = numeric(n * 3),
    votes_dem_interv_tally_interv = numeric(n * 3),
    votes_rep_interv_tally_interv = numeric(n * 3),
    hypergeom_cdf_dem_le_votes    = numeric(n * 3),
    hypergeom_cdf_rep_le_votes    = numeric(n * 3),
    hypergeom_cdf_score           = numeric(n * 3),
    stringsAsFactors       = FALSE)
  for(pid_ind in 1:n)
  {
    pid <- df_precinct_selected$pid[pid_ind]
    df_GA20210105_precinct_vote_type_count_ts.selected.precinct <-
      df_GA20210105_precinct_vote_type_count_ts[df_GA20210105_precinct_vote_type_count_ts$sid == sid &
                                                  df_GA20210105_precinct_vote_type_count_ts$cid == cid &
                                                  df_GA20210105_precinct_vote_type_count_ts$vid == vid &
                                                  df_GA20210105_precinct_vote_type_count_ts$pid == pid,
                                                  #time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms > int_min_time_excl * 1000 &
                                                  #time_origin_ms + df_GA20210105_precinct_vote_type_count_ts$time_offset_ms <= int_max_time_incl * 1000,
                                                c("time_offset_ms", "sid", "cid", "pid", "tally", "votes_warnockr", "votes_loefflerk")]
    df_election_ts_for_precinct <- merge(
      x = df_GA20210105_precinct_vote_type_count_ts.selected.precinct,
      y = df_GA20210105_precinct[,c(
        "sid", "cid", "pid", "precinct_id", "precinct_geo_id")],
      by = c("sid", "cid", "pid"))
    df_election_ts_for_precinct$sec_offset <- (time_origin_ms + df_election_ts_for_precinct$time_offset_ms) / 1000
    options(digits.secs=0)
    df_election_ts_for_precinct$date_time <- format(as.POSIXct(df_election_ts_for_precinct$sec_offset, origin = "1970-01-01"), "%Y-%m-%dT%H:%M:%OSZ")
    df_election_ts_for_precinct <- df_election_ts_for_precinct[,c("pid", "precinct_id", "precinct_geo_id",
                                                                "sec_offset", "date_time",
                                                                "tally", "votes_warnockr","votes_loefflerk")]
    df_election_ts_for_precinct <- df_election_ts_for_precinct[order(df_election_ts_for_precinct$precinct_geo_id,
                                                                     df_election_ts_for_precinct$sec_offset),]
    colnames(df_election_ts_for_precinct)[colnames(df_election_ts_for_precinct)=="votes_warnockr"] <- "votes_democrat"
    colnames(df_election_ts_for_precinct)[colnames(df_election_ts_for_precinct)=="votes_loefflerk"] <- "votes_republican"
    n <- nrow(df_election_ts_for_precinct)
    
    df_election_ts_for_precinct$tally_inc <- c(df_election_ts_for_precinct$tally[1],
                                               df_election_ts_for_precinct$tally[2:n] - df_election_ts_for_precinct$tally[1:(n-1)])
    df_election_ts_for_precinct$votes_inc_democrat <- c(df_election_ts_for_precinct$votes_democrat[1],
                                                        df_election_ts_for_precinct$votes_democrat[2:n] - df_election_ts_for_precinct$votes_democrat[1:(n-1)])
    df_election_ts_for_precinct$votes_inc_republican <- c(df_election_ts_for_precinct$votes_republican[1],
                                                          df_election_ts_for_precinct$votes_republican[2:n] - df_election_ts_for_precinct$votes_republican[1:(n-1)])
    df_election_ts_for_precinct$tally <- NULL
    df_election_ts_for_precinct$votes_democrat <- NULL
    df_election_ts_for_precinct$votes_republican <- NULL
    
    df_election_ts_for_precinct_head <- df_election_ts_for_precinct[df_election_ts_for_precinct$sec_offset <= int_min_time_excl #|
                                                 #int_max_time_incl < df_election_ts_for_precinct$sec_offset
                                                 ,]
    df_election_ts_for_precinct_tail <- df_election_ts_for_precinct[int_min_time_excl < df_election_ts_for_precinct$sec_offset &
                                                   df_election_ts_for_precinct$sec_offset <= int_max_time_incl,]
    #
    df_head_tail_diff$interval_name[(pid_ind-1)*3+1] <- "full"
    df_head_tail_diff$interval_name[(pid_ind-1)*3+2] <- "head"
    df_head_tail_diff$interval_name[(pid_ind-1)*3+3] <- "tail"
    #
    df_head_tail_diff$int_min_time_excl[(pid_ind-1)*3+1] <- NA # "full"
    df_head_tail_diff$int_min_time_excl[(pid_ind-1)*3+2] <- NA # "head"
    df_head_tail_diff$int_min_time_excl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_head$sec_offset[nrow(df_election_ts_for_precinct_head)] # "tail"
    #
    df_head_tail_diff$int_min_time_incl[(pid_ind-1)*3+1] <- df_election_ts_for_precinct$sec_offset[1] # "full"
    df_head_tail_diff$int_min_time_incl[(pid_ind-1)*3+2] <- df_election_ts_for_precinct_head$sec_offset[1] # "head"
    df_head_tail_diff$int_min_time_incl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_tail$sec_offset[1] # "tail"
    #
    df_head_tail_diff$int_max_time_incl[(pid_ind-1)*3+1] <- df_election_ts_for_precinct$sec_offset[nrow(df_election_ts_for_precinct)] # "full"
    df_head_tail_diff$int_max_time_incl[(pid_ind-1)*3+2] <- df_election_ts_for_precinct_head$sec_offset[nrow(df_election_ts_for_precinct_head)] # "head"
    df_head_tail_diff$int_max_time_incl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_tail$sec_offset[nrow(df_election_ts_for_precinct_tail)] # "tail"
    #
    df_head_tail_diff$str_min_time_excl[(pid_ind-1)*3+1] <- "" # "full"
    df_head_tail_diff$str_min_time_excl[(pid_ind-1)*3+2] <- "" # "head"
    df_head_tail_diff$str_min_time_excl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_head$date_time[nrow(df_election_ts_for_precinct_head)] # "tail"
    #
    df_head_tail_diff$str_min_time_incl[(pid_ind-1)*3+1] <- df_election_ts_for_precinct$date_time[1] # "full"
    df_head_tail_diff$str_min_time_incl[(pid_ind-1)*3+2] <- df_election_ts_for_precinct_head$date_time[1] # "head"
    df_head_tail_diff$str_min_time_incl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_tail$date_time[1] # "tail"
    #
    df_head_tail_diff$str_max_time_incl[(pid_ind-1)*3+1] <- df_election_ts_for_precinct$date_time[nrow(df_election_ts_for_precinct)] # "full"
    df_head_tail_diff$str_max_time_incl[(pid_ind-1)*3+2] <- df_election_ts_for_precinct_head$date_time[nrow(df_election_ts_for_precinct_head)] # "head"
    df_head_tail_diff$str_max_time_incl[(pid_ind-1)*3+3] <- df_election_ts_for_precinct_tail$date_time[nrow(df_election_ts_for_precinct_tail)] # "tail"
    #
    df_head_tail_diff$vote_type[(pid_ind-1)*3+1] <- str_vote_type # "full"
    df_head_tail_diff$vote_type[(pid_ind-1)*3+2] <- str_vote_type # "head"
    df_head_tail_diff$vote_type[(pid_ind-1)*3+3] <- str_vote_type # "tail"
    #
    df_head_tail_diff$county_name[(pid_ind-1)*3+1] <- str_county_name # "full"
    df_head_tail_diff$county_name[(pid_ind-1)*3+2] <- str_county_name # "head"
    df_head_tail_diff$county_name[(pid_ind-1)*3+3] <- str_county_name # "tail"
    #
    df_head_tail_diff$pid[(pid_ind-1)*3+1] <- pid # "full"
    df_head_tail_diff$pid[(pid_ind-1)*3+2] <- pid # "head"
    df_head_tail_diff$pid[(pid_ind-1)*3+3] <- pid # "tail"
    #
    df_head_tail_diff$precinct_id[(pid_ind-1)*3+1] <- df_precinct_selected$precinct_id[pid_ind] # "full"
    df_head_tail_diff$precinct_id[(pid_ind-1)*3+2] <- df_precinct_selected$precinct_id[pid_ind] # "head"
    df_head_tail_diff$precinct_id[(pid_ind-1)*3+3] <- df_precinct_selected$precinct_id[pid_ind] # "tail"
    #
    df_head_tail_diff$precinct_geo_id[(pid_ind-1)*3+1] <- df_precinct_selected$precinct_geo_id[pid_ind] # "full"
    df_head_tail_diff$precinct_geo_id[(pid_ind-1)*3+2] <- df_precinct_selected$precinct_geo_id[pid_ind] # "head"
    df_head_tail_diff$precinct_geo_id[(pid_ind-1)*3+3] <- df_precinct_selected$precinct_geo_id[pid_ind] # "tail"
    #
    df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] <- sum(df_election_ts_for_precinct$tally_inc) # "full"
    df_head_tail_diff$tally_inc[(pid_ind-1)*3+2] <- sum(df_election_ts_for_precinct_head$tally_inc) # "head"
    df_head_tail_diff$tally_inc[(pid_ind-1)*3+3] <- sum(df_election_ts_for_precinct_tail$tally_inc) # "tail"
    #
    df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] <- sum(df_election_ts_for_precinct$votes_inc_democrat) # "full"
    df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] <- sum(df_election_ts_for_precinct_head$votes_inc_democrat) # "head"
    df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] <- sum(df_election_ts_for_precinct_tail$votes_inc_democrat) # "tail"
    #
    df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] <- sum(df_election_ts_for_precinct$votes_inc_republican) # "full"
    df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] <- sum(df_election_ts_for_precinct_head$votes_inc_republican) # "head"
    df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3] <- sum(df_election_ts_for_precinct_tail$votes_inc_republican) # "tail"
    #
    df_head_tail_diff$tally_interv_full[(pid_ind-1)*3+1] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] # "full"
    df_head_tail_diff$tally_interv_full[(pid_ind-1)*3+2] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+2] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] # "head"
    df_head_tail_diff$tally_interv_full[(pid_ind-1)*3+3] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+3] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] # "tail"
    #
    df_head_tail_diff$tally_interv_all_interv[(pid_ind-1)*3+1] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] / sum(df_election_ts_for_precincts$tally_inc) # "full"
    df_head_tail_diff$tally_interv_all_interv[(pid_ind-1)*3+2] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+2] / sum(df_election_ts_for_precincts_head$tally_inc) # "head"
    df_head_tail_diff$tally_interv_all_interv[(pid_ind-1)*3+3] <- df_head_tail_diff$tally_inc[(pid_ind-1)*3+3] / sum(df_election_ts_for_precincts_tail$tally_inc) # "tail"
    #
    df_head_tail_diff$votes_dem_interv_full[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] / df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] # "full"
    df_head_tail_diff$votes_dem_interv_full[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] / df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] # "head"
    df_head_tail_diff$votes_dem_interv_full[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] / df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] # "tail"
    # 
    df_head_tail_diff$votes_rep_interv_full[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] / df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] # "full"
    df_head_tail_diff$votes_rep_interv_full[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] / df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] # "head"
    df_head_tail_diff$votes_rep_interv_full[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3] / df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] # "tail"
    #
    df_head_tail_diff$votes_dem_interv_all_interv[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] / sum(df_election_ts_for_precincts$votes_inc_democrat) # "full"
    df_head_tail_diff$votes_dem_interv_all_interv[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] / sum(df_election_ts_for_precincts_head$votes_inc_democrat) # "head"
    df_head_tail_diff$votes_dem_interv_all_interv[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] / sum(df_election_ts_for_precincts_tail$votes_inc_democrat) # "tail"
    #
    df_head_tail_diff$votes_rep_interv_all_interv[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] / sum(df_election_ts_for_precincts$votes_inc_republican) # "full"
    df_head_tail_diff$votes_rep_interv_all_interv[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] / sum(df_election_ts_for_precincts_head$votes_inc_republican) # "head"
    df_head_tail_diff$votes_rep_interv_all_interv[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3] / sum(df_election_ts_for_precincts_tail$votes_inc_republican) # "tail"
    #
    df_head_tail_diff$votes_dem_interv_tally_interv[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+1] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] # "full"
    df_head_tail_diff$votes_dem_interv_tally_interv[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+2] # "head"
    df_head_tail_diff$votes_dem_interv_tally_interv[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+3] # "tail"
    #
    df_head_tail_diff$votes_rep_interv_tally_interv[(pid_ind-1)*3+1] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+1] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+1] # "full"
    df_head_tail_diff$votes_rep_interv_tally_interv[(pid_ind-1)*3+2] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+2] # "head"
    df_head_tail_diff$votes_rep_interv_tally_interv[(pid_ind-1)*3+3] <- df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3] / df_head_tail_diff$tally_inc[(pid_ind-1)*3+3] # "tail"
    #
    hypergeom_cdf_dem_le_votes <- stats::phyper(
      q = df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3],
      m =(df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] + df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3]),
      n =(df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] + df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3]),
      k =(df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] + df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3]),
      lower.tail = TRUE)
    df_head_tail_diff$hypergeom_cdf_dem_le_votes[(pid_ind-1)*3+1] <- hypergeom_cdf_dem_le_votes # "full"
    df_head_tail_diff$hypergeom_cdf_dem_le_votes[(pid_ind-1)*3+2] <- hypergeom_cdf_dem_le_votes # "head"
    df_head_tail_diff$hypergeom_cdf_dem_le_votes[(pid_ind-1)*3+3] <- hypergeom_cdf_dem_le_votes # "tail"
    #
    hypergeom_cdf_rep_le_votes <- stats::phyper(
      q = df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3],
      m =(df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+2] + df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3]),
      n =(df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+2] + df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3]),
      k =(df_head_tail_diff$votes_inc_democrat[(pid_ind-1)*3+3] + df_head_tail_diff$votes_inc_republican[(pid_ind-1)*3+3]),
      lower.tail = TRUE)
    df_head_tail_diff$hypergeom_cdf_rep_le_votes[(pid_ind-1)*3+1] <- hypergeom_cdf_rep_le_votes # "full"
    df_head_tail_diff$hypergeom_cdf_rep_le_votes[(pid_ind-1)*3+2] <- hypergeom_cdf_rep_le_votes # "head"
    df_head_tail_diff$hypergeom_cdf_rep_le_votes[(pid_ind-1)*3+3] <- hypergeom_cdf_rep_le_votes # "tail"
    #
    hypergeom_cdf_score <- min(hypergeom_cdf_dem_le_votes, hypergeom_cdf_rep_le_votes)
    df_head_tail_diff$hypergeom_cdf_score[(pid_ind-1)*3+1] <- hypergeom_cdf_score # "full"
    df_head_tail_diff$hypergeom_cdf_score[(pid_ind-1)*3+2] <- hypergeom_cdf_score # "head"
    df_head_tail_diff$hypergeom_cdf_score[(pid_ind-1)*3+3] <- hypergeom_cdf_score # "tail"
  }
  
  df_head_tail_diff <- df_head_tail_diff[order(
    df_head_tail_diff$hypergeom_cdf_score,
    df_head_tail_diff$precinct_geo_id,
    df_head_tail_diff$interval_name
    #-df_head_tail_diff$tally_interv_full,
  ),]
  
  output_file_name <- paste0(substr(str_election_date_YYYYMMDD,3,nchar(str_election_date_YYYYMMDD)), "_",
                             "ussen_", "st_", str_state_abbr, "_ct_", str_county_name, "_summary")
  csv_output_path <- paste0(base_dir,"/output/csv")
  csv_output_file_name <- paste0(output_file_name, ".csv")
  write.csv(x = df_head_tail_diff, file = paste0(csv_output_path,"/",csv_output_file_name), row.names = FALSE)
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
