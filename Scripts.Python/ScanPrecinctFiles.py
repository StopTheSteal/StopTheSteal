import multiprocessing.dummy as mp
import os
import requests
import time
from datetime import datetime
from itertools import repeat

StateAbbreviations = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC',
                      'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
                      'LA', 'ME', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
                      'NC', 'ND', 'OH', 'OK', 'OR', 'MD', 'MA', 'MI', 'MN',
                      'MS', 'MO', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT',
                      'VT', 'VA', 'WA', 'WV', 'WI', 'WY']


def DownloadFile(url: str, downloadFolder: str = None, retries: int = 0):
    fileName = url.rsplit('/', 1)[1]
    fileName = fileName.replace(':', '_')
    if downloadFolder:
        folderExists = os.path.exists(f'./{downloadFolder}') and \
            os.path.isdir(f'./{downloadFolder}')
        if folderExists == False:
            os.mkdir(f'./{downloadFolder}')
        fileName = f'./{downloadFolder}/{fileName}'
    try:
        resp = requests.get(url, allow_redirects=False)
    except Exception as exc:
        resp = None
        retries += 1
        if retries > 5:
            print(f'Error encountered trying to download {url}')
            print(exc)
            exit()
        time.sleep(5)
        DownloadFile(url, downloadFolder, retries)
    if resp:
        if resp.status_code != 200 and resp.status_code != 404:
            print(resp.text)
            exit()
        elif resp.status_code == 404:
            print(f'File Not Found: {fileName}')
        else:
            print(f'Downloaded file: {fileName}')
            with open(fileName, 'wb') as jsonFile:
                jsonFile.write(resp.content)


def CheckForFile(url: str, retries: int = 0) -> bool:
    exists = False
    try:
        resp = requests.head(url, allow_redirects=False)
    except Exception as exc:
        retries += 1
        if retries > 5:
            print(f'Retry limit reached attempting url {url}')
            exit()
        time.sleep(5)
        exists = CheckForFile(url, retries)
        return exists
    if resp.status_code == 200:
        exists = True
    elif resp.status_code == 404:
        exists = False
    else:
        print(resp)
        exit()
    return exists


def CheckUrl(baseUrl, stateAbbrev, day, hour, minute, second, millisecond):
    ms = str(millisecond).zfill(2)
    url = f'{baseUrl}{day}T{hour}:{minute}:{second}.{ms}Z.json'
    fileExists = CheckForFile(url)
    if(fileExists):
        print(f'Found file at {url}')
        DownloadFile(url, stateAbbrev)


if __name__ == '__main__':
    mp.freeze_support()
    baseUrl = 'https://static01.nyt.com/elections-assets/2020/data/api/2020-11-03/precincts/'
    
    ## Uncomment below to grab list of states with known matching patterns
    # filenameEndings = ['General-latest.json', 'GeneralConcatenator-latest.json']
    # for state in StateAbbreviations:
    #     for filenameEnding in filenameEndings:
    #         url = f'{baseUrl}{state}{filenameEnding}'
    #         fileExists = CheckForFile(url)
    #         if fileExists:
    #             print(f'{state} = {url}')


    ## Change filenameBase to match whatever state/pattern you're looking for
    filenameBase = 'NEGeneral'
    baseTimestampUrl = f'{baseUrl}{filenameBase}-2020-11-'
    days = range(4, 13)
    hours = range(23)
    minutes = range(59)
    seconds = range(59)
    milliseconds = range(999)

    ## Adjust maxThreads depending on bandwidth and compute power
    maxThreads = 50

    for day in days:
        dd = str(day).zfill(2)
        for hour in hours:
            hh = str(hour).zfill(2)
            for minute in minutes:
                mm = str(minute).zfill(2)
                # print(f'Processing 2020-11-{dd} {hh}:{mm}')
                print(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
                for second in seconds:
                    ss = str(second).zfill(2)
                    # Comment out below print after done testing.  For full run, print at minute interval instead.
                    print(f'Processing 2020-11-{dd} {hh}:{mm}:{ss}')
                    with mp.Pool(maxThreads) as threadPool:
                        threadPool.starmap(CheckUrl, zip(repeat(baseTimestampUrl), repeat(filenameBase[:2]), repeat(dd), repeat(hh), repeat(mm), repeat(ss), milliseconds))
                        threadPool.close()
                        threadPool.join()