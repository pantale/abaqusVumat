#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  7 14:14:48 2019

@author: pantale
"""

import csv
import numpy
import pylab
from cycler import cycler
from itertools import cycle

class Curves:
    def __init__(self):
        self.xscale = self.yscale = 1.0
        self.xrange = self.yrange = 0
        self.xname = 'x-axis'
        self.yname = 'y-axis'
        self.xfontsize = self.yfontsize = self.titlefontsize = 20
        self.xlabelfontsize = self.ylabelfontsize = 16
        self.legendposition = ['1.0', '1.0']
        self.legendanchor = 'upper right'
        self.legendcolumns = 1
        self.legendshadow = True
        self.legendfontsize = 16
        self.curvesymbol = ''
        self.marks = 20
        self.marksize = 10
        self.removeinname = ''
        self.curvename = ''
        self.titlegraph = 'Default title of the graph'
        self.lwidth = 2
        self.outputformat = 'svg'
        self.symbols = ['-o', '-s', '-v', '-^', '-H', '-D', '-<', '->']
        self.transparency = False
        self.cropped = False
        self.gridOn = True

    def boolTest(self, st):
        if st.lower() == 'true': return True
        return False

    def rawReadLineNumber(self, file, number):
        # Read the whole file
        FRead = open(file, "r")
        lines = FRead.readlines()
        FRead.close()
        return lines[number-1]
    
    def rawRead(self, file):
        # Read the whole file
        FRead = open(file, "r")
        lines = FRead.readlines()
        FRead.close()
        lines = [x.partition('#')[0] for x in lines if (x and x.partition('#')[0])]
        lines = [x for x in lines if (x and x.partition('\n')[0])]
        return lines    

    def readPlotFile(self, filename, column_1 = 0, column_2 = 1):
        x, y = [], []
        try:
            f = open(filename)
        except:
            print("Datafile:", filename, "not exists -> Ignored\n")
            return '', x, y
        # Create a csv reader object.
        reader = csv.reader(f, delimiter = ' ')
        # Skip first row.
        next(reader)
        #Get second row for name
        line = next(reader)
        name = line[1][1:]
        # Read and store data
        for row in reader:
            x.append(float(row[column_1]))
            y.append(float(row[column_2]))
        return name, x, y


    def scanItem(self, item):
        item = [x.strip() for x in item.split('=')]
        if (item[0] == 'xscale'):
            self.xscale = float(item[1])
            self.xrange = 0.0
        if (item[0] == 'yscale'):
            self.yscale = float(item[1])
            self.xrange = 0.0
        if (item[0] == 'xrange'): 
            self.xrange = float(item[1])
            self.xscale = 1.0
        if (item[0] == 'yrange'): 
            self.yrange = float(item[1])
            self.yscale = 1.0
        if (item[0] == 'xfontsize'): self.xfontsize = int(item[1])
        if (item[0] == 'yfontsize'): self.yfontsize = int(item[1])
        if (item[0] == 'xlabelfontsize'): self.xlabelfontsize = int(item[1])
        if (item[0] == 'ylabelfontsize'): self.ylabelfontsize = int(item[1])
        if (item[0] == 'titlefontsize'): self.titlefontsize = int(item[1])
        if (item[0] == 'xname'): self.xname = item[1]
        if (item[0] == 'yname'): self.yname = item[1]
        if (item[0] == 'legendposition'): self.legendposition = item[1].split(':')
        if (item[0] == 'legendanchor'): self.legendanchor = item[1]
        if (item[0] == 'legendcolumns'): self.legendcolumns = int(item[1])
        if (item[0] == 'legendshadow'): self.legendshadow = self.boolTest(item[1])
        if (item[0] == 'legendlocate'): 
            if (item[1] == 'topleft'):
                self.legendposition = ['0.0', '1.0']
                self.legendanchor = 'upper left'
            if (item[1] == 'topright'):
                self.legendposition = ['1.0', '1.0']
                self.legendanchor = 'upper right'
            if (item[1] == 'bottomleft'):
                self.legendposition = ['0.0', '0.0']
                self.legendanchor = 'lower left'
            if (item[1] == 'bottomright'):
                self.legendposition = ['1.0', '0.0']
                self.legendanchor = 'lower right'
        if (item[0] == 'legendfontsize'): self.legendfontsize = int(item[1])
        if (item[0] == 'marksnumber'): self.marks = int(item[1])
        if (item[0] == 'marks'): self.curvesymbol = item[1]
        if (item[0] == 'markersize'): self.marksize = int(item[1])
        if (item[0] == 'linewidth'): self.lwidth = int(item[1])
        if (item[0] == 'removename'): self.removeinname = item[1]
        if (item[0] == 'name'): self.curvename = item[1]
        if (item[0] == 'title'): self.titlegraph = item[1]
        if (item[0] == 'outputformat'): self.outputformat = item[1]
        if (item[0] == 'transparent'): self.transparency = self.boolTest(item[1])
        if (item[0] == 'crop'): self.cropped = self.boolTest(item[1])
        if (item[0] == 'grid'): self.gridOn = self.boolTest(item[1])

    # Start of main part of the program
    def plotFile(self, commandFile):
        lines = self.rawRead(commandFile)
        for line in lines:
            # Split and strip line
            lineItems = [x.strip() for x in line.split(',')]
            # Extraction des parametres du mimizer
            if (lineItems[0] == 'Parameters'):
                #treatment of parameters
                print("Scanning Parameters command line")
                for item in lineItems[1:]:
                    self.scanItem(item)
            else:
                print("Scanning Graph generation line")
                zor = 100
                symbolslist=cycle(self.symbols)
                graphName = lineItems[0]
                pylab.figure(figsize = (11.69,8.27)) # for a4 landscape
                pylab.rc('axes', prop_cycle=(cycler('color', ['r', 'b', 'g', 'c' , 'm' , 'y' , 'k'])))
                pylab.rc('text', usetex=True)
                pylab.rcParams['xtick.labelsize'] = self.xlabelfontsize
                pylab.rcParams['ytick.labelsize'] = self.ylabelfontsize
                for item in lineItems[1:]:
                    if ('=' in item):
                        self.scanItem(item)
                    else:
                        # Read the datafile
                        if ('[' in item):
                            # Read datafile with multiple columns
                            subitem = [x.strip() for x in item.split('[')]
                            args = subitem[1][:subitem[1].index(']')]
                            if (':' in args):
                                args = [x.strip() for x in args.split(':')]
                                name, x, y = self.readPlotFile(subitem[0], int(args[0]), int(args[1]))
                            else:
                                name, x, y = self.readPlotFile(subitem[0], int(args))
                        else:
                            # Read datafile with only one data
                            name, x, y = self.readPlotFile(item)
                        # If data has been read
                        if (len(x) !=0):
                            if (self.removeinname != ''): name = name.replace(self.removeinname, '')
                            if (self.curvename != ''): 
                                name = self.curvename
                                self.curvename = ''
                            X = numpy.array(x)
                            Y = numpy.array(y)
                            if (self.xrange != 0.0): X = X/X.max()*self.xrange
                            if (self.yrange != 0.0): Y = Y/Y.max()*self.yrange
                            if (self.curvesymbol == ''):
                                pylab.plot (self.xscale * X, self.yscale * Y, next(symbolslist), label = name, 
                                            markevery = round(len(x)/self.marks), zorder = zor, 
                                            markersize = self.marksize, linewidth = self.lwidth)
                            else:
                                pylab.plot (self.xscale*X, self.yscale*Y, self.curvesymbol, label=name, 
                                            markevery = round(len(x)/self.marks), zorder = zor, 
                                            markersize = self.marksize, linewidth = self.lwidth)
                            zor -=  1
                pylab.xlabel(self.xname, fontsize = self.xfontsize)
                pylab.ylabel(self.yname, fontsize = self.yfontsize)
                pylab.ticklabel_format(style = 'sci',scilimits = (-3,4))
                pylab.legend(loc = self.legendanchor, bbox_to_anchor = (float(self.legendposition[0]), float(self.legendposition[1])),
                            fancybox = True, shadow = self.legendshadow, ncol = self.legendcolumns, numpoints = 1, fontsize = self.legendfontsize)
                pylab.grid(self.gridOn)
                pylab.title(self.titlegraph, y = 1.04, fontsize = self.titlefontsize)
                if self.cropped:
                    pylab.savefig(graphName + '.' + self.outputformat, transparent = self.transparency, bbox_inches = 'tight', pad_inches = 0)
                else:
                    pylab.savefig(graphName + '.' + self.outputformat, transparent = self.transparency)
                print('   -> ' + graphName + ' plot generated')

curves = Curves()
curves.plotFile('Curves.ex')
