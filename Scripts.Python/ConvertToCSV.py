# version 1.3

import json
import os
import re
from datetime import datetime

priorValues = {}
scriptPath = os.path.dirname(__file__)
precinctsJsonPath = os.path.join(os.path.dirname(scriptPath),'Data/Precincts/JSON')
precinctsCsvPath = os.path.join(os.path.dirname(scriptPath),'Data/Precincts/CSV')


def BuildCompoundKey(*keys: str) -> str:
    compoundKey = ''
    for key in keys:
        compoundKey += f'{key}|'
    return compoundKey


def GetState(fileName: str) -> str:
    fileName = fileName.replace('\\', '/')
    fileName = fileName.replace('.', '')
    fileParts = fileName.split('/')
    fileParts.reverse()
    state = fileParts[0]
    return state[:2]


def GetTimeStamp(fileName: str) -> str:
    timeStamp = None
    # timePattern = '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}_[0-9]{2}_[0-9]{2}.[0-9]{3}'
    timePattern = '\d+-\d+-\d+T\d+[:_]\d+[:_]\d+.\d+'
    regex = re.compile(timePattern)
    timeStampArr = regex.findall(fileName)
    if timeStampArr:
        timeStamp = timeStampArr[len(timeStampArr)-1].replace('_', ':').replace('T', ' ')
    if fileName.endswith('latest.json'): 
        mtime = os.path.getmtime(fileName)
        timeStamp = datetime.utcfromtimestamp(mtime).strftime('%Y-%m-%d %H:%M:%S.000')
    return timeStamp


def ProcessCountyData(fileName: str) -> None:
    timeStamp = GetTimeStamp(fileName)
    if timeStamp == None:
        timeStamp = fileName
    stateAbbrev = GetState(fileName)
    outputFileName = f'{precinctsCsvPath}/{stateAbbrev}CountyData.csv'
    with open(fileName, 'r') as jsonFile:
        jsonData = json.load(jsonFile)
        if 'county_by_vote_type' in jsonData:
            countyData = jsonData['county_by_vote_type']
            addHeader = False
            if not os.path.exists(outputFileName):
                addHeader = True
            with open(outputFileName, 'a') as outFile:
                if addHeader:
                    line = '"timeStamp","countyName","voteType","candidate","votes","delta"\n'
                    outFile.write(line)
                for county in countyData:
                    countyName = county['locality_name']
                    voteType = county['vote_type']
                    candidateResults = county['results']
                    for candidate in county['results']:
                        key = BuildCompoundKey(countyName, voteType, candidate)
                        priorValue = 0
                        if key in priorValues:
                            priorValue = priorValues[key]
                        votes = candidateResults[candidate]
                        delta = votes - priorValue
                        # print(f'{timeStamp} | {countyName} | {voteType} | {candidate} | {votes} | {delta}')
                        priorValues[key] = votes
                        line = f'"{timeStamp}","{countyName}","{voteType}","{candidate}","{votes}","{delta}"' + '\n'
                        outFile.write(line)


