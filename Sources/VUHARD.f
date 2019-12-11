C **********************************************************************
C J2 Mises Plasticity with isotropic Johnson-Cook hardening for plane 
C strain case and 3D case.
C **********************************************************************

      include 'JohnsonCook.f'

C **********************************************************************
C VUHARD subroutine core
C **********************************************************************
      subroutine vuhard (
C Read only -
     1     nblock, 
     2     nElement, nIntPt, nLayer, nSecPt, 
     3     lAnneal, stepTime, totalTime, dt, cmname,
     4     nstatev, nfieldv, nprops, 
     5     props, tempOld, tempNew, fieldOld, fieldNew,
     6     stateOld,
     7     eqps, eqpsRate,
C Write only -
     8     yield, dyieldDtemp, dyieldDeqps,
     9     stateNew )
C
      include 'vaba_param.inc'
C
      dimension nElement(nblock),
     1     props(nprops), 
     2     tempOld(nblock),
     3     fieldOld(nblock,nfieldv), 
     4     stateOld(nblock,nstatev), 
     5     tempNew(nblock),
     6     fieldNew(nblock,nfieldv),
     7     eqps(nblock),
     8     eqpsRate(nblock),
     9     yield(nblock),
     1     dyieldDtemp(nblock), 
     2     dyieldDeqps(nblock,2),
     3     stateNew(nblock,nstatev)
C
      character*80 cmname
C
C **********************************************************************  
C Start of the subroutine grab the parameters of the constitutive law
C **********************************************************************  
      parA      = props(1)
      parB      = props(2)
      parn      = props(3)
      parC      = props(4)
      parm      = props(5)
      pardepsp0 = props(6)
      parT0     = props(7)
      parTm     = props(8)
C
C **********************************************************************  
C Main computation block
C **********************************************************************  
      do k = 1, nblock
        epsp = eqps(k)
        depsp = eqpsRate(k)
        temp = tempNew(k)
C Compute the yield stress
        Yield(k) = yieldStress(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / epsp
        dyieldDeqps(k,1) = yieldHardEpsp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / depsp
        dyieldDeqps(k,2) = yieldHardDepsp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute derivative of yield / temp
        dyieldDtemp(k) = yieldHardTemp(epsp, depsp, temp,
     1    parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
      end do
C
      return
      end
