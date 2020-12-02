######################################################################################################
#
#AL
#AK = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/AKGeneral-latest.json
#AZ
#AR = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/ARGeneral-latest.json
#CA
#CO = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/COGeneral-latest.json
#CT
#DC
#DE = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/DEGeneral-latest.json
#FL = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/FLGeneralConcatenator-latest.json
#GA = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/GAGeneral-latest.json
#HI = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/HIGeneral-latest.json
#ID
#IL
#IN
#IA
#KS
#KY = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/KYGeneral-latest.json
#LA = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/LAGeneral-latest.json
#ME
#MD
#MA
#MI = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/MIGeneralConcatenator-latest.json
#MN = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/MNGeneral-latest.json
#MS
#MO
#MT = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/MTGeneral-latest.json
#NE = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/NEGeneral-latest.json
#NV
#NH
#NJ
#NM = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/NMGeneral-latest.json
#NY
#NC = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/NCGeneral-latest.json
#ND = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/NDGeneral-latest.json
#OH
#OK = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/OKGeneral-latest.json
#OR
#PA = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/PAGeneralConcatenator-latest.json
#RI
#SC = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/SCGeneral-latest.json
#SD = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/SDGeneral-latest.json
#TN
#TX
#UT
#VT
#VA
#WA = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/WAGeneral-latest.json
#WV = https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/WVGeneral-latest.json
#WI
#WY
#
######################################################################################################
#
#|SA|P|START|END|LINK TO LINKS|COMMENT|
#|AK|1|||||
#|AR|1|||||
#|CO|1|||||
#|DE|1|||||
#|FL|2|2020-11-01T20:23:41.048Z|2020-11-10T14:29:02.422Z|https://pastebin.com/ai9skssU
#|GA|1|2020-10-31T22:14:05.096Z|2020-11-11T22:32:34.439Z|https://pastebin.com/CD05B8fw
#|HI|1|||||
#|KY|1|||||
#|LA|1|||||
#|MI|2|2020-11-03T19:39:31.715Z|2020-11-10T19:13:08.066Z|https://pastebin.com/W4h6FSPi
#|MN|1|||||
#|MT|1|||||
#|NE|1|||||
#|NM|1|||||
#|NC|1|2020-10-30T13:19:01.425Z|2020-11-11T21:21:55.407Z|https://pastebin.com/stpeXHYE
#|ND|1|||||
#|OK|1|||||
#|PA|2|2020-11-03T19:39:48.428Z|2020-11-11T21:50:46.218Z|https://pastebin.com/5xBeaQzh
#|SC|1|||||
#|SD|1|||||
#|WA|1|||||
#|WV|1|||||
#
# P in {1,2} => {"General-", "GeneralConcatenator-"}
# START <= T <= END or T = "latest"
# Links: "https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/{SA}{P}{T}.json"
#
######################################################################################################

url_template <- "https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts"
file_extension <- ".json"
str_latest_snapshot_timestamp <- "2020-12-01T11:59:59.999Z"

arrStateAbbrs <- c("AK","AR","CO","DE","FL","GA","HI","KY","LA","MI","MN","MT","NE","NM","NC","ND","OK","PA","SC","SD","WA","WV")
arrStateNames <- c(
  "Alaska", # AK
  "Arkansas", # AR
  "Colorado", # CO
  "Delaware", # DE
  "Florida", # FL
  "Georgia", # GA
  "Hawaii", # HI
  "Kentucky", # KY
  "Louisiana", # LA
  "Michigan", # MI
  "Minnesota", # MN
  "Montana", # MT
  "Nebraska", # NE
  "New Mexico", # NM
  "North Carolina", # NC
  "North Dakota", # ND
  "Oklahoma", # OK
  "Pennsylvania", # PA
  "South Carolina", # SC
  "South Dakota", # SD
  "Washington", # WA
  "West Virginia" # WV
  )

list_file_prefixes <- list(
  AK = "AKGeneral-",
  AR = "ARGeneral-",
  CO = "COGeneral-",
  DE = "DEGeneral-",
  FL = "FLGeneralConcatenator-",
  GA = "GAGeneral-",
  HI = "HIGeneral-",
  KY = "KYGeneral-",
  LA = "LAGeneral-",
  MI = "MIGeneralConcatenator-",
  MN = "MNGeneral-",
  MT = "MTGeneral-",
  NE = "NEGeneral-",
  NM = "NMGeneral-",
  NC = "NCGeneral-",
  ND = "NDGeneral-",
  OK = "OKGeneral-",
  PA = "PAGeneralConcatenator-",
  SC = "SCGeneral-",
  SD = "SDGeneral-",
  WA = "WAGeneral-",
  WV = "WVGeneral-"
  )

