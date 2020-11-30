#!/bin/bash

#usage: .crawler.sh GA 2020-11-04T01:[00-20]:[00-59].[000-999]


STATE_CODE=$1; # i.e., "PA"
DATE_RANGE=$2; # i.e., "2020-11-04T02:21:22.[000-040]"
# PA, FL, MI have a slightly different URL
#NYT_URL="https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/${STATE_CODE}GeneralConcatenator-${DATE_RANGE}Z.json";
NYT_URL="https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/${STATE_CODE}General-${DATE_RANGE}Z.json";
CURR_TIMESTAMP=$(date +"%s");

# i.e., "PA - 2020-11-04T02.21.22.[000-040] - 1605565714.txt"
OUTPUT_FILENAME="${STATE_CODE} - ${DATE_RANGE//:/.} - ${CURR_TIMESTAMP}.txt"

mkdir -p errors;
mkdir -p logs;

# --head | perform http HEAD request instead of GET (faster to perform a HEAD lookup)
# --parallel | run concurrent async curl requests
# --parallel-immediate | prefer opening new connections rather than waiting to use existing connections
# --parallel-max | number of simultaneous transfers to run (detault is 50)
# --retry | retry in the event of an HTTP 408 or 5xx reponse
# --retry-delay | wait 1 second between retries
# --silent | mute console (must manually request stdout and stderr)
# --show-error | used with --silent to display error messages to console
# --stderr | save stderr output to log file
# --output /dev/null | don't show curl reponse details or payload
# --write-out | custom stdout in the form of `200 https://postman-echo.com/get?foo1=bar1&foo2=bar0`
curl $NYT_URL \
    --head \
    --parallel \
    --parallel-immediate \
    --parallel-max 150 \
    --retry 3 \
    --retry-delay 1 \
    --silent \
    --show-error \
    --stderr "errors/error - ${CURR_DATETIME}.log" \
    --output /dev/null \
    --write-out '%{http_code} %{url_effective}\n' \
>  "./logs/${OUTPUT_FILENAME}" \
;
