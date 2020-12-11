Source:
https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/race-page/<state name>/<race name>.json

Input (downloaded JSON and generated CSV):
https://github.com/StopTheSteal/StopTheSteal/tree/main/Analytics/Scripts/r/input/elections-assets/2020/data/api/2020-11-03/race-page

Code:
https://github.com/StopTheSteal/StopTheSteal/tree/main/Analytics/Scripts/r/
https://github.com/StopTheSteal/StopTheSteal/blob/main/Analytics/Scripts/r/library_election_timeseries_analyzer.R
https://github.com/StopTheSteal/StopTheSteal/blob/main/Analytics/Scripts/r/main_election_fractions_timeseries_analyzer.R

Output:
https://github.com/StopTheSteal/StopTheSteal/tree/main/Analytics/Scripts/r/output/pdf

Groups of PDF files with charts:

1. 201103_st_<state abbreviation>.pdf
   all plots for one state (all races on 11/3/2020, all plot types, selected time interval);
   
2. 201103_ts_<state abbreviation>_<race type>_<plot type>.pdf
   plots with various time intervals for one state, one race, one plot type.
   
Race types:

1. "pr": US President
2. "se": US Senate
3. "sp": Special

Plot types:

1. "cf": "cumulative fractions", or cumulative vote percent results per election choice;
2. "cv": "cumulative votes", or cumulative votes results per election choice;
3. "ii": "incremental impact" of batches of votes, with long spikes indicating batches-outliers.
