#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 19 16:07:48 2019

@author: pantale
"""

import numpy as np

yougModulus = 206000
poissonRatio = 0.3
shearModulus = yougModulus / (2.0 * (1.0 + poissonRatio))

def fi(x):
    return np.arctan(100*x/2.0)

def alpha1(fi):
    return 2.0*np.cos(2*fi)*(2.0*fi-2.0*np.tan(2.0*fi)*np.log(np.cos(fi))-np.tan(fi))
    
def alpha2(fi):
    return 4.0*(np.cos(2.0*fi)*np.log(np.cos(fi))+fi*np.sin(2.0*fi)-np.sin(fi)**2)    

def s12GN(x):
    return shearModulus*(alpha1(fi(x)))
    
def s11GN(x):
    return shearModulus*(alpha2(fi(x)))
    
def s22GN(x):
    return -shearModulus*(alpha2(fi(x)))
    
def s33GN(x):
    return 0.0*x
    
def s11Jaumann(x):
    return shearModulus*(1.0-np.cos(100*x))
  
def s22Jaumann(x):
    return shearModulus*(np.cos(100*x)-1.0)

def s33Jaumann(x):
    return 0.0*x

def s12Jaumann(x):
    return shearModulus*np.sin(100*x)
  
x=np.linspace(0, 0.1, num=1001, endpoint=True)

s11J=s11Jaumann(x)
s22J=s22Jaumann(x)
s33J=s33Jaumann(x)
s12J=s12Jaumann(x)
sJ = np.sqrt( ((s11Jaumann(x)-s22Jaumann(x))**2 + (s11Jaumann(x)-s33Jaumann(x))**2 + (s33Jaumann(x)-s22Jaumann(x))**2 + 6*s12Jaumann(x)**2 ) /2 )
s11G=s11GN(x)
s22G=s22GN(x)
s33G=s33GN(x)
s12G=s12GN(x)
sG = np.sqrt( ((s11GN(x)-s22GN(x))**2 + (s11GN(x)-s33GN(x))**2 + (s33GN(x)-s22GN(x))**2 + 6*s12GN(x)**2 ) /2 )

tab=np.asarray([x,s11J])
np.savetxt("Jaumann_s11.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :Jaumann-s11", comments = '#')

tab=np.asarray([x,s22J])
np.savetxt("Jaumann_s22.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :Jaumann-s22", comments = '#')

tab=np.asarray([x,s33J])
np.savetxt("Jaumann_s33.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :Jaumann-s33", comments = '#')

tab=np.asarray([x,s12J])
np.savetxt("Jaumann_s12.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :Jaumann-s12", comments = '#')

tab=np.asarray([x,sJ])
np.savetxt("Jaumann_mises.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :Jaumann-mises", comments = '#')
 
tab=np.asarray([x,s11G])
np.savetxt("GreenNaghdi_s11.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :GreenNaghdi-s11", comments = '#')

tab=np.asarray([x,s22G])
np.savetxt("GreenNaghdi_s22.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :GreenNaghdi-s22", comments = '#')

tab=np.asarray([x,s33G])
np.savetxt("GreenNaghdi_s33.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :GreenNaghdi-s33", comments = '#')

tab=np.asarray([x,s12G])
np.savetxt("GreenNaghdi_s12.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :GreenNaghdi-s12", comments = '#')

tab=np.asarray([x,sG])
np.savetxt("GreenNaghdi_mises.plot", np.transpose(tab), delimiter=" ", header="DynELA_plot history file\nplotted :GreenNaghdi-mises", comments = '#')