list_file_postfixes <- list(
  AK = c(
    "latest"),
  AR = c(
    "latest"),
  CO = c(
    "latest"),
  DE = c(
    "latest"),
  FL = c(
    "2020-11-01T20:23:41.048Z",
    "2020-11-03T19:10:34.753Z",
    "2020-11-03T19:48:11.132Z",
    "2020-11-03T20:50:09.655Z",
    "2020-11-03T21:32:43.796Z",
    "2020-11-03T23:04:20.734Z",
    "2020-11-03T23:09:18.088Z",
    "2020-11-03T23:37:11.444Z",
    "2020-11-04T00:00:48.405Z",
    "2020-11-04T00:03:37.485Z",
    "2020-11-04T00:10:02.552Z",
    "2020-11-04T00:12:21.206Z",
    "2020-11-04T00:13:43.838Z",
    "2020-11-04T00:15:39.143Z",
    "2020-11-04T00:18:33.119Z",
    "2020-11-04T00:21:51.792Z",
    "2020-11-04T00:24:52.396Z",
    "2020-11-04T00:27:42.448Z",
    "2020-11-04T00:28:05.627Z",
    "2020-11-04T00:30:42.764Z",
    "2020-11-04T00:33:24.144Z",
    "2020-11-04T00:33:44.745Z",
    "2020-11-04T00:35:16.415Z",
    "2020-11-04T00:36:23.570Z",
    "2020-11-04T00:38:17.497Z",
    "2020-11-04T00:44:27.754Z",
    "2020-11-04T00:45:26.909Z",
    "2020-11-04T00:47:28.478Z",
    "2020-11-04T00:50:00.345Z",
    "2020-11-04T00:51:58.786Z",
    "2020-11-04T00:58:51.133Z",
    "2020-11-04T00:59:14.272Z",
    "2020-11-04T01:00:21.243Z",
    "2020-11-04T01:12:04.727Z",
    "2020-11-04T01:12:53.879Z",
    "2020-11-04T01:16:10.725Z",
    "2020-11-04T01:17:02.012Z",
    "2020-11-04T01:20:41.027Z",
    "2020-11-04T01:21:33.914Z",
    "2020-11-04T01:24:16.746Z",
    "2020-11-04T01:24:53.938Z",
    "2020-11-04T01:25:44.118Z",
    "2020-11-04T01:26:23.413Z",
    "2020-11-04T01:28:44.134Z",
    "2020-11-04T01:30:11.909Z",
    "2020-11-04T01:31:30.510Z",
    "2020-11-04T01:35:03.081Z",
    "2020-11-04T01:36:28.405Z",
    "2020-11-04T01:37:46.139Z",
    "2020-11-04T01:38:22.598Z",
    "2020-11-04T01:41:28.807Z",
    "2020-11-04T01:50:19.922Z",
    "2020-11-04T01:51:42.506Z",
    "2020-11-04T01:53:14.176Z",
    "2020-11-04T01:53:52.991Z",
    "2020-11-04T01:54:42.310Z",
    "2020-11-04T01:57:32.517Z",
    "2020-11-04T02:00:12.109Z",
    "2020-11-04T02:00:48.754Z",
    "2020-11-04T02:02:22.581Z",
    "2020-11-04T02:03:13.575Z",
    "2020-11-04T02:03:55.025Z",
    "2020-11-04T02:04:45.775Z",
    "2020-11-04T02:08:57.110Z",
    "2020-11-04T02:12:07.612Z",
    "2020-11-04T02:12:27.397Z",
    "2020-11-04T02:16:50.147Z",
    "2020-11-04T02:20:53.843Z",
    "2020-11-04T02:22:40.855Z",
    "2020-11-04T02:24:11.769Z",
    "2020-11-04T02:32:59.675Z",
    "2020-11-04T02:38:08.326Z",
    "2020-11-04T02:43:24.418Z",
    "2020-11-04T02:45:21.536Z",
    "2020-11-04T02:47:18.199Z",
    "2020-11-04T02:48:43.018Z",
    "2020-11-04T02:50:11.759Z",
    "2020-11-04T02:53:22.081Z",
    "2020-11-04T02:57:08.628Z",
    "2020-11-04T02:59:13.857Z",
    "2020-11-04T03:00:00.532Z",
    "2020-11-04T03:08:40.767Z",
    "2020-11-04T03:11:32.388Z",
    "2020-11-04T03:16:35.365Z",
    "2020-11-04T03:20:25.890Z",
    "2020-11-04T03:22:25.629Z",
    "2020-11-04T03:26:33.799Z",
    "2020-11-04T03:28:28.618Z",
    "2020-11-04T03:29:17.241Z",
    "2020-11-04T03:30:46.613Z",
    "2020-11-04T03:35:08.910Z",
    "2020-11-04T03:36:36.109Z",
    "2020-11-04T03:39:27.841Z",
    "2020-11-04T03:48:43.461Z",
    "2020-11-04T03:52:49.349Z",
    "2020-11-04T04:00:03.924Z",
    "2020-11-04T04:04:21.571Z",
    "2020-11-04T04:15:31.830Z",
    "2020-11-04T04:18:56.741Z",
    "2020-11-04T04:21:00.749Z",
    "2020-11-04T04:21:49.675Z",
    "2020-11-04T04:22:35.959Z",
    "2020-11-04T04:24:32.981Z",
    "2020-11-04T04:28:34.358Z",
    "2020-11-04T04:38:40.426Z",
    "2020-11-04T04:46:18.520Z",
    "2020-11-04T04:53:20.946Z",
    "2020-11-04T04:55:23.106Z",
    "2020-11-04T05:01:07.798Z",
    "2020-11-04T05:27:57.850Z",
    "2020-11-04T05:28:52.237Z",
    "2020-11-04T05:35:41.448Z",
    "2020-11-04T05:41:32.007Z",
    "2020-11-04T05:48:00.214Z",
    "2020-11-04T05:59:57.020Z",
    "2020-11-04T06:23:43.422Z",
    "2020-11-04T06:33:23.353Z",
    "2020-11-04T06:50:40.722Z",
    "2020-11-04T07:05:04.943Z",
    "2020-11-04T09:25:21.242Z",
    "2020-11-04T10:34:53.284Z",
    "2020-11-04T17:14:35.539Z",
    "2020-11-04T22:34:48.379Z",
    "2020-11-04T23:35:41.100Z",
    "2020-11-05T00:04:58.380Z",
    "2020-11-05T01:05:30.965Z",
    "2020-11-05T04:20:19.803Z",
    "2020-11-05T20:22:36.945Z",
    "2020-11-05T22:24:25.645Z",
    "2020-11-05T23:25:03.071Z",
    "2020-11-06T00:22:52.696Z",
    "2020-11-06T00:53:56.979Z",
    "2020-11-06T01:24:37.653Z",
    "2020-11-06T04:22:44.313Z",
    "2020-11-06T13:28:12.292Z",
    "2020-11-06T13:58:39.718Z",
    "2020-11-06T14:06:25.012Z",
    "2020-11-06T14:36:38.751Z",
    "2020-11-06T15:37:04.873Z",
    "2020-11-06T18:27:49.469Z",
    "2020-11-06T19:28:11.893Z",
    "2020-11-06T20:29:29.916Z",
    "2020-11-06T21:30:02.453Z",
    "2020-11-06T22:30:30.387Z",
    "2020-11-06T23:30:33.177Z",
    "2020-11-07T02:16:44.599Z",
    "2020-11-07T02:18:09.291Z",
    "2020-11-07T06:19:56.520Z",
    "2020-11-07T08:20:23.844Z",
    "2020-11-07T09:21:15.820Z",
    "2020-11-07T10:21:09.378Z",
    "2020-11-07T11:00:21.420Z",
    "2020-11-07T14:57:53.819Z",
    "2020-11-07T16:18:20.093Z",
    "2020-11-07T17:18:10.631Z",
    "2020-11-07T23:19:49.400Z",
    "2020-11-08T11:25:15.610Z",
    "2020-11-08T17:30:26.828Z",
    "2020-11-08T19:31:21.730Z",
    "2020-11-09T00:30:32.646Z",
    "2020-11-09T14:30:22.038Z",
    "2020-11-09T18:45:28.481Z",
    "2020-11-09T22:29:39.433Z",
    "2020-11-10T14:29:02.422Z",
    "latest"),
  GA = c(
    "2020-10-31T22:14:05.096Z",
    "2020-11-03T23:40:53.085Z",
    "2020-11-04T00:11:04.659Z",
    "2020-11-04T00:14:43.743Z",
    "2020-11-04T00:23:31.696Z",
    "2020-11-04T00:29:22.735Z",
    "2020-11-04T00:32:55.655Z",
    "2020-11-04T00:36:15.190Z",
    "2020-11-04T00:40:38.045Z",
    "2020-11-04T00:44:14.837Z",
    "2020-11-04T00:49:02.518Z",
    "2020-11-04T00:56:34.218Z",
    "2020-11-04T01:11:35.765Z",
    "2020-11-04T01:15:08.661Z",
    "2020-11-04T01:20:20.753Z",
    "2020-11-04T01:23:55.615Z",
    "2020-11-04T01:27:12.356Z",
    "2020-11-04T01:30:29.565Z",
    "2020-11-04T01:34:00.886Z",
    "2020-11-04T01:38:52.336Z",
    "2020-11-04T01:45:42.861Z",
    "2020-11-04T01:49:04.134Z",
    "2020-11-04T01:52:34.456Z",
    "2020-11-04T01:56:18.161Z",
    "2020-11-04T02:01:58.313Z",
    "2020-11-04T02:05:29.854Z",
    "2020-11-04T02:08:55.234Z",
    "2020-11-04T02:12:37.171Z",
    "2020-11-04T02:19:26.324Z",
    "2020-11-04T02:29:42.004Z",
    "2020-11-04T02:33:11.219Z",
    "2020-11-04T02:41:14.449Z",
    "2020-11-04T02:46:06.870Z",
    "2020-11-04T02:49:39.620Z",
    "2020-11-04T02:52:55.599Z",
    "2020-11-04T02:56:32.639Z",
    "2020-11-04T03:03:24.419Z",
    "2020-11-04T03:06:54.312Z",
    "2020-11-04T03:13:51.629Z",
    "2020-11-04T03:17:19.148Z",
    "2020-11-04T03:20:34.505Z",
    "2020-11-04T03:24:10.344Z",
    "2020-11-04T03:27:42.166Z",
    "2020-11-04T03:30:59.136Z",
    "2020-11-04T03:34:33.240Z",
    "2020-11-04T03:44:50.959Z",
    "2020-11-04T03:48:14.202Z",
    "2020-11-04T03:51:55.686Z",
    "2020-11-04T03:55:18.934Z",
    "2020-11-04T03:58:34.653Z",
    "2020-11-04T04:02:03.338Z",
    "2020-11-04T04:12:27.373Z",
    "2020-11-04T04:15:39.425Z",
    "2020-11-04T04:20:37.325Z",
    "2020-11-04T04:27:23.343Z",
    "2020-11-04T04:34:58.304Z",
    "2020-11-04T04:38:29.842Z",
    "2020-11-04T04:41:59.353Z",
    "2020-11-04T04:50:23.440Z",
    "2020-11-04T04:53:38.018Z",
    "2020-11-04T04:57:08.375Z",
    "2020-11-04T05:24:05.704Z",
    "2020-11-04T05:30:57.333Z",
    "2020-11-04T05:37:29.716Z",
    "2020-11-04T05:57:49.547Z",
    "2020-11-04T06:22:35.850Z",
    "2020-11-04T06:32:43.820Z",
    "2020-11-04T06:36:11.798Z",
    "2020-11-04T07:07:24.747Z",
    "2020-11-04T07:54:09.490Z",
    "2020-11-04T08:00:51.135Z",
    "2020-11-04T16:04:20.496Z",
    "2020-11-04T16:34:36.899Z",
    "2020-11-04T16:38:01.441Z",
    "2020-11-04T17:15:13.003Z",
    "2020-11-04T17:49:16.581Z",
    "2020-11-04T18:33:42.439Z",
    "2020-11-04T18:37:00.257Z",
    "2020-11-04T19:14:29.968Z",
    "2020-11-04T19:33:11.813Z",
    "2020-11-04T19:36:30.548Z",
    "2020-11-04T19:43:33.346Z",
    "2020-11-04T20:13:43.265Z",
    "2020-11-04T20:33:48.294Z",
    "2020-11-04T20:40:26.820Z",
    "2020-11-04T21:00:55.364Z",
    "2020-11-04T21:36:30.623Z",
    "2020-11-04T22:03:20.144Z",
    "2020-11-04T22:24:19.487Z",
    "2020-11-04T22:57:07.964Z",
    "2020-11-04T23:50:14.678Z",
    "2020-11-05T00:16:45.271Z",
    "2020-11-05T00:49:19.907Z",
    "2020-11-05T01:12:58.564Z",
    "2020-11-05T01:34:29.088Z",
    "2020-11-05T02:00:33.912Z",
    "2020-11-05T02:18:47.641Z",
    "2020-11-05T03:07:55.519Z",
    "2020-11-05T04:24:13.870Z",
    "2020-11-05T05:21:51.596Z",
    "2020-11-05T06:07:41.776Z",
    "2020-11-05T10:52:28.118Z",
    "2020-11-05T14:01:18.864Z",
    "2020-11-05T14:49:55.350Z",
    "2020-11-05T16:49:53.431Z",
    "2020-11-05T18:32:08.054Z",
    "2020-11-05T19:00:31.633Z",
    "2020-11-05T19:25:26.705Z",
    "2020-11-05T19:40:41.812Z",
    "2020-11-05T20:28:11.145Z",
    "2020-11-05T20:43:46.995Z",
    "2020-11-05T21:14:29.887Z",
    "2020-11-05T22:07:25.227Z",
    "2020-11-05T22:19:37.037Z",
    "2020-11-05T22:38:24.906Z",
    "2020-11-05T23:03:25.333Z",
    "2020-11-05T23:54:45.478Z",
    "2020-11-06T00:22:37.169Z",
    "2020-11-06T01:55:44.581Z",
    "2020-11-06T02:33:12.517Z",
    "2020-11-06T03:19:39.122Z",
    "2020-11-06T04:09:36.360Z",
    "2020-11-06T06:30:07.181Z",
    "2020-11-06T07:38:26.297Z",
    "2020-11-06T08:38:03.578Z",
    "2020-11-06T09:18:42.027Z",
    "2020-11-06T10:06:29.648Z",
    "2020-11-06T13:06:57.354Z",
    "2020-11-06T14:20:32.293Z",
    "2020-11-06T15:34:35.526Z",
    "2020-11-06T16:24:44.007Z",
    "2020-11-06T16:30:48.498Z",
    "2020-11-06T19:19:09.095Z",
    "2020-11-06T19:40:45.897Z",
    "2020-11-06T20:23:01.484Z",
    "2020-11-06T20:38:34.335Z",
    "2020-11-06T22:07:17.544Z",
    "2020-11-06T22:22:34.568Z",
    "2020-11-06T22:38:06.794Z",
    "2020-11-06T22:53:31.036Z",
    "2020-11-06T23:42:15.171Z",
    "2020-11-06T23:45:17.767Z",
    "2020-11-06T23:57:39.240Z",
    "2020-11-07T01:28:54.872Z",
    "2020-11-07T02:53:44.150Z",
    "2020-11-07T05:38:17.006Z",
    "2020-11-07T07:46:31.838Z",
    "2020-11-07T18:15:34.503Z",
    "2020-11-07T19:20:27.474Z",
    "2020-11-07T19:46:17.236Z",
    "2020-11-07T23:53:18.153Z",
    "2020-11-08T07:23:21.206Z",
    "2020-11-08T13:09:39.235Z",
    "2020-11-08T19:38:53.915Z",
    "2020-11-09T14:35:24.523Z",
    "2020-11-09T16:02:35.204Z",
    "2020-11-09T16:26:44.754Z",
    "2020-11-09T17:16:59.669Z",
    "2020-11-09T19:02:32.336Z",
    "2020-11-09T19:37:20.471Z",
    "2020-11-09T21:29:34.470Z",
    "2020-11-09T22:12:11.656Z",
    "2020-11-09T22:46:43.786Z",
    "2020-11-09T23:35:12.237Z",
    "2020-11-10T01:52:22.197Z",
    "2020-11-10T14:53:53.873Z",
    "2020-11-10T16:59:42.737Z",
    "2020-11-10T18:45:51.675Z",
    "2020-11-10T20:10:26.030Z",
    "2020-11-10T21:18:12.376Z",
    "2020-11-10T23:28:22.595Z",
    "2020-11-11T00:12:28.188Z",
    "2020-11-11T19:09:28.636Z",
    "2020-11-11T21:10:30.230Z",
    "2020-11-11T22:32:34.439Z",
    "latest"),
  HI = c(
    "latest"),
  KY = c(
    "latest"),
  LA = c(
    "latest"),
  MI = c(
    "2020-11-03T19:39:31.715Z",
    "2020-11-03T23:01:38.141Z",
    "2020-11-03T23:28:40.644Z",
    "2020-11-04T01:10:59.248Z",
    "2020-11-04T01:14:18.060Z",
    "2020-11-04T01:20:51.388Z",
    "2020-11-04T01:22:40.090Z",
    "2020-11-04T01:24:58.717Z",
    "2020-11-04T01:27:13.495Z",
    "2020-11-04T01:29:29.542Z",
    "2020-11-04T01:31:49.959Z",
    "2020-11-04T01:33:27.422Z",
    "2020-11-04T01:36:26.208Z",
    "2020-11-04T01:38:03.265Z",
    "2020-11-04T01:39:24.329Z",
    "2020-11-04T01:50:31.590Z",
    "2020-11-04T01:52:08.129Z",
    "2020-11-04T01:53:58.846Z",
    "2020-11-04T01:56:48.674Z",
    "2020-11-04T01:58:36.648Z",
    "2020-11-04T02:00:53.066Z",
    "2020-11-04T02:02:28.825Z",
    "2020-11-04T02:04:20.324Z",
    "2020-11-04T02:09:03.824Z",
    "2020-11-04T02:11:13.052Z",
    "2020-11-04T02:15:28.789Z",
    "2020-11-04T02:17:48.861Z",
    "2020-11-04T02:22:17.499Z",
    "2020-11-04T02:23:19.290Z",
    "2020-11-04T02:31:05.574Z",
    "2020-11-04T02:38:12.232Z",
    "2020-11-04T02:41:59.405Z",
    "2020-11-04T02:44:15.426Z",
    "2020-11-04T02:48:45.922Z",
    "2020-11-04T02:52:41.280Z",
    "2020-11-04T02:57:10.828Z",
    "2020-11-04T03:08:03.508Z",
    "2020-11-04T03:10:17.901Z",
    "2020-11-04T03:14:50.460Z",
    "2020-11-04T03:21:00.872Z",
    "2020-11-04T03:23:13.917Z",
    "2020-11-04T03:25:32.264Z",
    "2020-11-04T03:27:59.641Z",
    "2020-11-04T03:30:05.652Z",
    "2020-11-04T03:32:30.705Z",
    "2020-11-04T03:35:24.646Z",
    "2020-11-04T03:36:31.024Z",
    "2020-11-04T03:38:46.540Z",
    "2020-11-04T03:49:43.478Z",
    "2020-11-04T03:53:58.866Z",
    "2020-11-04T03:58:31.489Z",
    "2020-11-04T04:02:52.090Z",
    "2020-11-04T04:07:12.222Z",
    "2020-11-04T04:15:34.564Z",
    "2020-11-04T04:17:44.730Z",
    "2020-11-04T04:20:05.116Z",
    "2020-11-04T04:21:08.767Z",
    "2020-11-04T04:23:04.729Z",
    "2020-11-04T04:25:16.599Z",
    "2020-11-04T04:32:00.482Z",
    "2020-11-04T04:37:49.340Z",
    "2020-11-04T04:40:28.181Z",
    "2020-11-04T04:46:52.403Z",
    "2020-11-04T04:53:19.187Z",
    "2020-11-04T04:57:50.994Z",
    "2020-11-04T05:04:21.379Z",
    "2020-11-04T05:27:48.316Z",
    "2020-11-04T05:34:18.745Z",
    "2020-11-04T05:36:29.666Z",
    "2020-11-04T05:47:22.518Z",
    "2020-11-04T06:07:07.739Z",
    "2020-11-04T06:25:00.935Z",
    "2020-11-04T06:27:58.556Z",
    "2020-11-04T06:31:10.397Z",
    "2020-11-04T06:37:58.758Z",
    "2020-11-04T06:44:24.358Z",
    "2020-11-04T06:46:33.719Z",
    "2020-11-04T06:55:07.616Z",
    "2020-11-04T07:08:16.162Z",
    "2020-11-04T07:16:41.517Z",
    "2020-11-04T07:21:20.877Z",
    "2020-11-04T07:25:36.989Z",
    "2020-11-04T07:39:34.224Z",
    "2020-11-04T07:41:35.433Z",
    "2020-11-04T07:48:08.874Z",
    "2020-11-04T07:56:55.619Z",
    "2020-11-04T08:05:11.635Z",
    "2020-11-04T08:10:57.961Z",
    "2020-11-04T08:18:23.593Z",
    "2020-11-04T08:27:35.760Z",
    "2020-11-04T08:49:01.772Z",
    "2020-11-04T09:15:46.574Z",
    "2020-11-04T09:18:01.210Z",
    "2020-11-04T10:01:59.299Z",
    "2020-11-04T10:23:34.581Z",
    "2020-11-04T10:49:26.786Z",
    "2020-11-04T10:57:51.728Z",
    "2020-11-04T11:08:51.869Z",
    "2020-11-04T11:31:43.768Z",
    "2020-11-04T11:38:05.943Z",
    "2020-11-04T12:03:50.648Z",
    "2020-11-04T12:31:15.976Z",
    "2020-11-04T12:46:41.696Z",
    "2020-11-04T12:54:06.809Z",
    "2020-11-04T13:17:53.063Z",
    "2020-11-04T13:40:32.460Z",
    "2020-11-04T14:07:24.703Z",
    "2020-11-04T14:16:03.886Z",
    "2020-11-04T14:46:30.247Z",
    "2020-11-04T15:12:44.730Z",
    "2020-11-04T15:35:33.018Z",
    "2020-11-04T15:45:39.037Z",
    "2020-11-04T15:57:59.521Z",
    "2020-11-04T16:22:59.957Z",
    "2020-11-04T16:52:37.111Z",
    "2020-11-04T17:21:23.574Z",
    "2020-11-04T17:39:06.402Z",
    "2020-11-04T17:48:12.582Z",
    "2020-11-04T19:10:10.447Z",
    "2020-11-04T20:10:53.927Z",
    "2020-11-04T20:38:47.570Z",
    "2020-11-04T22:40:38.521Z",
    "2020-11-05T00:06:27.381Z",
    "2020-11-05T01:45:11.832Z",
    "2020-11-05T03:08:50.581Z",
    "2020-11-05T16:03:39.888Z",
    "2020-11-05T19:20:10.316Z",
    "2020-11-05T20:52:37.622Z",
    "2020-11-06T04:05:37.579Z",
    "2020-11-06T13:29:24.875Z",
    "2020-11-06T18:26:43.677Z",
    "2020-11-06T19:26:49.796Z",
    "2020-11-06T21:27:28.703Z",
    "2020-11-06T23:27:08.887Z",
    "2020-11-09T18:11:26.548Z",
    "2020-11-10T15:30:00.413Z",
    "2020-11-10T19:13:08.066Z",
    "latest"),
  MN = c(
    "latest"),
  MT = c(
    "latest"),
  NE = c(
    "latest"),
  NM = c(
    "latest"),
  NC = c(
    "2020-10-30T13:19:01.425Z",
    "2020-11-04T01:20:19.239Z",
    "2020-11-04T01:23:38.338Z",
    "2020-11-04T01:26:39.096Z",
    "2020-11-04T01:29:41.091Z",
    "2020-11-04T01:31:08.724Z",
    "2020-11-04T01:35:38.862Z",
    "2020-11-04T01:37:10.165Z",
    "2020-11-04T01:40:36.437Z",
    "2020-11-04T01:48:06.839Z",
    "2020-11-04T01:52:41.754Z",
    "2020-11-04T01:56:16.878Z",
    "2020-11-04T01:58:05.743Z",
    "2020-11-04T02:01:03.418Z",
    "2020-11-04T02:05:22.683Z",
    "2020-11-04T02:11:18.353Z",
    "2020-11-04T02:14:20.101Z",
    "2020-11-04T02:20:04.007Z",
    "2020-11-04T02:23:01.319Z",
    "2020-11-04T02:31:51.080Z",
    "2020-11-04T02:37:39.227Z",
    "2020-11-04T02:42:13.811Z",
    "2020-11-04T02:46:05.114Z",
    "2020-11-04T02:49:24.573Z",
    "2020-11-04T02:50:50.460Z",
    "2020-11-04T02:56:37.691Z",
    "2020-11-04T02:59:30.934Z",
    "2020-11-04T03:05:13.969Z",
    "2020-11-04T03:09:38.288Z",
    "2020-11-04T03:15:33.198Z",
    "2020-11-04T03:18:24.693Z",
    "2020-11-04T03:21:20.686Z",
    "2020-11-04T03:24:21.544Z",
    "2020-11-04T03:28:46.452Z",
    "2020-11-04T03:31:43.800Z",
    "2020-11-04T03:34:41.706Z",
    "2020-11-04T03:38:56.453Z",
    "2020-11-04T03:49:04.336Z",
    "2020-11-04T03:52:05.984Z",
    "2020-11-04T03:57:46.736Z",
    "2020-11-04T04:05:00.748Z",
    "2020-11-04T04:12:05.116Z",
    "2020-11-04T04:17:57.163Z",
    "2020-11-04T04:20:35.992Z",
    "2020-11-04T04:23:49.913Z",
    "2020-11-04T04:25:14.743Z",
    "2020-11-04T04:31:27.675Z",
    "2020-11-04T05:05:47.821Z",
    "2020-11-04T05:35:13.886Z",
    "2020-11-04T15:04:03.994Z",
    "2020-11-04T16:31:43.206Z",
    "2020-11-06T21:47:49.680Z",
    "2020-11-06T23:00:00.860Z",
    "2020-11-06T23:24:08.550Z",
    "2020-11-07T01:35:55.396Z",
    "2020-11-07T19:32:53.808Z",
    "2020-11-07T23:48:22.906Z",
    "2020-11-09T13:51:05.275Z",
    "2020-11-09T17:07:00.683Z",
    "2020-11-09T18:33:02.085Z",
    "2020-11-09T20:11:36.565Z",
    "2020-11-09T21:53:37.914Z",
    "2020-11-09T22:41:53.590Z",
    "2020-11-09T23:47:46.461Z",
    "2020-11-10T01:27:09.630Z",
    "2020-11-10T12:06:50.104Z",
    "2020-11-10T15:08:54.317Z",
    "2020-11-10T16:49:48.417Z",
    "2020-11-10T21:40:22.345Z",
    "2020-11-10T21:43:53.067Z",
    "2020-11-10T23:33:55.796Z",
    "2020-11-11T02:49:14.995Z",
    "2020-11-11T16:30:55.800Z",
    "2020-11-11T21:21:55.407Z",
    "latest"),
  ND = c(
    "latest"),
  OK = c(
    "latest"),
  PA = c(
    "2020-11-03T19:39:48.428Z",
    "2020-11-03T19:47:21.689Z",
    "2020-11-04T01:02:56.961Z",
    "2020-11-04T01:11:32.237Z",
    "2020-11-04T01:15:49.757Z",
    "2020-11-04T01:16:22.794Z",
    "2020-11-04T01:20:49.779Z",
    "2020-11-04T01:31:00.020Z",
    "2020-11-04T01:37:59.697Z",
    "2020-11-04T01:41:00.339Z",
    "2020-11-04T01:47:45.735Z",
    "2020-11-04T01:51:32.742Z",
    "2020-11-04T01:56:46.621Z",
    "2020-11-04T01:58:03.337Z",
    "2020-11-04T02:02:27.783Z",
    "2020-11-04T02:07:46.029Z",
    "2020-11-04T02:12:30.122Z",
    "2020-11-04T02:16:40.084Z",
    "2020-11-04T02:21:55.078Z",
    "2020-11-04T02:22:26.699Z",
    "2020-11-04T02:23:43.894Z",
    "2020-11-04T02:33:08.991Z",
    "2020-11-04T02:37:37.129Z",
    "2020-11-04T02:41:48.141Z",
    "2020-11-04T02:43:32.758Z",
    "2020-11-04T02:46:36.465Z",
    "2020-11-04T02:48:21.416Z",
    "2020-11-04T02:52:59.942Z",
    "2020-11-04T02:57:03.104Z",
    "2020-11-04T02:58:51.687Z",
    "2020-11-04T03:01:12.045Z",
    "2020-11-04T03:08:04.508Z",
    "2020-11-04T03:11:50.154Z",
    "2020-11-04T03:16:43.281Z",
    "2020-11-04T03:17:45.684Z",
    "2020-11-04T03:23:32.564Z",
    "2020-11-04T03:25:36.542Z",
    "2020-11-04T03:28:32.423Z",
    "2020-11-04T03:30:10.090Z",
    "2020-11-04T03:32:07.052Z",
    "2020-11-04T03:32:40.564Z",
    "2020-11-04T03:36:46.369Z",
    "2020-11-04T03:39:45.667Z",
    "2020-11-04T03:47:34.224Z",
    "2020-11-04T03:51:55.726Z",
    "2020-11-04T03:58:36.379Z",
    "2020-11-04T04:00:31.893Z",
    "2020-11-04T04:02:32.548Z",
    "2020-11-04T04:07:12.226Z",
    "2020-11-04T04:11:09.936Z",
    "2020-11-04T04:17:19.111Z",
    "2020-11-04T04:19:38.017Z",
    "2020-11-04T04:21:05.336Z",
    "2020-11-04T04:24:42.825Z",
    "2020-11-04T04:31:58.444Z",
    "2020-11-04T04:35:50.923Z",
    "2020-11-04T04:42:04.229Z",
    "2020-11-04T04:51:15.817Z",
    "2020-11-04T04:57:54.465Z",
    "2020-11-04T05:01:47.468Z",
    "2020-11-04T05:27:31.945Z",
    "2020-11-04T05:32:10.701Z",
    "2020-11-04T05:36:29.115Z",
    "2020-11-04T05:47:38.056Z",
    "2020-11-04T06:04:43.127Z",
    "2020-11-04T06:22:32.255Z",
    "2020-11-04T06:29:19.959Z",
    "2020-11-04T06:31:07.427Z",
    "2020-11-04T06:42:15.150Z",
    "2020-11-04T06:46:11.076Z",
    "2020-11-04T07:08:18.041Z",
    "2020-11-04T07:12:42.570Z",
    "2020-11-04T07:21:12.617Z",
    "2020-11-04T07:37:18.545Z",
    "2020-11-04T07:43:45.178Z",
    "2020-11-04T08:02:03.378Z",
    "2020-11-04T08:16:20.848Z",
    "2020-11-04T08:31:05.033Z",
    "2020-11-04T09:06:53.895Z",
    "2020-11-04T09:39:44.457Z",
    "2020-11-04T10:25:19.444Z",
    "2020-11-04T11:42:30.769Z",
    "2020-11-04T12:26:42.051Z",
    "2020-11-04T13:08:49.766Z",
    "2020-11-04T14:09:35.941Z",
    "2020-11-04T14:16:04.731Z",
    "2020-11-04T14:27:12.269Z",
    "2020-11-04T15:00:33.289Z",
    "2020-11-04T15:11:18.797Z",
    "2020-11-04T15:47:05.771Z",
    "2020-11-04T16:01:46.071Z",
    "2020-11-04T16:09:34.002Z",
    "2020-11-04T16:46:06.879Z",
    "2020-11-04T16:51:34.329Z",
    "2020-11-04T16:57:01.192Z",
    "2020-11-04T17:21:28.840Z",
    "2020-11-04T17:33:56.364Z",
    "2020-11-04T17:42:07.729Z",
    "2020-11-04T17:48:47.507Z",
    "2020-11-04T18:27:17.837Z",
    "2020-11-04T18:36:12.904Z",
    "2020-11-04T19:06:04.118Z",
    "2020-11-04T19:30:12.818Z",
    "2020-11-04T19:36:36.312Z",
    "2020-11-04T19:42:53.456Z",
    "2020-11-04T19:47:16.038Z",
    "2020-11-04T20:02:30.249Z",
    "2020-11-04T20:11:11.777Z",
    "2020-11-04T20:19:51.752Z",
    "2020-11-04T20:36:57.750Z",
    "2020-11-04T20:41:12.386Z",
    "2020-11-04T20:47:22.963Z",
    "2020-11-04T21:02:00.193Z",
    "2020-11-04T21:20:48.387Z",
    "2020-11-04T21:30:53.607Z",
    "2020-11-04T21:40:39.685Z",
    "2020-11-04T21:45:43.648Z",
    "2020-11-04T22:14:46.373Z",
    "2020-11-04T22:21:36.531Z",
    "2020-11-04T23:01:09.186Z",
    "2020-11-04T23:16:00.304Z",
    "2020-11-04T23:46:45.510Z",
    "2020-11-04T23:50:41.482Z",
    "2020-11-05T00:16:15.690Z",
    "2020-11-05T01:03:58.062Z",
    "2020-11-05T01:22:08.485Z",
    "2020-11-05T02:07:51.083Z",
    "2020-11-05T02:37:24.295Z",
    "2020-11-05T03:16:38.965Z",
    "2020-11-05T03:21:08.291Z",
    "2020-11-05T04:01:20.730Z",
    "2020-11-05T06:01:05.838Z",
    "2020-11-05T14:01:50.971Z",
    "2020-11-05T14:20:34.146Z",
    "2020-11-05T14:40:36.884Z",
    "2020-11-05T15:11:13.143Z",
    "2020-11-05T16:53:45.563Z",
    "2020-11-05T18:42:02.059Z",
    "2020-11-05T19:11:17.978Z",
    "2020-11-05T19:31:02.217Z",
    "2020-11-05T20:01:39.880Z",
    "2020-11-05T20:22:19.687Z",
    "2020-11-05T20:50:25.026Z",
    "2020-11-05T21:06:26.014Z",
    "2020-11-05T21:45:48.474Z",
    "2020-11-05T22:11:15.693Z",
    "2020-11-05T22:46:36.477Z",
    "2020-11-05T23:18:35.972Z",
    "2020-11-05T23:56:33.767Z",
    "2020-11-06T00:46:21.725Z",
    "2020-11-06T01:19:47.638Z",
    "2020-11-06T01:32:14.168Z",
    "2020-11-06T01:50:34.550Z",
    "2020-11-06T02:11:31.520Z",
    "2020-11-06T02:21:31.704Z",
    "2020-11-06T02:35:52.691Z",
    "2020-11-06T03:16:21.224Z",
    "2020-11-06T04:31:05.425Z",
    "2020-11-06T06:22:25.319Z",
    "2020-11-06T07:39:29.874Z",
    "2020-11-06T10:27:52.923Z",
    "2020-11-06T13:35:45.935Z",
    "2020-11-06T13:48:29.269Z",
    "2020-11-06T14:11:15.160Z",
    "2020-11-06T15:38:36.840Z",
    "2020-11-06T16:26:51.267Z",
    "2020-11-06T19:10:53.677Z",
    "2020-11-06T20:15:38.653Z",
    "2020-11-06T20:30:49.849Z",
    "2020-11-06T22:01:06.237Z",
    "2020-11-06T22:26:01.785Z",
    "2020-11-06T22:36:05.403Z",
    "2020-11-06T23:41:21.474Z",
    "2020-11-06T23:51:43.357Z",
    "2020-11-07T01:56:04.188Z",
    "2020-11-07T03:01:22.232Z",
    "2020-11-07T03:46:12.440Z",
    "2020-11-07T10:07:26.578Z",
    "2020-11-07T14:56:50.997Z",
    "2020-11-07T16:35:54.408Z",
    "2020-11-07T16:41:11.130Z",
    "2020-11-07T19:10:27.892Z",
    "2020-11-07T20:50:18.177Z",
    "2020-11-07T21:25:49.074Z",
    "2020-11-07T22:52:02.482Z",
    "2020-11-07T23:06:36.960Z",
    "2020-11-08T00:17:56.017Z",
    "2020-11-08T04:34:00.719Z",
    "2020-11-08T06:10:53.434Z",
    "2020-11-08T15:52:00.876Z",
    "2020-11-08T21:06:10.082Z",
    "2020-11-08T22:49:03.807Z",
    "2020-11-09T03:23:36.199Z",
    "2020-11-09T14:45:53.028Z",
    "2020-11-09T15:51:34.108Z",
    "2020-11-09T16:31:43.216Z",
    "2020-11-09T17:11:11.335Z",
    "2020-11-09T18:56:27.420Z",
    "2020-11-09T19:31:31.903Z",
    "2020-11-09T21:31:25.014Z",
    "2020-11-09T21:35:31.553Z",
    "2020-11-09T22:44:59.607Z",
    "2020-11-09T23:44:13.151Z",
    "2020-11-10T00:22:30.984Z",
    "2020-11-10T06:03:21.729Z",
    "2020-11-10T14:57:39.075Z",
    "2020-11-10T16:18:07.613Z",
    "2020-11-10T18:52:23.461Z",
    "2020-11-10T20:13:12.724Z",
    "2020-11-10T21:30:56.943Z",
    "2020-11-10T21:45:52.979Z",
    "2020-11-10T23:31:18.839Z",
    "2020-11-11T00:16:54.249Z",
    "2020-11-11T03:01:18.012Z",
    "2020-11-11T03:16:00.804Z",
    "2020-11-11T20:31:19.396Z",
    "2020-11-11T21:50:46.218Z",
    "latest"),
  SC = c(
    "latest"),
  SD = c(
    "latest"),
  WA = c(
    "latest"),
  WV = c(
    "latest")
)

