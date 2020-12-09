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
str.input.file.path <- paste0(base_dir,"/input/elections-assets/2020/data/api/2020-11-03/race-page")
str.output.file.path <- paste0(base_dir, "/output")

if(bool.download.json | bool.generate.csv | bool.backup.csv)
{
  download.json.generate.csv.for.fractions(
    str.input.file.path = str.input.file.path,
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
  generate.plots.for.all.intervals(str.input.file.path = str.input.file.path,
                                   str.output.file.path = str.output.file.path,
                                   json_url_base = json_url_base,
                                   my_github_base = my_github_base,
                                   race_strings = race_strings,
                                   president_state_strings = president_state_strings,
                                   list_state_to_abbr = list_state_to_abbr,
                                   str_election_date_abbr = "201103",
                                   str_plot_type_abbr = "ts") # pass "rc" and "st" to other functions
  
}

if(FALSE)
{
  pdf_output_path <- paste0(str.output.file.path,"/pdf")
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
        str.input.file.path = str.input.file.path, state_name = state_name, race = race)
      if(!is.null(df_election_fractions))
      {
        #min_time = "2020-11-03T21:00:00Z"
        #max_time = "2020-11-05T00:00:00Z"
        str_curr_min_time = "2020-11-04T09:00:00Z"
        str_curr_max_time = "2020-11-04T11:00:00Z"
        plot.batch.impact(
          str_curr_min_time = str_curr_min_time,
          str_curr_max_time = str_curr_max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
        plot.cumulative.votes(
          str_curr_min_time = str_curr_min_time,
          str_curr_max_time = str_curr_max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
        plot.cumulative.vote.fractions(
          str_curr_min_time = str_curr_min_time,
          str_curr_max_time = str_curr_max_time,
          df_election_fractions = df_election_fractions,
          race = race,
          state_name = state_name,
          json_url = json_url,
          my_github_base = my_github_base)
      }
    } # END for(state_index in 1:length(president_state_strings))
    dev.off()
  } # END for(race_index in 1:length(race_strings))
}
