import multiprocessing.dummy as mp
import os
import requests
import time
from itertools import repeat


scriptFilePath = os.path.dirname(__file__)
scriptsPath = os.path.dirname(scriptFilePath)
analyticsPath = os.path.dirname(scriptsPath)
projectPath = os.path.dirname(analyticsPath)
precinctsJsonPath = os.path.join(projectPath,'Data/Precincts/JSON')


def downloadFile(url: str, downloadFolder: str = None, retries: int = 0):
    fileName = url.rsplit('/', 1)[1]
    fileName = fileName.replace(':', '_')
    if downloadFolder:
        folderExists = os.path.exists(os.path.join(precinctsJsonPath,downloadFolder)) and \
            os.path.isdir(os.path.join(precinctsJsonPath,downloadFolder))
        if folderExists == False:
            os.mkdir(os.path.join(precinctsJsonPath,downloadFolder))
        fileName = f'{os.path.join(precinctsJsonPath,downloadFolder)}/{fileName}'
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
    downloadList = {'FL': f'{precinctsJsonPath}/nyt-FLGeneral.txt',
                    'GA': f'{precinctsJsonPath}/nyt-GAGeneral.txt',
                    'MI': f'{precinctsJsonPath}/nyt-MIGeneral.txt',
                    'NC': f'{precinctsJsonPath}/nyt-NCGeneral.txt',
                    'NE': f'{precinctsJsonPath}/nyt-NEGeneral.txt',
                    'PA': f'{precinctsJsonPath}/nyt-PAGeneral.txt'}
    for state in downloadList:
        print(downloadList[state])
        with open(downloadList[state], 'r') as file:
            for url in file:
                if url.strip() != '':
                    print(url)
                    downloadFile(url.strip(), state)