######################################################################################################

download.json <- function(base_dir, bool.download.last.only = FALSE)
{
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  for(iStateIndex in 1:length(arrStateAbbrs))
  {
    state_abbr <- arrStateAbbrs[iStateIndex]
    file_prefix <- list_file_prefixes[[state_abbr]]
    file_postfixes <- list_file_postfixes[[state_abbr]]
    
    iFirstTimestampFilePostfix <- ifelse(bool.download.last.only, length(file_postfixes), 1)
    for(iTimestampFilePostfix in iFirstTimestampFilePostfix:length(file_postfixes))
    {
      json_url <- paste0(url_template,"/",file_prefix,file_postfixes[iTimestampFilePostfix],file_extension)
      json_postfix_out <- file_postfixes[iTimestampFilePostfix]
      json_postfix_out <- gsub("T","_", json_postfix_out)
      json_postfix_out <- gsub("Z", "", json_postfix_out)
      json_postfix_out <- gsub("-","_", json_postfix_out)
      json_postfix_out <- gsub(":","_", json_postfix_out)
      json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
      json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)
      
      resp <- GET(json_url)
      if (status_code(resp) == 200)
      {
        print(paste0("Downloading JSON for ", file_prefix, " at ", file_postfixes[iTimestampFilePostfix]))
        res <- jsonlite::fromJSON(json_url)
        
        if(!dir.exists(json_path))
        {
          dir.create(json_path, recursive = T)
        }
        if(file.exists(json_path_name))
        {
          #backup_json_path_name <- paste0(json_path_name,".backup")
          #if(file.exists(backup_json_path_name))
          #{
          #  file.remove(backup_json_path_name)
          #}
          #file.rename(from = json_path_name, to = backup_json_path_name)
          file.remove(json_path_name)
        }
        jsonlite::write_json(res, path = json_path_name)
      } else
      {
        print(paste0("Skipping JSON for ", file_prefix, " at ", file_postfixes[iTimestampFilePostfix]))
      }
    }
  }
}

