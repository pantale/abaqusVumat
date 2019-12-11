# VUMAT for Abaqus Explicit Software
This repository contains some VUMAT(s) for the Abaqus Explicit software written using Fortran Language and implementing the Johnson-Cook constitutive law.

## Contents
This repository contains the sources files (Fortran routines) and some samples concerning the implementation of the Johnson-Cook constitutive law for the Abaqus Explicit Finite Element Code.

All this work has been published and is available in the paper:
>L. Ming and O. Pantalé  
>An efficient and robust VUMAT implementation of elastoplastic constitutive laws in Abaqus/Explicit finite element code  
>Mechanics and Industry 19(3):308  
>DOI: 10.1051/meca/2018021

## Usage of routines
Fortran source routines can be used directly for Abaqus Explicit solver.

Examples of usage are provided in the Benchmark directory.

The samples directory contains makefiles to run the tests (compilation of routines and run of Abaqus) + extractions of results through a Python scrpt and plot of some XY curves.

## List of Fortran routines
- **JohnsonCook.f** : Main core of the Johnson-Cook model
- **VUHARD.f** : Implementation of a user material through a VUHARD subroutine
- **VUMAT-Bisection.f** : Implementation of a user material through a VUMAT subroutine / radial return / bissection solver
- **VUMAT-Direct.f** : Implementation of a user material through a VUMAT subroutine / explicit direct solver
- **VUMAT-NR.f** : Implementation of a user material through a VUMAT subroutine / radial return / Newton-Raphson solver
- **VUMAT-NR-NS.f** : Implementation of a user material through a VUMAT subroutine / radial return / Newton-Raphson solver with numerical evaluation of the derivatives

## List of Samples
- **Element-Radial** : Single axi-symmetric element under radial expansion
- **Element-Shear** : Single plane element under elastoplastic shear
- **Element-Shear-Elastic** : Single plane element under elastic shear
- **Element-Torus** : Single axi-symmetric element under radial expansion
- **BarNecking** : Axisymmetric Bar Necking under tensile load
- **BarNecking-Fine** : Axisymmetric Bar Necking under tensile load (fine mesh)
- **Taylor-Axi** : Taylor impact test with axisymmetric mesh
- **Taylor-3D** : Taylor impact test with 3D mesh
- **Taylor-3D-Fine** : Taylor impact test with 3D mesh (fine mesh)

***
Olivier Pantalé  
Full Professor of Mechanics  
email : olivier.pantale@enit.fr

Laboratoire Génie de Production  
Ecole Nationale d'Ingénieurs de Tarbes  
Université de Toulouse  
47 Avenue d'Azereix - BP 1629  
65016 TARBES - CEDEX - FRANCE