def ProcessPaPrecinctData(fileName: str) -> None:
    """ Pennsylvania json files have two precinct sections
        and Chester + Philly counties have vote_type field missing
    """ 
    countiesWithTotalsOnly = ['Chester','Philadelphia']
    precinctSections = ['precinct_totals','precinct_by_vote_type']
    timeStamp = GetTimeStamp(fileName)
    if timeStamp == None:
        timeStamp = fileName
    stateAbbrev = GetState(fileName)
    outputFileName = f'{precinctsCsvPath}/{stateAbbrev}PrecinctData.csv'
    with open(fileName, 'r') as jsonFile:
        jsonData = json.load(jsonFile)
        if 'precinct_totals' in jsonData and 'precinct_by_vote_type' in jsonData:
            addHeader = False
            if not os.path.exists(outputFileName):
                addHeader = True
            with open(outputFileName, 'a') as outFile:
                if addHeader:
                    line = '"timeStamp","precinctId","countyName","voteType","candidate","votes","delta"\n'
                    outFile.write(line)
                for precinctSection in precinctSections:
                    precinctData = jsonData[precinctSection]
                    for precinct in precinctData:
                        precinctId = precinct['precinct_id']
                        countyName = precinct['locality_name']
                        if countyName in countiesWithTotalsOnly and precinctSection != 'precinct_totals':
                            continue
                        if 'vote_type' in precinct:
                            voteType = precinct['vote_type']
                        else:
                            voteType = 'unknown'
                        candidateResults = precinct['results']
                        for candidate in precinct['results']:
                            key = BuildCompoundKey(precinctId, countyName, voteType, candidate)
                            priorValue = 0
                            if key in priorValues:
                                priorValue = priorValues[key]
                            votes = candidateResults[candidate]
                            delta = votes - priorValue
                            # print(f'{timeStamp} | {precinctId} | {countyName} | {voteType} | {candidate} | {votes} | {delta}')
                            priorValues[key] = votes
                            line = f'"{timeStamp}","{precinctId}","{countyName}","{voteType}","{candidate}","{votes}","{delta}"' + '\n'
                            outFile.write(line)


def ProcessPrecinctData(fileName: str) -> None:
    timeStamp = GetTimeStamp(fileName)
    if timeStamp == None:
        timeStamp = fileName
    stateAbbrev = GetState(fileName)
    outputFileName = f'{precinctsCsvPath}/{stateAbbrev}PrecinctData.csv'
    with open(fileName, 'r') as jsonFile:
        jsonData = json.load(jsonFile)
        if 'precincts' in jsonData:
            precinctData = jsonData['precincts']
            addHeader = False
            if not os.path.exists(outputFileName):
                addHeader = True
            with open(outputFileName, 'a') as outFile:
                if addHeader:
                    line = '"timeStamp","precinctId","countyName","voteType","candidate","votes","delta"\n'
                    outFile.write(line)
                for precinct in precinctData:
                    precinctId = precinct['precinct_id']
                    countyName = precinct['locality_name']
                    if 'vote_type' in precinct:
                        voteType = precinct['vote_type']
                    else:
                        # shouldn't happen outside of PA...but why not
                        voteType = 'Unknown'
                    candidateResults = precinct['results']
                    for candidate in precinct['results']:
                        key = BuildCompoundKey(precinctId, countyName, voteType, candidate)
                        priorValue = 0
                        if key in priorValues:
                            priorValue = priorValues[key]
                        votes = candidateResults[candidate]
                        delta = votes - priorValue
                        # print(f'{timeStamp} | {precinctId} | {countyName} | {voteType} | {candidate} | {votes} | {delta}')
                        priorValues[key] = votes
                        line = f'"{timeStamp}","{precinctId}","{countyName}","{voteType}","{candidate}","{votes}","{delta}"' + '\n'
                        outFile.write(line)


def ParseFile(fileName: str) -> None:
    print(f'Processing {fileName}')
    stateAbbrev = GetState(fileName)
    # TODO: Cleanup this mess
    if stateAbbrev == 'PA':
        ProcessCountyData(fileName)
        ProcessPaPrecinctData(fileName)
    else:
        ProcessPrecinctData(fileName)


if __name__ == '__main__':
    for (directoryPath, subdirectoryList, fileList) in os.walk(precinctsJsonPath):
        isStart = True
        priorValues.clear()
        fileList.sort()
        for fileNameSingle in fileList:
            if fileNameSingle.endswith('.json'):
                stateAbbrev = GetState(fileNameSingle)
                if isStart:
                    precinctFileName = f'{precinctsCsvPath}/{stateAbbrev}PrecinctData.csv'
                    if os.path.exists(precinctFileName):
                        os.remove(precinctFileName)
                    countyFileName = f'{precinctsCsvPath}/{stateAbbrev}CountyData.csv'
                    if os.path.exists(countyFileName):
                        os.remove(countyFileName)
                    isStart = False
                ParseFile(os.path.join(directoryPath, fileNameSingle))