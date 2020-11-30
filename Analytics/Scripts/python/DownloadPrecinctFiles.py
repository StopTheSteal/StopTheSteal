import multiprocessing.dummy as mp
import os
import requests
import time
from itertools import repeat


def downloadFile(url: str, downloadFolder: str = None, retries: int = 0):
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
        downloadFile(url, downloadFolder, retries)
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


if __name__ == '__main__':
    downloadList = {'GA': 'nyt-NCGeneral.txt',
                    'MI': 'nyt-MIGeneral.txt',
                    'NC': 'nyt-NCGeneral.txt',
                    'PA': 'nyt-PAGeneral.txt'}
    for state in downloadList:
        print(downloadList[state])
        with open(downloadList[state], 'r') as file:
            for url in file:
                if url.strip() != '':
                    print(url)
                    downloadFile(url.strip(), state)