######################################################################################################

generate.county.csv <- function(base_dir, sid, state_abbr, file_prefix, file_postfixes)
{
  # Use primary key {locality_name, geo_id} and {uncounted_mail_ballots, votes} as the contents
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  curr_cid <- 1
  ht_county_ids <- new.env()
  df_county_ids <- data.frame(
    sid         = numeric(),
    cid         = numeric(),
    county_name = character(), # aka "locality_name"
    county_fips = character(), # aka "geo_id"
    #uncounted_mail_ballots = double(),
    #votes                  = double(),
    stringsAsFactors       = FALSE) 
  df_choices <- data.frame(
    choice_name   = character(),
    choice_weight = numeric(),
    stringsAsFactors = FALSE)
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)

    print(paste0("Generating County CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)
  
    if(length(res$county_totals) > 0)
    {
      for(iCountyTotals in 1:length(res$county_totals))
      {
        # Use primary key {locality_name, geo_id} and {uncounted_mail_ballots, votes} as the contents
        #
        #res$county_totals[[iCountyTotals]]$locality_name               # "VENANGO"
        #res$county_totals[[iCountyTotals]]$precinct_id                 # "COUNTY"
        #res$county_totals[[iCountyTotals]]$vote_type                   # "total"
        #res$county_totals[[iCountyTotals]]$results                     # list()
        #res$county_totals[[iCountyTotals]]$uncounted_mail_ballots      # 19
        #res$county_totals[[iCountyTotals]]$geo_id                      # "42121"
        #res$county_totals[[iCountyTotals]]$precinct_name               # ""
        #res$county_totals[[iCountyTotals]]$locality_fips               # "42121"
        #res$county_totals[[iCountyTotals]]$is_geographic               # false
        #res$county_totals[[iCountyTotals]]$votes                       # 0
        #res$county_totals[[iCountyTotals]]$is_reporting                # false
        #
        new_choices <- names(res$county_totals[[iCountyTotals]]$results)
        missing_choices_names <- new_choices[!(new_choices %in% df_choices$choice_name)]
        if(length(missing_choices_names) > 0)
        {
          for(choice_name in missing_choices_names)
          {
            df_choices_row <- data.frame(
              choice_name   = character(1),
              choice_weight = numeric(1),
              stringsAsFactors = FALSE)
            df_choices_row$choice_name <- choice_name
            df_choices_row$choice_weight <- 0
            df_choices <- rbind(df_choices,df_choices_row)
          }
        }
        #
        locality_name <- toupper(res$county_totals[[iCountyTotals]]$locality_name)
        if(!exists(locality_name, envir = ht_county_ids, inherits = FALSE))
        {
          ht_county_ids[[locality_name]] <- curr_cid
          df_county_ids_row <- data.frame(
            sid         = numeric(1),
            cid         = numeric(1),
            county_name = character(1), # aka "locality_name"
            county_fips = character(1), # aka "geo_id" 
            stringsAsFactors       = FALSE)
          df_county_ids_row$sid[1]         <- sid
          df_county_ids_row$cid[1]         <- curr_cid
          df_county_ids_row$county_name[1] <- locality_name
          df_county_ids_row$county_fips[1] <- res$county_totals[[iCountyTotals]]$geo_id
          df_county_ids <- rbind(df_county_ids, df_county_ids_row)
          curr_cid <- curr_cid + 1
        } # END if(!exists(locality_name, envir = ht_county_ids, inherits = FALSE))
      } # END for(iCountyTotals in 1:length(res$county_totals))
    } # END if(length(res$county_totals) > 0)
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))
  df_county_ids <- df_county_ids[order(df_county_ids$county_name),]
  write.csv(x = df_county_ids, file = paste0(csv_path,"/",state_abbr,"_county",".csv"), row.names = FALSE)
  return (list(ht_county_ids = ht_county_ids, df_county_ids = df_county_ids, df_choices = df_choices))
}

