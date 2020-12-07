rm(list=ls())
gc()

options(digits=22)

list.of.packages <- c("httr", "lubridate") # "Cairo"
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("httr")
library("lubridate")
#library("Cairo")
source("library_election_timeseries_analyzer.R")

bool.download.json <- FALSE
bool.generate.csv  <- FALSE
bool.backup.csv    <- FALSE
bool.generate.pdf  <- TRUE

base_dir <- getwd()
if(!endsWith(base_dir,"StopTheSteal/Analytics/Scripts/r"))
{
  stop(paste0("Invalid working directory '",base_dir,"'. Must end with 'StopTheSteal/Analytics/Scripts/r'."))
}
working_dir <- paste0(base_dir,"/input/elections-assets/2020/data/api/2020-11-03/race-page")
str.input.file.path <- working_dir
#str.output.file.path <- paste0(working_dir, "/Output")
#setwd(working_dir)

if(bool.download.json | bool.generate.csv | bool.backup.csv)
{
  download.json.generate.csv.for.fractions(
    working_dir = working_dir,
    json_url_base = json_url_base,
    bool.download.json = bool.download.json,
    bool.generate.csv = bool.generate.csv,
    bool.backup.csv = bool.backup.csv,
    race_strings = race_strings,
    president_state_strings = president_state_strings)
}

########################################################################
# Generate PDF (fractions were rounded to three digits after the decimal point)
if(bool.generate.pdf)
{
  pdf_output_path <- paste0(base_dir,"/output/pdf")
  #for(race_index in 1:length(race_strings))
  race_index <- 1 # race = "president"
  {
    race <- race_strings[race_index]
    if(race == "special")
    {
      url_string <- "senate/0/special.json"
    } else if (race == "president")
    {
      url_string <- "president.json"
    } else if (race == "senate")
    {
      url_string <- "senate.json"
    }
    #CairoPDF(file=paste0(pdf_output_path,"/",race,"_race.pdf"), width=11, height=8.5, paper="special")
    #cairo_pdf(file=paste0(pdf_output_path,"/",race,"_race.pdf"), width=11, height=8.5)
    pdf(file=paste0(pdf_output_path,"/",race,"_race.pdf"), width=11, height=8.5, paper="special")
    #for(state_index in 1:length(president_state_strings))
    state_index <- 50 # state_name = "wisconsin"
    {
      state_name <- president_state_strings[state_index]
      json_url <- paste0(json_url_base, "/", state_name, "/", url_string)

      df_election_fractions <- read.csv.prepare.fraction.data(
        working_dir = working_dir, state_name = state_name, race = race)
      if(!is.null(df_election_fractions))
      {
        if(FALSE)
        {
          n <- nrow(df_election_fractions)
          int_min_time <- df_election_fractions$sec_offset[1]
          int_max_time <- df_election_fractions$sec_offset[n]
          options(digits.secs = 0)
          str_min_time <- format(as.POSIXct(int_min_time, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
          str_max_time <- format(as.POSIXct(int_max_time, origin = "1970-01-01"),"%Y-%m-%dT%H:%M:%OSZ")
          # Sliding windows:
          # Size1 <- 1 * (2/3)^0 = 1;    Shift1 <- (2/3)^0 * 1/2 = 1/2;
          # Size2 <- 1 * (2/3)^1 = 2/3;  Shift2 <- (2/3)^1 * 1/2 = 1/3;
          # Size3 <- 1 * (2/3)^2 = 4/9;  Shift3 <- (2/3)^2 * 1/2 = 2/9;
          # Size4 <- 1 * (2/3)^3 = 8/27; Shift3 <- (2/3)^3 * 1/2 = 4/27;
          # ... until SizeN * (t_max - t_min) < threshold = 3600 * 3 seconds
        }
        #min_time = "2020-11-03T21:00:00Z"
        #max_time = "2020-11-05T00:00:00Z"
        min_time = "2020-11-04T09:00:00Z"
        max_time = "2020-11-04T11:00:00Z"
        plot.batch.impact(
          min_time = min_time,
          max_time = max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
        #if(FALSE)
        #{
        plot.cumulative.votes(
          min_time = min_time,
          max_time = max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
        plot.cumulative.vote.fractions(
          min_time = min_time,
          max_time = max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
        #}
      }
    } # END for(state_index in 1:length(president_state_strings))
    dev.off()
  } # END for(race_index in 1:length(race_strings))
  # ...
}
