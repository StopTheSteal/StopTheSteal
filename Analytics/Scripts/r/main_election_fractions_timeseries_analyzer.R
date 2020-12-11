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

bool.download.json <- TRUE
bool.generate.csv  <- TRUE
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
    president_state_strings = president_state_strings,
    senate_state_strings = senate_state_strings,
    special_state_strings = special_state_strings)
}

########################################################################
# Generate PDF (fractions were rounded to three digits after the decimal point)
if(bool.generate.pdf)
{
  generate.plots.for.all.states(str.input.file.path = str.input.file.path,
                                str.output.file.path = str.output.file.path,
                                json_url_base = json_url_base,
                                my_github_base = my_github_base,
                                race_strings = race_strings,
                                president_state_strings = president_state_strings,
                                senate_state_strings = senate_state_strings,
                                special_state_strings = special_state_strings,
                                list_state_to_abbr = list_state_to_abbr,
                                str_election_date_abbr = "201103",
                                str_plot_type_abbr = "st")
  generate.plots.for.all.intervals(str.input.file.path = str.input.file.path,
                                   str.output.file.path = str.output.file.path,
                                   json_url_base = json_url_base,
                                   my_github_base = my_github_base,
                                   race_strings = race_strings,
                                   president_state_strings = president_state_strings,
                                   senate_state_strings = senate_state_strings,
                                   special_state_strings = special_state_strings,
                                   list_state_to_abbr = list_state_to_abbr,
                                   str_election_date_abbr = "201103",
                                   str_plot_type_abbr = "ts")
}