generate.county.vote.type.csv <- function(base_dir, sid, state_abbr, file_prefix, file_postfixes,
                                          ht_county_ids, df_county_ids, df_choices)
{
  # Use primary key {locality_name, geo_id, vote_type} and {votes, bidenj, trumpd, jorgensenj} as the contents
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  #
  curr_cid <- 1
  for(locality_name in names(ht_county_ids))
  {
    if(curr_cid < ht_county_ids[[locality_name]])
    {
      curr_cid <- ht_county_ids[[locality_name]]
    }
  }
  curr_cid <- curr_cid + 1
  #
  curr_vid <- 1
  ht_vote_type_ids <- new.env()
  df_vote_type_ids <- data.frame(
    sid                    = numeric(),
    vid                    = numeric(),
    vote_type              = character(),
    stringsAsFactors       = FALSE) 
  ht_county_vote_type_ids <- new.env()
  ht_locality_name_vote_type_ids <- new.env()
  df_county_vote_type_ids <- data.frame(
    sid             = numeric(),
    cid             = numeric(),
    vid             = numeric(),
    county_name     = character(), # aka "locality_name"
    vote_type       = character(),
    county_fips     = character(), # aka "geo_id"
    #is_geographic  = logical(),
    #votes          = double(),
    #bidenj         = double(),
    #trumpd         = double(),
    #jorgensenj     = double(),
    stringsAsFactors = FALSE) 
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)

    print(paste0("Generating County by Vote Type CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)
    if(length(res$county_by_vote_type) > 0)
    {
      for(iCountyByVoteType in 1:length(res$county_by_vote_type))
      {
        # Use primary key {locality_name, geo_id, vote_type} and {votes, bidenj, trumpd, jorgensenj} as the contents
        #
        #res$county_by_vote_type[[iCountyByVoteType]]$precinct_id         # "COUNTY"
        #res$county_by_vote_type[[iCountyByVoteType]]$locality_name       # "ARMSTRONG"
        #res$county_by_vote_type[[iCountyByVoteType]]$results$bidenj      # 0
        #res$county_by_vote_type[[iCountyByVoteType]]$results$trumpd      # 0
        #res$county_by_vote_type[[iCountyByVoteType]]$results$jorgensenj  # 0
        #res$county_by_vote_type[[iCountyByVoteType]]$vote_type           # "provisional"
        #res$county_by_vote_type[[iCountyByVoteType]]$geo_id              # "42005"
        #res$county_by_vote_type[[iCountyByVoteType]]$precinct_name       # ""
        #res$county_by_vote_type[[iCountyByVoteType]]$locality_fips       # "42005"
        #res$county_by_vote_type[[iCountyByVoteType]]$is_geographic       # false
        #res$county_by_vote_type[[iCountyByVoteType]]$votes               # 0
        #res$county_by_vote_type[[iCountyByVoteType]]$is_reporting        # false
        #
        new_choices <- names(res$county_by_vote_type[[iCountyByVoteType]]$results)
        missing_choices_names <- new_choices[!(new_choices %in% df_choices$choice_name)]
        if(length(missing_choices_names) > 0)
        {
          for(choice_name in missing_choices_names)
          {
            df_choices_row <- data.frame(
              choice_name   = character(1),
              choice_weight = numeric(1),
              stringsAsFactors = FALSE)
            df_choices_row$choice_name <- choice_name
            df_choices_row$choice_weight <- 0
            df_choices <- rbind(df_choices,df_choices_row)
          }
        }
        #
        locality_name <- toupper(res$county_by_vote_type[[iCountyByVoteType]]$locality_name)
        vote_type <- res$county_by_vote_type[[iCountyByVoteType]]$vote_type
        locality_name__vote_type <- paste0(locality_name, "|", vote_type)
        #
        if(!exists(locality_name, envir = ht_county_ids, inherits = FALSE))
        {
          ht_county_ids[[locality_name]] <- curr_cid
          df_county_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            county_name      = character(1),
            county_fips      = character(1),
            stringsAsFactors = FALSE)
          df_county_ids_row$sid[1]         <- sid
          df_county_ids_row$cid[1]         <- curr_cid
          df_county_ids_row$county_name[1] <- locality_name
          df_county_ids_row$county_fips[1] <- res$county_by_vote_type[[iCountyTotals]]$geo_id
          df_county_ids <- rbind(df_county_ids, df_county_ids_row)
          curr_cid <- curr_cid + 1
          # warning("Found new county ID at the second stage.")
        }
        #
        if(!exists(vote_type, envir = ht_vote_type_ids, inherits = FALSE))
        {
          ht_vote_type_ids[[vote_type]] <- curr_vid
          df_vote_type_ids_row <- data.frame(
            sid                    = numeric(1),
            vid                    = numeric(1),
            vote_type              = character(1),
            stringsAsFactors       = FALSE) 
          df_vote_type_ids_row$sid       <- sid
          df_vote_type_ids_row$vid       <- curr_vid
          df_vote_type_ids_row$vote_type <- res$county_by_vote_type[[iCountyByVoteType]]$vote_type
          df_vote_type_ids <- rbind(df_vote_type_ids, df_vote_type_ids_row)
          curr_vid <- curr_vid + 1
        }
        #
        if(!exists(locality_name__vote_type, envir = ht_locality_name_vote_type_ids, inherits = FALSE))
        {
          ht_locality_name_vote_type_ids[[locality_name__vote_type]] <- 1
          df_county_vote_type_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            vid              = numeric(1),
            county_name      = character(1), # aka "locality_name"
            vote_type        = character(1),
            county_fips      = character(1), # aka "geo_id"
            stringsAsFactors = FALSE)
          #
          df_county_vote_type_ids_row$sid[1]         <- sid
          df_county_vote_type_ids_row$cid[1]         <- ht_county_ids[[locality_name]]
          df_county_vote_type_ids_row$vid[1]         <- ht_vote_type_ids[[vote_type]]
          df_county_vote_type_ids_row$county_name[1] <- locality_name
          df_county_vote_type_ids_row$vote_type[1]   <- res$county_by_vote_type[[iCountyByVoteType]]$vote_type
          df_county_vote_type_ids_row$county_fips[1] <- res$county_by_vote_type[[iCountyByVoteType]]$geo_id
          #
          df_county_vote_type_ids <- rbind(df_county_vote_type_ids, df_county_vote_type_ids_row)
        } # END if(!exists(locality_name__vote_type, envir = ht_vote_type_ids, inherits = FALSE))
      } # END for(iCountyByVoteType in 1:length(res$county_by_vote_type))
    } # END if(length(res$county_by_vote_type) > 0)
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))
  #
  df_vote_type_ids <- df_vote_type_ids[order(df_vote_type_ids$vote_type),]
  df_county_ids <- df_county_ids[order(df_county_ids$county_name),]
  df_county_vote_type_ids <- df_county_vote_type_ids[order(df_county_vote_type_ids$county_name,
                                                           df_county_vote_type_ids$vote_type),]
  #
  write.csv(x = df_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_vote_type",".csv"), row.names = FALSE)
  write.csv(x = df_county_ids, file = paste0(csv_path,"/",state_abbr,"_county",".csv"), row.names = FALSE)
  write.csv(x = df_county_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_county_vote_type",".csv"), row.names = FALSE)
  #
  return (list(ht_county_ids = ht_county_ids, df_county_ids = df_county_ids,
               ht_vote_type_ids = ht_vote_type_ids, df_vote_type_ids = df_vote_type_ids,
               df_choices = df_choices))
}

generate.precinct.csv <- function(base_dir, sid, state_abbr, file_prefix, file_postfixes,
                                  ht_county_ids, df_county_ids, df_choices)
{
  # Use primary key {locality_name, precinct_id} and {votes, bidenj, trumpd, jorgensenj, other} as the contents
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  curr_pid <- 1
  ht_precinct_ids <- new.env()
  df_precinct_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    pid              = numeric(),
    county_name      = character(), # aka "locality_name"
    precinct_id      = character(),
    county_fips      = character(), # aka "locality_fips"
    precinct_geo_id  = character(), # aka "geo_id"
    precinct_name    = character(),
    #is_geographic   = logical(),
    #is_reporting    = logical(),
    #votes           = double(),
    #bidenj          = double(),
    #trumpd          = double(),
    #jorgensenj      = double(),
    #other           = double(),
    stringsAsFactors = FALSE) 
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)
    
    print(paste0("Generating Precinct CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)

    if(length(res$precinct_totals) > 0)
    {
      for(iPrecinctTotals in 1:length(res$precinct_totals))
      {
        # Use primary key {locality_name, precinct_id} and {votes, bidenj, trumpd, jorgensenj, other} as the contents
        #
        #res$precinct_totals[[iPrecinctTotals]]$locality_name               # "Cambria"
        #res$precinct_totals[[iPrecinctTotals]]$precinct_id                 # "Allegheny Township Voting Precinct"
        #res$precinct_totals[[iPrecinctTotals]]$results$bidenj              # 205
        #res$precinct_totals[[iPrecinctTotals]]$results$trumpd              # 779
        #res$precinct_totals[[iPrecinctTotals]]$results$jorgensenj          # 7
        #res$precinct_totals[[iPrecinctTotals]]$results$other               # 1
        #res$precinct_totals[[iPrecinctTotals]]$vote_type                   # "total"
        #res$precinct_totals[[iPrecinctTotals]]$geo_id                      # "42021-ALLEGHENY TWP"
        #res$precinct_totals[[iPrecinctTotals]]$precinct_name               # "ALLEGHENY TWP"
        #res$precinct_totals[[iPrecinctTotals]]$locality_fips               # "42021"
        #res$precinct_totals[[iPrecinctTotals]]$is_geographic               # true
        #res$precinct_totals[[iPrecinctTotals]]$votes                       # 992
        #res$precinct_totals[[iPrecinctTotals]]$is_reporting                # true
        #
        new_choices <- names(res$precinct_totals[[iPrecinctTotals]]$results)
        missing_choices_names <- new_choices[!(new_choices %in% df_choices$choice_name)]
        if(length(missing_choices_names) > 0)
        {
          for(choice_name in missing_choices_names)
          {
            df_choices_row <- data.frame(
              choice_name   = character(1),
              choice_weight = numeric(1),
              stringsAsFactors = FALSE)
            df_choices_row$choice_name <- choice_name
            df_choices_row$choice_weight <- 0
            df_choices <- rbind(df_choices,df_choices_row)
          }
        }
        #
        locality_name <- toupper(res$precinct_totals[[iPrecinctTotals]]$locality_name)
        locality_name__precinct_id <- paste0(locality_name, "|", res$precinct_totals[[iPrecinctTotals]]$precinct_id)
        if(!exists(locality_name__precinct_id, envir = ht_precinct_ids, inherits = FALSE))
        {
          ht_precinct_ids[[locality_name__precinct_id]] <- curr_pid
          df_precinct_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            pid              = numeric(1),
            county_name      = character(1),
            precinct_id      = character(1),
            county_fips      = character(1),
            precinct_geo_id  = character(1),
            precinct_name    = character(1),
            stringsAsFactors = FALSE)
          df_precinct_ids_row$sid[1]             <- sid
          df_precinct_ids_row$cid[1]             <- ht_county_ids[[locality_name]]
          df_precinct_ids_row$pid[1]             <- curr_pid
          df_precinct_ids_row$county_name[1]     <- locality_name
          df_precinct_ids_row$precinct_id[1]     <- res$precinct_totals[[iPrecinctTotals]]$precinct_id
          df_precinct_ids_row$county_fips[1]     <- res$precinct_totals[[iPrecinctTotals]]$locality_fips
          df_precinct_ids_row$precinct_geo_id[1] <- res$precinct_totals[[iPrecinctTotals]]$geo_id
          df_precinct_ids_row$precinct_name[1]   <- res$precinct_totals[[iPrecinctTotals]]$precinct_name

          df_precinct_ids <- rbind(df_precinct_ids, df_precinct_ids_row)
          curr_pid <- curr_pid + 1
        } # END if(!exists(locality_name__precinct_id, envir = ht_precinct_ids, inherits = FALSE))
      } # END for(iPrecinctTotals in 1:length(res$precinct_totals))
    } # END if(length(res$precinct_totals) > 0)
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))
  df_precinct_ids <- df_precinct_ids[order(df_precinct_ids$county_name, df_precinct_ids$precinct_id),]
  write.csv(x = df_precinct_ids, file = paste0(csv_path,"/",state_abbr,"_precinct",".csv"), row.names = FALSE)
  lst_precinct_ids <- list(ht_county_ids = ht_county_ids, df_county_ids = df_county_ids,
                           ht_precinct_ids = ht_precinct_ids, df_precinct_ids = df_precinct_ids,
                           df_choices = df_choices)
  return(lst_precinct_ids)
}

