C **********************************************************************
C Function to compute the Johnson-Cook yield stress
C **********************************************************************
      function yieldStress (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm )
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parA + parB * epsp**parn
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        viscPart = 1.0 + parC * log (depsp/pardepsp0)
      else
        viscPart = 1.0
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if  
      end if
C Compute and return the yield stress
      yieldStress = hardPart * viscPart * tempPart
      return
      end

C **********************************************************************
C Function to compute the Johnson-Cook hardening / epsp
C **********************************************************************
      function yieldHardEpsp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parn * parB * (epsp**(parn - 1.0))
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        hardPart = hardPart * (1.0 + parC * log (depsp/pardepsp0))
      end if  
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if  
      end if
C Compute and return the yield stress
      yieldHardEpsp = hardPart * tempPart
      return
      end
      
C **********************************************************************
C Function to compute the Johnson-Cook hardening / depsp
C **********************************************************************
      function yieldHardDepsp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = 0.0
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        hardPart = (parA + parB * epsp**parn) * parC / depsp
      end if  
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 1.0
      if (temp > parT0) then
        if (temp < parTm) then
          tempPart = 1.0 - ((temp - parT0) / (parTm - parT0))**parm
        else
          tempPart = 0.0
       end if  
      end if
C Compute and return the yield stress
      yieldHardDepsp = hardPart * tempPart
      return
      end
      
C **********************************************************************
C Function to compute the Johnson-Cook hardening / T
C **********************************************************************
      function yieldHardTemp (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
C Hardening part of the Johnson-Cook law
      hardPart = parA + parB * epsp**parn
C Dependence to the deformation rate
      if (depsp .gt. pardepsp0) then
        viscPart = 1.0 + parC * log (depsp/pardepsp0)
      else
        viscPart = 1.0
      end if
C Dependence to the temperature if parT0 < temp < parTm
      tempPart = 0.0
      if (temp > parT0 .and. temp < parTm) then
        tempPart = -parm*(((temp - parT0)/(parTm - parT0))**(parm))
     1    / (temp - parT0)
      end if
C Compute and return the yield stress
      yieldHardTemp = hardPart * viscPart * tempPart
      return
      end

C **********************************************************************
C Function to compute the numerical Johnson-Cook hardening / epsp
C **********************************************************************
      function yieldHardEpspNum (
C Parameters
     1 yield, epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
C Increment of the plastic strain
      deltaEpsp = 1.0e-1
      if (j_sys_Dimension .eq. 2) deltaEpsp = 1.0e-8
      epspForward = epsp + deltaEpsp
c yieldForward
      yieldForward = yieldStress (epspForward, depsp, temp,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      yieldHardEpspNum = (yieldForward - yield) / deltaEpsp
      return
      end
      
C **********************************************************************
C Function to compute the numerical Johnson-Cook hardening / depsp
C **********************************************************************
      function yieldHardDepspNum (
C Parameters
     1 yield, epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
c Increment of the plastic strain rate
      deltaDepsp = 1.0e-1
      if (j_sys_Dimension .eq. 2) deltaDepsp = 1.0e-8
      depspForward = depsp + deltaDepsp
c yieldForward
      yieldForward = yieldStress (epsp, depspForward, temp,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      yieldHardDepspNum = (yieldForward - yield) / deltaDepsp
      return
      end
      
C **********************************************************************
C Function to compute the numerical Johnson-Cook hardening / T
C **********************************************************************
      function yieldHardTempNum (
C Parameters
     1 yield, epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      include 'vaba_param.inc'
c Increment of the temperature
      deltaTemp = 1.0e-1
      if (j_sys_Dimension .eq. 2) deltaTemp = 1.0e-8
      tempForward = temp + deltaTemp
c yieldForward
      yieldForward = yieldStress (epsp, depsp, tempForward,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      yieldHardTempNum = (yieldForward - yield) / deltaTemp
      return
      end

