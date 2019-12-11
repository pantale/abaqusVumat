#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  7 14:14:48 2019

@author: pantale
"""

import odbAccess

class AbaqusExtract:
    def __init__(self, name):
        self.filename = name
        self.run()

    def fillHistory(self, history):
        tm = []
        ps = []
        for time, pos in history:
            tm.append(time)
            ps.append(pos)
        return tm, ps

    def rawReadLineNumber(self, file, number):
        FRead = open(file, "r")
        lines = FRead.readlines()
        FRead.close()
        return lines[number-1]

    def rawRead(self, file):
        FRead = open(file, "r")
        lines = FRead.readlines()
        FRead.close()
        lines = [x.partition('#')[0] for x in lines if (x and x.partition('#')[0])]
        return lines    
            
    def run(self):
        dataNames = []
        dataValues = []
        dataRegions = []
        dataJobs = []
        dataOperates = []
        lines = self.rawRead(self.filename)
        for line in lines:
            # Split and strip line
            lineItems = [x.strip() for x in line.split(',')]
            # Extraction des parametres du mimizer
            if (lineItems[0] == 'TimeHistory'):
                dataOperates.append('none')
                for item in lineItems:
                    item = [x.strip() for x in item.split('=')]
                    if (item[0] == 'value'): dataValues.append(item[1])
                    if (item[0] == 'name'): dataNames.append(item[1])
                    if (item[0] == 'job'): dataJobs.append(item[1])
                    if (item[0] == 'operate'): dataOperates[-1]=item[1]
                    if (item[0] == 'region'): 
                        if '+' in item[1]:
                            # Many regions grouped
                            group = [x.strip() for x in item[1].split('+')]
                            dataRegions.append(group)
                        else:    
                            # Only one region
                            reg = []
                            reg.append(item[1])
                            dataRegions.append(reg)
        for var in range (0, len(dataNames)):
            # Get the Odb object
            jobFile = dataJobs [var]
            odb = odbAccess.openOdb(path = jobFile + ".odb")
            # Get the step 1
            step1 = odb.steps['Step-1']
            outFile = jobFile + '_' + dataNames[var] + '.plot'
            dispFile = open(outFile,'w')
            nbPts = len(dataRegions[var])
            if (nbPts == 1):
                print("Extracting " + dataNames[var] + " from " + jobFile)
                dispFile.write("#DynELA_plot :" + jobFile + '_' + dataNames[var] + '\n')
                dispFile.write("#plotted :" + jobFile + '_' + dataNames[var] + '\n')
                region = step1.historyRegions[dataRegions[var][0]]
                time, data = self.fillHistory(region.historyOutputs[dataValues[var]].data)
                for i in range (0, len(time)):
                    dispFile.write(str(time[i]) + " " + str(data[i]) + '\n')
            elif (dataOperates[var] == 'none'):
                print("Extracting multiple " + str(nbPts) + " values for " + dataNames[var] + " from " + jobFile)
                dispFile.write("#DynELA_plot :" + jobFile + '_' + dataNames[var] + '\n')
                dispFile.write("#plotted :")
                for pt in range (0, nbPts):
                    dispFile.write(jobFile + '_' + dataNames[var] + '_' + str(pt) + ' ')
                dispFile.write('\n')
                datas = []
                for pt in range (0, nbPts):
                    region = step1.historyRegions[dataRegions[var][pt]]
                    time, data = self.fillHistory(region.historyOutputs[dataValues[var]].data)
                    datas.append(data)
                for i in range (0, len(time)):
                    dispFile.write(str(time[i]))
                    for pt in range (0, nbPts):
                        dispFile.write(" " + str(datas[pt][i]))
                    dispFile.write('\n')
            else:
                print("Combining " + str(nbPts) + " values for " + dataNames[var] + " from " + jobFile)
                dispFile.write("#DynELA_plot :" + jobFile + '_' + dataNames[var] + '\n')
                dispFile.write("#plotted :" + jobFile + '_' + dataNames[var] + '\n')
                datas = []
                for pt in range (0, nbPts):
                    region = step1.historyRegions[dataRegions[var][pt]]
                    time, data = self.fillHistory(region.historyOutputs[dataValues[var]].data)
                    datas.append(data)
                data = []
                for dat in range(len(time)):
                    if (dataOperates[var] == 'mean'):
                        d = 0.0
                        for pt in range (0, nbPts): d += datas[pt][dat]
                        data.append(d / nbPts)
                    if (dataOperates[var] == 'sum'):
                        d = 0.0
                        for pt in range (0, nbPts): d += datas[pt][dat]
                        data.append(d)
                for i in range (0, len(time)):
                    dispFile.write(str(time[i]) + " " + str(data[i]) + '\n')
            dispFile.close()

# Extract data from datafile
AbaqusExtract('Extract.ex')  