generate.precinct.vote.type.csv <- function(base_dir, sid, state_abbr, file_prefix, file_postfixes,
                                            ht_county_ids, df_county_ids,
                                            ht_precinct_ids, df_precinct_ids,
                                            ht_vote_type_ids, df_vote_type_ids,
                                            df_choices)
{
  # Use primary key {locality_name, precinct_id, vote_type} and {votes, bidenj, trumpd, jorgensenj, other} as the contents
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  curr_cid <- 1
  for(locality_name in names(ht_county_ids))
  {
    if(curr_cid < ht_county_ids[[locality_name]])
    {
      curr_cid <- ht_county_ids[[locality_name]]
    }
  }
  curr_cid <- curr_cid + 1
  #
  curr_pid <- 1
  for(locality_name__precinct_id in names(ht_precinct_ids))
  {
    if(curr_pid < ht_precinct_ids[[locality_name__precinct_id]])
    {
      curr_pid <- ht_precinct_ids[[locality_name__precinct_id]]
    }
  }
  curr_pid <- curr_pid + 1
  #
  curr_vid <- 1
  for(vote_type_id in names(ht_vote_type_ids))
  {
    if(curr_vid < ht_vote_type_ids[[vote_type_id]])
    {
      curr_vid <- ht_vote_type_ids[[vote_type_id]]
    }
  }
  curr_vid <- curr_vid + 1
  #
  ht_locality_name_precinct_id_vote_type_ids <- new.env()
  df_precinct_vote_type_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    pid              = numeric(),
    vid              = numeric(),
    county_name      = character(), # aka "locality_name"
    precinct_id      = character(),
    vote_type        = character(),
    county_fips      = character(), # aka "locality_fips"
    precinct_geo_id  = character(), # aka "geo_id"
    precinct_name    = character(),
    #is_geographic   = logical(),
    #votes           = double(),
    #bidenj          = double(),
    #trumpd          = double(),
    #jorgensenj      = double(),
    stringsAsFactors = FALSE) 
  time_origin_ms <- .Machine$double.xmax
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    str_snapshot_timestamp <- file_postfixes[iTimestampFilePostfix] # e.g. "2020-11-03T23:40:53.084Z" or 1604475653084
    if(str_snapshot_timestamp != "latest")
    {
      num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
    } else
    {
      num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_latest_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
    }
    time_origin_ms <- ifelse(num_snapshot_timestamp_ms < time_origin_ms, num_snapshot_timestamp_ms, time_origin_ms)
    #
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)
    
    print(paste0("Generating Precinct by Vote Type CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)
    if(length(res$precinct_by_vote_type) > 0)
    {
      for(iPrecinctByVoteType in 1:length(res$precinct_by_vote_type))
      {
        # Use primary key {locality_name, geo_id, vote_type} and {votes, bidenj, trumpd, jorgensenj, other} as the contents
        #
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_id        # "ASPINWALL DIST 1"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$locality_name      # "Allegheny"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$is_reporting       # true
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$results$bidenj     # 105
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$results$trumpd     # 13
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$results$jorgensenj # 2
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$results$other      # 2
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$vote_type          # "absentee"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$geo_id             # "42003-ASPINWALL 1"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_name      # "ASPINWALL 1"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$locality_fips      # "42003"
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$is_geographic      # true
        #res$precinct_by_vote_type[[iPrecinctByVoteType]]$votes              # 122
        #
        new_choices <- names(res$precinct_by_vote_type[[iPrecinctByVoteType]]$results)
        missing_choices_names <- new_choices[!(new_choices %in% df_choices$choice_name)]
        if(length(missing_choices_names) > 0)
        {
          for(choice_name in missing_choices_names)
          {
            df_choices_row <- data.frame(
              choice_name   = character(1),
              choice_weight = numeric(1),
              stringsAsFactors = FALSE)
            df_choices_row$choice_name <- choice_name
            df_choices_row$choice_weight <- 0
            df_choices <- rbind(df_choices,df_choices_row)
          }
        }
        if(iTimestampFilePostfix == length(file_postfixes))
        {
          for(choice_name in df_choices$choice_name)
          {
            if(choice_name %in% names(res$precinct_by_vote_type[[iPrecinctByVoteType]]$results))
            {
              df_choices$choice_weight[df_choices$choice_name == choice_name] <-
                df_choices$choice_weight[df_choices$choice_name == choice_name] +
                res$precinct_by_vote_type[[iPrecinctByVoteType]]$results[[choice_name]]
            }
          }
        }
        #
        locality_name <- toupper(res$precinct_by_vote_type[[iPrecinctByVoteType]]$locality_name)
        precinct_id <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_id
        if("vote_type" %in% names(res$precinct_by_vote_type[[iPrecinctByVoteType]]))
        {
          vote_type <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$vote_type
        } else
        {
          vote_type <- "unknown"
        }
        locality_name__precinct_id__vote_type <- paste0(locality_name, "|",
                                                        res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_id, "|",
                                                        vote_type)
        locality_name__precinct_id <- paste0(locality_name, "|",
                                             res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_id)
        if("locality_fips" %in% names(res$precinct_by_vote_type[[iPrecinctByVoteType]]))
        {
          locality_fips <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$locality_fips
        } else
        {
          locality_fips <- ""
        }
        if("geo_id" %in% names(res$precinct_by_vote_type[[iPrecinctByVoteType]]))
        {
          geo_id <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$geo_id
        } else
        {
          geo_id <- ""
        }
        if("precinct_name" %in% names(res$precinct_by_vote_type[[iPrecinctByVoteType]]))
        {
          precinct_name <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_name
        } else
        {
          precinct_name <- ""
        }
        #
        if(!exists(vote_type, envir = ht_vote_type_ids, inherits = FALSE))
        {
          ht_vote_type_ids[[vote_type]] <- curr_vid
          df_vote_type_ids_row <- data.frame(
            sid                    = numeric(1),
            vid                    = numeric(1),
            vote_type              = character(1),
            stringsAsFactors       = FALSE) 
          df_vote_type_ids_row$sid       <- sid
          df_vote_type_ids_row$vid       <- curr_vid
          df_vote_type_ids_row$vote_type <- vote_type
          df_vote_type_ids <- rbind(df_vote_type_ids, df_vote_type_ids_row)
          curr_vid <- curr_vid + 1
          # warning("Found new vote type ID at the fourth stage.")
        }
        #
        if(!exists(locality_name, envir = ht_county_ids, inherits = FALSE))
        {
          ht_county_ids[[locality_name]] <- curr_cid
          df_county_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            county_name      = character(1),
            county_fips      = character(1),
            stringsAsFactors = FALSE)
          df_county_ids_row$sid[1]         <- sid
          df_county_ids_row$cid[1]         <- curr_cid
          df_county_ids_row$county_name[1] <- locality_name
          df_county_ids_row$county_fips[1] <- geo_id
          df_county_ids <- rbind(df_county_ids, df_county_ids_row)
          curr_cid <- curr_cid + 1
          #warning("Found new county ID at the fourth stage.")
        }
        #
        if(!exists(locality_name__precinct_id, envir = ht_precinct_ids, inherits = FALSE))
        {
          ht_precinct_ids[[locality_name__precinct_id]] <- curr_pid
          df_precinct_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            pid              = numeric(1),
            county_name      = character(1),
            precinct_id      = character(1),
            county_fips      = character(1),
            precinct_geo_id  = character(1),
            precinct_name    = character(1),
            stringsAsFactors = FALSE)
          df_precinct_ids_row$sid[1]             <- sid
          df_precinct_ids_row$cid[1]             <- ht_county_ids[[locality_name]]
          df_precinct_ids_row$pid[1]             <- curr_pid
          df_precinct_ids_row$county_name[1]     <- locality_name
          df_precinct_ids_row$precinct_id[1]     <- precinct_id
          df_precinct_ids_row$county_fips[1]     <- locality_fips
          df_precinct_ids_row$precinct_geo_id[1] <- geo_id
          df_precinct_ids_row$precinct_name[1]   <- precinct_name
          
          df_precinct_ids <- rbind(df_precinct_ids, df_precinct_ids_row)
          curr_pid <- curr_pid + 1
          # warning("Found new precinct ID at the fourth stage.")
        } # END if(!exists(locality_name__precinct_id, envir = ht_precinct_ids, inherits = FALSE))
        #
        if(!exists(locality_name__precinct_id__vote_type, envir = ht_locality_name_precinct_id_vote_type_ids, inherits = FALSE))
        {
          ht_locality_name_precinct_id_vote_type_ids[[locality_name__precinct_id__vote_type]] <- 1
          df_precinct_vote_type_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            pid              = numeric(1),
            vid              = numeric(1),
            county_name      = character(1),
            precinct_id      = character(1),
            vote_type        = character(1),
            county_fips      = character(1),
            precinct_geo_id  = character(1),
            precinct_name    = character(1),
            stringsAsFactors = FALSE)
          #
          df_precinct_vote_type_ids_row$sid[1]             <- sid
          df_precinct_vote_type_ids_row$cid[1]             <- ht_county_ids[[locality_name]]
          df_precinct_vote_type_ids_row$pid[1]             <- ht_precinct_ids[[locality_name__precinct_id]]
          df_precinct_vote_type_ids_row$vid[1]             <- ht_vote_type_ids[[vote_type]]
          df_precinct_vote_type_ids_row$county_name[1]     <- locality_name
          df_precinct_vote_type_ids_row$precinct_id[1]     <- res$precinct_by_vote_type[[iPrecinctByVoteType]]$precinct_id
          df_precinct_vote_type_ids_row$vote_type[1]       <- vote_type
          df_precinct_vote_type_ids_row$county_fips[1]     <- locality_fips
          df_precinct_vote_type_ids_row$precinct_geo_id[1] <- geo_id
          df_precinct_vote_type_ids_row$precinct_name[1]   <- precinct_name
          #
          df_precinct_vote_type_ids <- rbind(df_precinct_vote_type_ids, df_precinct_vote_type_ids_row)
        } # END if(!exists(locality_name__precinct_id__vote_type, envir = ht_locality_name_precinct_id_vote_type_ids, inherits = FALSE))
      } # END for(iPrecinctByVoteType in 1:length(res$precinct_by_vote_type))
    } # END if(length(res$precinct_by_vote_type) > 0)
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))

  if(time_origin_ms == .Machine$double.xmax)
  {
    time_origin_ms <- round(as.numeric(strptime(str_latest_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
  }
  
  #
  df_vote_type_ids <- df_vote_type_ids[order(df_vote_type_ids$vote_type),]
  df_county_ids <- df_county_ids[order(df_county_ids$county_name),]
  df_precinct_ids <- df_precinct_ids[order(df_precinct_ids$county_name,df_precinct_ids$precinct_id),]
  df_precinct_vote_type_ids <- df_precinct_vote_type_ids[order(df_precinct_vote_type_ids$county_name,
                                                               df_precinct_vote_type_ids$precinct_id,
                                                               df_precinct_vote_type_ids$vote_type),]
  df_choices <- df_choices[order(-df_choices$choice_weight),]
  #
  write.csv(x = df_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_vote_type",".csv"), row.names = FALSE)
  write.csv(x = df_county_ids, file = paste0(csv_path,"/",state_abbr,"_county",".csv"), row.names = FALSE)
  write.csv(x = df_precinct_ids, file = paste0(csv_path,"/",state_abbr,"_precinct",".csv"), row.names = FALSE)
  write.csv(x = df_precinct_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type",".csv"), row.names = FALSE)
  #
  return (list(ht_county_ids = ht_county_ids, df_county_ids = df_county_ids,
               ht_precinct_ids = ht_precinct_ids, df_precinct_ids = df_precinct_ids,
               ht_vote_type_ids = ht_vote_type_ids, df_vote_type_ids = df_vote_type_ids,
               time_origin_ms = time_origin_ms, df_choices = df_choices))
}

generate.precinct.csv2 <- function(base_dir, sid, state_abbr, file_prefix, file_postfixes)
{
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  curr_cid <- 1
  curr_pid <- 1
  curr_vid <- 1
  #
  ht_vote_type_ids <- new.env()
  df_vote_type_ids <- data.frame(
    sid              = numeric(),
    vid              = numeric(),
    vote_type        = character(),
    stringsAsFactors = FALSE) 
  #
  ht_county_ids <- new.env()
  df_county_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    county_name      = character(), # aka "locality_name"
    county_fips      = character(), # aka "locality_fips"
    stringsAsFactors = FALSE) 
  #
  ht_precinct_ids <- new.env()
  df_precinct_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    pid              = numeric(),
    county_name      = character(), # aka "locality_name"
    precinct_id      = character(),
    county_fips      = character(), # aka "locality_fips"
    precinct_geo_id  = character(), # aka "geo_id"
    precinct_name    = character(),
    stringsAsFactors = FALSE) 
  #
  ht_county_vote_type_ids <- new.env()
  df_county_vote_type_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    vid              = numeric(),
    county_name      = character(), # aka "locality_name"
    vote_type        = character(),
    county_fips      = character(), # aka "locality_fips"
    stringsAsFactors = FALSE) 
  #
  ht_precinct_vote_type_ids <- new.env()
  df_precinct_vote_type_ids <- data.frame(
    sid              = numeric(),
    cid              = numeric(),
    pid              = numeric(),
    vid              = numeric(),
    county_name      = character(), # aka "locality_name"
    precinct_id      = character(),
    vote_type        = character(),
    county_fips      = character(), # aka "locality_fips"
    precinct_geo_id  = character(), # aka "geo_id"
    precinct_name    = character(),
    # votes          = numeric(),
    # blankenshipd   = numeric(),
    # trumpd	       = numeric(),
    # hawkinsh	     = numeric(),
    # jorgensenj	   = numeric(),
    # bidenj	       = numeric(),
    # other	         = numeric(),
    # de_la_fuenter  = numeric(),
    stringsAsFactors = FALSE)
  time_origin_ms <- .Machine$double.xmax
  df_choices <- data.frame(
    choice_name   = character(),
    choice_weight = numeric(),
    stringsAsFactors = FALSE)
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    str_snapshot_timestamp <- file_postfixes[iTimestampFilePostfix] # e.g. "2020-11-03T23:40:53.084Z" or 1604475653084
    if(str_snapshot_timestamp != "latest")
    {
      num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
    } else
    {
      num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_latest_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
    }
    time_origin_ms <- ifelse(num_snapshot_timestamp_ms < time_origin_ms, num_snapshot_timestamp_ms, time_origin_ms)
    #
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)
    
    print(paste0("Generating Precinct by Vote Types CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)
    
    if(length(res$precincts) > 0)
    {
      for(iPrecincts in 1:length(res$precincts))
      {
        # Use primary key {locality_name, precinct_id, vote_type} and {votes, bidenj, trumpd, jorgensenj, blankenshipd, hawkinsh, de_la_fuenter, other} as the contents
        #
        new_choices <- names(res$precincts[[iPrecincts]]$results)
        missing_choices_names <- new_choices[!(new_choices %in% df_choices$choice_name)]
        if(length(missing_choices_names) > 0)
        {
          for(choice_name in missing_choices_names)
          {
            df_choices_row <- data.frame(
              choice_name   = character(1),
              choice_weight = numeric(1),
              stringsAsFactors = FALSE)
            df_choices_row$choice_name <- choice_name
            df_choices_row$choice_weight <- 0
            df_choices <- rbind(df_choices,df_choices_row)
          }
        }
        if(iTimestampFilePostfix == length(file_postfixes))
        {
          for(choice_name in df_choices$choice_name)
          {
            if(choice_name %in% names(res$precincts[[iPrecincts]]$results))
            {
              df_choices$choice_weight[df_choices$choice_name == choice_name] <-
                df_choices$choice_weight[df_choices$choice_name == choice_name] +
                res$precincts[[iPrecincts]]$results[[choice_name]]
            }
          }
        }
        #
        if("vote_type" %in% names(res$precincts[[iPrecincts]]))
        {
          vote_type     <- res$precincts[[iPrecincts]]$vote_type
        } else
        {
          vote_type <- "unknown"
        }
        locality_name <- toupper(res$precincts[[iPrecincts]]$locality_name)
        precinct_id   <- res$precincts[[iPrecincts]]$precinct_id
        if("locality_fips" %in% names(res$precincts[[iPrecincts]]))
        {
          locality_fips     <- res$precincts[[iPrecincts]]$locality_fips
        } else
        {
          locality_fips <- "unknown"
        }
        if("geo_id" %in% names(res$precincts[[iPrecincts]]))
        {
          geo_id     <- res$precincts[[iPrecincts]]$geo_id
        } else
        {
          geo_id <- "unknown"
        }
        if("precinct_name" %in% names(res$precincts[[iPrecincts]]))
        {
          precinct_name     <- res$precincts[[iPrecincts]]$precinct_name
        } else
        {
          precinct_name <- "unknown"
        }
        locality_name__vote_type   <- paste0(locality_name, "|", vote_type)
        locality_name__precinct_id <- paste0(locality_name, "|", precinct_id)
        locality_name__precinct_id__vote_type <- paste0(locality_name, "|", precinct_id, "|", vote_type)

        if(!exists(vote_type, envir = ht_vote_type_ids, inherits = FALSE))
        {
          ht_vote_type_ids[[vote_type]] <- curr_vid
          df_vote_type_ids_row <- data.frame(
            sid              = numeric(1),
            vid              = numeric(1),
            vote_type        = character(1),
            stringsAsFactors = FALSE)
          df_vote_type_ids_row$sid[1]           <- sid
          df_vote_type_ids_row$vid[1]           <- curr_vid
          df_vote_type_ids_row$vote_type[1]     <- vote_type
          df_vote_type_ids <- rbind(df_vote_type_ids, df_vote_type_ids_row)
          curr_vid <- curr_vid + 1
        }
        if(!exists(locality_name, envir = ht_county_ids, inherits = FALSE))
        {
          ht_county_ids[[locality_name]] <- curr_cid
          df_county_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            county_name      = character(1),
            county_fips      = character(1),
            stringsAsFactors = FALSE)
          df_county_ids_row$sid[1]         <- sid
          df_county_ids_row$cid[1]         <- curr_cid
          df_county_ids_row$county_name[1] <- locality_name
          df_county_ids_row$county_fips[1] <- locality_fips
          df_county_ids <- rbind(df_county_ids, df_county_ids_row)
          curr_cid <- curr_cid + 1
        }
        if(!exists(locality_name__precinct_id, envir = ht_precinct_ids, inherits = FALSE))
        {
          ht_precinct_ids[[locality_name__precinct_id]] <- curr_pid
          df_precinct_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            pid              = numeric(1),
            county_name      = character(1),
            precinct_id      = character(1),
            county_fips      = character(1),
            precinct_geo_id  = character(1),
            precinct_name    = character(1),
            stringsAsFactors = FALSE)
          df_precinct_ids_row$sid[1]             <- sid
          df_precinct_ids_row$cid[1]             <- ht_county_ids[[locality_name]]
          df_precinct_ids_row$pid[1]             <- curr_pid
          df_precinct_ids_row$county_name[1]     <- locality_name
          df_precinct_ids_row$precinct_id[1]     <- precinct_id
          df_precinct_ids_row$county_fips[1]     <- locality_fips
          df_precinct_ids_row$precinct_geo_id[1] <- geo_id
          df_precinct_ids_row$precinct_name[1]   <- precinct_name
          df_precinct_ids <- rbind(df_precinct_ids, df_precinct_ids_row)
          curr_pid <- curr_pid + 1
        }
        if(!exists(locality_name__vote_type, envir = ht_county_vote_type_ids, inherits = FALSE))
        {
          ht_county_vote_type_ids[[locality_name__vote_type]] <- 1
          df_county_vote_type_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            vid              = numeric(1),
            county_name      = character(1),
            vote_type        = character(1),
            county_fips      = character(1),
            stringsAsFactors = FALSE) 
          df_county_vote_type_ids_row$sid[1]         <- sid
          df_county_vote_type_ids_row$cid[1]         <- ht_county_ids[[locality_name]]
          df_county_vote_type_ids_row$vid[1]         <- ht_vote_type_ids[[vote_type]]
          df_county_vote_type_ids_row$county_name[1] <- locality_name
          df_county_vote_type_ids_row$vote_type[1]   <- vote_type
          df_county_vote_type_ids_row$county_fips[1] <- locality_fips
          df_county_vote_type_ids <- rbind(df_county_vote_type_ids, df_county_vote_type_ids_row)
        }
        if(!exists(locality_name__precinct_id__vote_type, envir = ht_precinct_vote_type_ids, inherits = FALSE))
        {
          ht_precinct_vote_type_ids[[locality_name__precinct_id__vote_type]] <- 1
          df_precinct_vote_type_ids_row <- data.frame(
            sid              = numeric(1),
            cid              = numeric(1),
            pid              = numeric(1),
            vid              = numeric(1),
            county_name      = character(1),
            precinct_id      = character(1),
            vote_type        = character(1),
            county_fips      = character(1),
            precinct_geo_id  = character(1),
            precinct_name    = character(1),
            stringsAsFactors = FALSE)
          df_precinct_vote_type_ids_row$sid[1]             <- sid
          df_precinct_vote_type_ids_row$cid[1]             <- ht_county_ids[[locality_name]]
          df_precinct_vote_type_ids_row$pid[1]             <- ht_precinct_ids[[locality_name__precinct_id]]
          df_precinct_vote_type_ids_row$vid[1]             <- ht_vote_type_ids[[vote_type]]
          df_precinct_vote_type_ids_row$county_name[1]     <- locality_name
          df_precinct_vote_type_ids_row$precinct_id[1]     <- precinct_id
          df_precinct_vote_type_ids_row$vote_type[1]       <- vote_type
          df_precinct_vote_type_ids_row$county_fips[1]     <- locality_fips
          df_precinct_vote_type_ids_row$precinct_geo_id[1] <- geo_id
          df_precinct_vote_type_ids_row$precinct_name[1]   <- precinct_name
          df_precinct_vote_type_ids <- rbind(df_precinct_vote_type_ids, df_precinct_vote_type_ids_row)
        }
      } # END for(iPrecincts in 1:length(res$precincts))
    } # END if(length(res$precincts) > 0)
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))

  if(time_origin_ms == .Machine$double.xmax)
  {
    time_origin_ms <- round(as.numeric(strptime(str_latest_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
  }
  
  df_county_ids <- df_county_ids[order(df_county_ids$county_name),]
  df_precinct_ids <- df_precinct_ids[order(
    df_precinct_ids$county_name,
    df_precinct_ids$precinct_id),]
  df_vote_type_ids <- df_vote_type_ids[order(df_vote_type_ids$vote_type),]
  df_precinct_vote_type_ids <- df_precinct_vote_type_ids[order(
    df_precinct_vote_type_ids$county_name,
    df_precinct_vote_type_ids$precinct_id,
    df_precinct_vote_type_ids$vote_type),]
  df_choices <- df_choices[order(-df_choices$choice_weight),]
  
  write.csv(x = df_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_vote_type",".csv"), row.names = FALSE)
  write.csv(x = df_county_ids, file = paste0(csv_path,"/",state_abbr,"_county",".csv"), row.names = FALSE)
  write.csv(x = df_precinct_ids, file = paste0(csv_path,"/",state_abbr,"_precinct",".csv"), row.names = FALSE)
  write.csv(x = df_county_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_county_vote_type",".csv"), row.names = FALSE)
  write.csv(x = df_precinct_vote_type_ids, file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type",".csv"), row.names = FALSE)

  return (list(
    ht_vote_type_ids = ht_vote_type_ids, df_vote_type_ids = df_vote_type_ids,
    ht_county_ids = ht_county_ids, df_county_ids = df_county_ids,
    ht_precinct_ids = ht_precinct_ids, df_precinct_ids = df_precinct_ids,
    df_county_vote_type_ids = df_county_vote_type_ids,
    df_precinct_vote_type_ids = df_precinct_vote_type_ids,
    time_origin_ms = time_origin_ms, df_choices = df_choices))
}

generate.precinct.votes.csv <- function(base_dir, time_origin_ms, sid, state_abbr,file_prefix,
                                        file_postfixes, ht_vote_type_ids, ht_county_ids, ht_precinct_ids,
                                        df_choices, negligible.choice.fraction.upper.threshold)
{
  json_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts")
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  df_choices_major <- df_choices[df_choices$choice_weight / sum(df_choices$choice_weight) >=
                                   negligible.choice.fraction.upper.threshold,]
  df_choices_minor <- df_choices[df_choices$choice_weight / sum(df_choices$choice_weight) <
                                   negligible.choice.fraction.upper.threshold,]
  if(nrow(df_choices_minor) > 0)
  {
    df_choices_major <- rbind(df_choices_major, data.frame(choice_name = "others",
                                choice_weight = sum(df_choices_minor$choice_weight), stringsAsFactors = FALSE))
  }
  for(iTimestampFilePostfix in 1:length(file_postfixes))
  {
    str_snapshot_timestamp <- file_postfixes[iTimestampFilePostfix] # e.g. "2020-11-03T23:40:53.084Z" or 1604475653084
    if(str_snapshot_timestamp != "latest")
    {
      num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
    } else
    {
      #if(length(file_postfixes) > 1)
      #{
      #  str_snapshot_timestamp_prev <- file_postfixes[iTimestampFilePostfix - 1]
      #  str_snapshot_timestamp_prev_prev <- file_postfixes[iTimestampFilePostfix - 2]
      #  num_snapshot_timestamp_ms_prev <- round(as.numeric(strptime(str_snapshot_timestamp_prev, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
      #  num_snapshot_timestamp_ms_prev_prev <- round(as.numeric(strptime(str_snapshot_timestamp_prev_prev, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
      #  num_snapshot_timestamp_ms <- num_snapshot_timestamp_ms_prev + (num_snapshot_timestamp_ms_prev - num_snapshot_timestamp_ms_prev_prev)
      #} else
      #{
        num_snapshot_timestamp_ms <- round(as.numeric(strptime(str_latest_snapshot_timestamp, "%Y-%m-%dT%H:%M:%OSZ"))*1000.0) # + 0.001
      #}
    }
    time_offset_ms <- num_snapshot_timestamp_ms - time_origin_ms
    #
    json_postfix_out <- file_postfixes[iTimestampFilePostfix]
    json_postfix_out <- gsub("T","_", json_postfix_out)
    json_postfix_out <- gsub("Z", "", json_postfix_out)
    json_postfix_out <- gsub("-","_", json_postfix_out)
    json_postfix_out <- gsub(":","_", json_postfix_out)
    json_postfix_out <- gsub(".","_", json_postfix_out, fixed = TRUE)
    json_path_name <- paste0(json_path,"/", gsub("-","_", file_prefix),json_postfix_out,file_extension)
    
    print(paste0("Generating Precinct by Vote Type and Vote Count Time Series CSV for ", state_abbr, " at ", json_postfix_out))
    res <- jsonlite::read_json(path = json_path_name)
    #
    # Use "res$precinct_by_vote_type" for {"PA", "FL} and "res$precincts" for {"NC", "MI", "GA"}
    if("precinct_by_vote_type" %in% names(res))
    {
      length_precinct_by_vote_type <- length(res$precinct_by_vote_type)
      use_long_name <- TRUE
    } else if("precincts" %in% names(res))
    {
      length_precinct_by_vote_type <- length(res$precincts)
      use_long_name <- FALSE
    } else
    {
      stop("Failed to find a field with vote counts in JSON file.")
    }
    #
    if(length_precinct_by_vote_type > 0)
    {
      df_precinct_votes <- data.frame(
        time_offset_ms   = numeric(length_precinct_by_vote_type),
        sid              = numeric(length_precinct_by_vote_type),
        cid              = numeric(length_precinct_by_vote_type),
        pid              = numeric(length_precinct_by_vote_type),
        vid              = numeric(length_precinct_by_vote_type),
        tally            = numeric(length_precinct_by_vote_type),
        stringsAsFactors = FALSE)
      for(iChoiceNameIndex in 1:nrow(df_choices_major))
      {
        df_precinct_votes[,paste0("votes_",df_choices_major$choice_name[iChoiceNameIndex])] =
          numeric(nrow(df_precinct_votes))
      }
      for(iPrecincts in 1:length_precinct_by_vote_type)
      {
        precinct_by_vote_type <- ifelse(use_long_name,
                                        res$precinct_by_vote_type[iPrecincts],
                                        res$precincts[iPrecincts])[[1]]
        locality_name <- toupper(precinct_by_vote_type$locality_name)
        precinct_id <- precinct_by_vote_type$precinct_id
        if("vote_type" %in% names(precinct_by_vote_type))
        {
          vid <- ht_vote_type_ids[[precinct_by_vote_type$vote_type]]
        } else
        {
          vid <- ht_vote_type_ids[["unknown"]]
        }
        #
        df_precinct_votes$time_offset_ms[iPrecincts] <- time_offset_ms
        df_precinct_votes$sid[iPrecincts]            <- sid
        df_precinct_votes$cid[iPrecincts]            <- ht_county_ids[[locality_name]]
        df_precinct_votes$pid[iPrecincts]            <- ht_precinct_ids[[paste0(locality_name, "|", precinct_id)]]
        df_precinct_votes$vid[iPrecincts]            <- vid
        df_precinct_votes$tally[iPrecincts]          <- ifelse("votes" %in% names(precinct_by_vote_type),
                                                               precinct_by_vote_type$votes, 0)
        df_precinct_votes[iPrecincts,colnames(df_precinct_votes)[startsWith(colnames(df_precinct_votes),"votes_")]] <- 0
        if(length(precinct_by_vote_type$results) > 0)
        {
          for(choice_name in names(precinct_by_vote_type$results))
          {
            if(choice_name %in% df_choices_major$choice_name & choice_name != "others")
            {
              df_precinct_votes[iPrecincts,paste0("votes_",choice_name)] <- precinct_by_vote_type$results[[choice_name]]
            } else
            {
              df_precinct_votes[iPrecincts,"votes_others"] <-
                df_precinct_votes[iPrecincts,"votes_others"] +
                precinct_by_vote_type$results[[choice_name]]
            }
          }
        }
      } # END for(iPrecincts in 1:length_precinct_by_vote_type)
    } else # END if(length_precinct_by_vote_type > 0)
    {
      df_precinct_votes <- data.frame(
        time_offset_ms   = numeric(),
        sid              = numeric(),
        cid              = numeric(),
        pid              = numeric(),
        vid              = numeric(),
        tally            = numeric(),
        stringsAsFactors = FALSE)
      for(iChoiceNameIndex in 1:nrow(df_choices_major))
      {
        df_precinct_votes[,paste0("votes_",df_choices_major$choice_name[iChoiceNameIndex])] =
          numeric(nrow(df_precinct_votes))
      }
    } # END else for "if(length_precinct_by_vote_type > 0)"
    df_precinct_votes <- df_precinct_votes[order(
      #df_precinct_votes$time_offset_ms,
      df_precinct_votes$sid,
      df_precinct_votes$cid,
      df_precinct_votes$pid,
      df_precinct_votes$vid),]
    if(iTimestampFilePostfix == 1)
    {
      write.csv(x = df_precinct_votes, file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type_count_ts",".csv"),
                row.names = FALSE)
    } else
    {
      write.table(x = df_precinct_votes, file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type_count_ts",".csv"),
                  sep = ",", append = TRUE, quote = FALSE,
                  col.names = FALSE, row.names = FALSE)
    }
  } # END for(iTimestampFilePostfix in 1:length(file_postfixes))
}

######################################################################################################

generate.rds.from.csv <- function(base_dir, state_abbr, bool.save.state = FALSE)
{
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  rds_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/rds")

  array_file_postfixes <- c(
    "_vote_type",
    "_county",
    "_county_vote_type",
    "_precinct",
    "_precinct_vote_type",
    "_precinct_vote_type_count_ts"
  )

  if(!dir.exists(rds_path))
  {
    dir.create(rds_path)
  }
  
  if(bool.save.state)
  {
    df <- read.csv(file = paste0(csv_path,"/","state",".csv"))
    saveRDS(df, file = paste0(rds_path,"/","state",".rds"))
    # df_clone <- readRDS(file = paste0(rds_path,"/","state",".rds"))
  }
  
  for(iPosfixIndex in 1:length(array_file_postfixes))
  {
    df <- read.csv(file = paste0(csv_path,"/",state_abbr,array_file_postfixes[iPosfixIndex],".csv"))
    saveRDS(df, file = paste0(rds_path,"/",state_abbr,array_file_postfixes[iPosfixIndex],".rds"))
    # df_clone <- readRDS(file = paste0(rds_path,"/",state_abbr,array_file_postfixes[iPosfixIndex],".rds"))
  }
}

######################################################################################################

produce.plots <- function(base_dir, state_abbr, use.csv = FALSE)
{
  csv_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/csv")
  rds_path <- paste0(base_dir,"/input/elections-assets/2020/data/precincts/rds")
  pdf_output_path <- paste0(base_dir,"/output/pdf")
  csv_output_path <- paste0(base_dir,"/output/csv")
  
  if(use.csv)
  {
    df_state <- read.csv(file = paste0(csv_path,"/","state",".csv"))
    df_vote_type <- read.csv(file = paste0(csv_path,"/",state_abbr,"_vote_type",".csv"))
    df_county <- read.csv(file = paste0(csv_path,"/",state_abbr,"_county",".csv"))
    df_county_vote_type <- read.csv(file = paste0(csv_path,"/",state_abbr,"_county_vote_type",".csv"))
    df_precinct <- read.csv(file = paste0(csv_path,"/",state_abbr,"_precinct",".csv"))
    df_precinct_vote_type <- read.csv(file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type",".csv"))
    df_precinct_vote_type_count_ts <- read.csv(file = paste0(csv_path,"/",state_abbr,"_precinct_vote_type_count_ts",".csv"))
  } else
  {
    df_state <- readRDS(file = paste0(rds_path,"/","state",".rds"))
    df_vote_type <- readRDS(file = paste0(rds_path,"/",state_abbr,"_vote_type",".rds"))
    df_county <- readRDS(file = paste0(rds_path,"/",state_abbr,"_county",".rds"))
    df_county_vote_type <- readRDS(file = paste0(rds_path,"/",state_abbr,"_county_vote_type",".rds"))
    df_precinct <- readRDS(file = paste0(rds_path,"/",state_abbr,"_precinct",".rds"))
    df_precinct_vote_type <- readRDS(file = paste0(rds_path,"/",state_abbr,"_precinct_vote_type",".rds"))
    df_precinct_vote_type_count_ts <- readRDS(file = paste0(rds_path,"/",state_abbr,"_precinct_vote_type_count_ts",".rds"))
  }
  
  state_name <- df_state$state_name[df_state$state_abbr == state_abbr]
  time_origin_ms <- df_state$time_origin_ms[df_state$state_abbr == state_abbr]

  column_names_resid_votes <-
    colnames(df_precinct_vote_type_count_ts)[startsWith(colnames(df_precinct_vote_type_count_ts),"votes_")]
  column_names_resid_votes <-
    column_names_resid_votes[!(column_names_resid_votes %in% c("votes_trumpd", "votes_bidenj", "votes_others"))]
  if(!("votes_others" %in% colnames(df_precinct_vote_type_count_ts)))
  {
    df_precinct_vote_type_count_ts[,"votes_others"] <- 0
  }
  if(length(column_names_resid_votes) > 0)
  {
    for(iResidColIndex in 1:length(column_names_resid_votes))
    {
      df_precinct_vote_type_count_ts[,"votes_others"] <-
        df_precinct_vote_type_count_ts[,"votes_others"] +
        df_precinct_vote_type_count_ts[,c(column_names_resid_votes[iResidColIndex])]
      df_precinct_vote_type_count_ts[,c(column_names_resid_votes[iResidColIndex])] <- NULL
    }
  }
  
  if(state_abbr %in% c("FL", "MI", "GA", "NC", "PA"))
  {
    df_precinct_vote_type_count_ts.by_time <- groupBy(
      df = df_precinct_vote_type_count_ts, by = "time_offset_ms",
      clmns       = c("time_offset_ms", "sid", "tally", "votes_bidenj", "votes_trumpd", "votes_others"),
      aggregation = c("min",            "min", "sum",   "sum",          "sum",          "sum"),
      full.names = FALSE, na.rm = TRUE)
    df_precinct_vote_type_count_ts.by_time <- df_precinct_vote_type_count_ts.by_time[
      order(df_precinct_vote_type_count_ts.by_time$time_offset_ms),]
    #
    if(state_abbr == "FL")
    {
      xlims <- c(1.84e8, 2.0e8)
    } else if(state_abbr == "GA")
    {
      xlims <- c(2.7e8, 6.0e8)
    } else if(state_abbr == "MI")
    {
      xlims <- c(1.5e7, 1.2e8)
    } else if(state_abbr == "NC")
    {
      xlims <- c(3.92e8, 4.1e8)
    } else if(state_abbr == "PA")
    {
      xlims <- c(1.5e7, 1.2e8)
    } else
    {
      xlims <- c(0, max(df_precinct_vote_type_count_ts.by_time$time_offset_ms))
    }
    if(FALSE)
    {
      ylims <- c(0, max(df_precinct_vote_type_count_ts.by_time$tally))
      plot(x = df_precinct_vote_type_count_ts.by_time$time_offset_ms,
           y = df_precinct_vote_type_count_ts.by_time$tally,
           main = paste0("Tally for ", state_name, " (", state_abbr, ")"),
           xlab = "Time Offset (ms)", ylab = "Vote Tally Count",
           xlim = xlims, ylim <- ylims,
           pch = 20, lty = c("solid"), type = "b", col = "black", lwd = 2,
           cex = 1.5, cex.axis = 1.7, cex.lab = 1.7, cex.sub = 2, cex.main = 2)
    }
    #
    ylims <- c(0, max(df_precinct_vote_type_count_ts.by_time$votes_bidenj,
                      df_precinct_vote_type_count_ts.by_time$votes_trumpd,
                      df_precinct_vote_type_count_ts.by_time$votes_others))
    plot(x = df_precinct_vote_type_count_ts.by_time$time_offset_ms,
         y = df_precinct_vote_type_count_ts.by_time$votes_bidenj,
         main = paste0("Votes for ", state_name, " (", state_abbr, ")"),
         xlab = "Time Offset (ms)", ylab = "Vote Count for Choices",
         xlim = xlims, ylim <- ylims,
         pch = 20, lty = c("solid"), type = "b", col = "darkblue", lwd = 2,
         cex = 1.5, cex.axis = 1.7, cex.lab = 1.7, cex.sub = 2, cex.main = 2)
    lines(x = df_precinct_vote_type_count_ts.by_time$time_offset_ms,
          y = df_precinct_vote_type_count_ts.by_time$votes_trumpd,
          pch = 20, lty = c("solid"), type = "b", col = "red", lwd = 2,
          xaxt="n", yaxt ="n")
    lines(x = df_precinct_vote_type_count_ts.by_time$time_offset_ms,
          y = df_precinct_vote_type_count_ts.by_time$votes_others,
          pch = 20, lty = c("solid"), type = "b", col = "green", lwd = 2,
          xaxt="n", yaxt ="n")
    #abline(v=5e7, col=c("grey"),lwd=c(2),lty=c("dotted")) # dashed
    abline(h=0, col=c("black"),lwd=c(2),lty=c("solid"))
    legend.line1 <- "Biden"
    legend.line2 <- "Trump"
    legend.line3 <- "Others"
    #legend.line4 <- "Hour start"
    legend(x=xlims[1] + (xlims[2] - xlims[1])*2/3, y=ylims[1] + (ylims[2] - ylims[1])/3,
           legend=c(legend.line1,legend.line2,legend.line3),
           merge=FALSE, lwd=c(2), cex=c(1.3),
           col=c("darkblue","red","green"),
           lty=c("solid","solid","solid"))
    #grid(nx = 10, ny = 10, col="grey", lwd = 1)
  }
  # ...
}
