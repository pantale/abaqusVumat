C **********************************************************************
C J2 Mises Plasticity with isotropic Johnson-Cook hardening for plane 
C strain case and 3D case.
C Elastic predictor, radial corrector algorithm.
C
C The state variables are stored as:
C      STATE(*,1) = equivalent plastic strain
C      STATE(*,2) = equivalent plastic strain rate
C      STATE(*,3) = last value of gamma
C      STATE(*,4) = yield stress of the material
C      STATE(*,5) = temperature due to plastic strain without conduction
C      STATE(*,6) = total number of Newton-Raphson iterations
C      STATE(*,7) = total number of bissection operations
C **********************************************************************

      include 'JohnsonCook.f'

C **********************************************************************
C VUMAT subroutine core
C **********************************************************************
      subroutine vumat(
C Read only -
     1  nblock, ndir, nshr, nstatev, nfieldv, nprops, lanneal,
     2  stepTime, totalTime, dt, cmname, coordMp, charLength,
     3  props, density, strainInc, relSpinInc,
     4  tempOld, stretchOld, defgradOld, fieldOld,
     5  stressOld, stateOld, enerInternOld, enerInelasOld,
     6  tempNew, stretchNew, defgradNew, fieldNew,
C Write only -
     7  stressNew, stateNew, enerInternNew, enerInelasNew )
C
      include 'vaba_param.inc'
C
      dimension props(nprops), density(nblock), coordMp(nblock,*),
     1  charLength(nblock), strainInc(nblock,ndir+nshr),
     2  relSpinInc(nblock,nshr), tempOld(nblock),
     3  stretchOld(nblock,ndir+nshr),
     4  defgradOld(nblock,ndir+nshr+nshr),
     5  fieldOld(nblock,nfieldv), stressOld(nblock,ndir+nshr),
     6  stateOld(nblock,nstatev), enerInternOld(nblock),
     7  enerInelasOld(nblock), tempNew(nblock),
     8  stretchNew(nblock,ndir+nshr),
     9  defgradNew(nblock,ndir+nshr+nshr),
     1  fieldNew(nblock,nfieldv),
     2  stressNew(nblock,ndir+nshr), stateNew(nblock,nstatev),
     3  enerInternNew(nblock), enerInelasNew(nblock)
C
      character*80 cmname
C
      parameter (
     1   itMax = 250,
     2   TolNRSP = 1.0e-4,
     3   TolNRDP = 1.0e-8, 
     4   neednprops = 14,
     5   neednstatev = 7,
     6   gammaInitial = 1.0e-8,
     7   sqrt23 = 0.81649658092772603273242802490196,
     8   sqrt32 = 1.2247448713915890490986420373529)
C **********************************************************************  
C Start of the subroutine grab the parameters of the constitutive law
C **********************************************************************  
      Young     = props(1)
      xnu       = props(2)
      parA      = props(3)
      parB      = props(4)
      parn      = props(5)
      parC      = props(6)
      parm      = props(7)
      pardepsp0 = props(8)
      parT0     = props(9)
      parTm     = props(10)
      taylorQ   = props(11)
      density0  = props(12)
      heatCap   = props(13)
      mCoupled  = props(14)
C **********************************************************************  
C Compute various material parameters needed further
      twoG = Young / (1.0 + xnu)
      twoG32 = sqrt32 * twoG
      alamda = xnu * twoG / (1.0 - 2.0 * xnu)
      bulk = Young / (3.0 * (1.0 - 2.0 * xnu))
      heatFr = taylorQ / (density0 * heatCap)
C **********************************************************************  
C Define precision of the Newton-Raphson algorithm
C Depending on the type of solver : explicit or explicit_dp
      TolNR = TolNRSP
      if (j_sys_Dimension .eq. 2) TolNR = TolNRDP
C **********************************************************************  
C If first increment, only compute the elastic part of the 
C constitutive law. 
C This is mainly for internal use of the Abaqus software when
C package is running
C Check number of material properties
      if (stepTime .eq. 0.0) then
        if (nprops .ne. neednprops) then
          write (*,*) "Vumat subroutine needs ",
     1      neednprops," material propreties"
          write (*,*) "While ",
     1      nprops," are declared in the .inp file"
          call exit (-1)
        end if
C Check number of state variables
        if (nstatev .ne. neednstatev) then
          write (*,*) "Vumat subroutine needs ",
     1      neednstatev," state variables"
          write (*,*) "While ",
     1      nstatev," are declared in the .inp file"
          call exit (-1)
        end if
C Printout material proprerties for debug analysis
        write (*,*)"Summary of the parameters for the constitutive law"
        write (*,*) "Elastic properties"
        write (*,*) "E=", Young
        write (*,*) "nu=", xnu
        write (*,*) "Johnson-Cook parameters"
        write (*,*) "A=", parA
        write (*,*) "B=", parB
        write (*,*) "C=", parC
        write (*,*) "n=", parn
        write (*,*) "m=", parm
        write (*,*) "deps0=", pardepsp0
        write (*,*) "T0=", parT0
        write (*,*) "Tm=", parTm
        write (*,*) "tq=", taylorQ
        write (*,*) "p0=", density0
        write (*,*) "heatCap=", heatCap
        write (*,*) "coupled=", mCoupled
        write (*,*) "State dependent variables"
        write (*,*) "SDV1", stateOld(1,1)
        write (*,*) "SDV2", stateOld(1,2)
        write (*,*) "SDV3", stateOld(1,3)
        write (*,*) "SDV4", stateOld(1,4)
        write (*,*) "SDV5", stateOld(1,5)
        write (*,*) "SDV6", stateOld(1,6)
        write (*,*) "SDV7", stateOld(1,7)
        write (*,*) "General parameters"
        write (*,*) "Precision NR=",TolNR
C Check that Newton-Raphson tolerance is OK
        if (epsilon(TolNR) > TolNR) then
          write (*,*) "Precision requested for Newton-Raphson"
          write (*,*) "is better than machine precision"
          write (*,*) "Please change precision definition in parameters"
          write (*,*) "subroutine aborded..."
          call exit (-1)
        end if
        do k = 1, nblock
C Trace of the strain increment tensor
          deps3 = strainInc(k,1) + strainInc(k,2) + strainInc(k,3)
C New stress tensor due to elastic behaviour
          stressNew(k,1) = stressOld(k,1) 
     1     + twoG * strainInc(k,1) + alamda * deps3
          stressNew(k,2) = stressOld(k,2)
     1     + twoG * strainInc(k,2) + alamda * deps3
          stressNew(k,3) = stressOld(k,3)
     1     + twoG * strainInc(k,3) + alamda * deps3
          stressNew(k,4) = stressOld(k,4) + twoG * strainInc(k,4)
          if (nshr .gt. 1) then
            stressNew(k,5) = stressOld(k,5) + twoG * strainInc(k,5)
            stressNew(k,6) = stressOld(k,6) + twoG * strainInc(k,6)
          end if
        end do
C **********************************************************************  
C end of first increment special case
      else
C **********************************************************************  
C Main block of constitutive equation
C Based on the Radial return algorithm
        do k = 1, nblock
C Trace of the strain increment tensor
          deps = strainInc(k,1) + strainInc(k,2) + strainInc(k,3)
C Compute pressure and deviatoric part of the current stress tensor
          p0 = (stressOld(k,1) + stressOld(k,2) + stressOld(k,3)) / 3.0
          s11 = stressOld(k,1) - p0
          s22 = stressOld(k,2) - p0
          s33 = stressOld(k,3) - p0
          s12 = stressOld(k,4)
          if (nshr .gt. 1) then
            s23 = stressOld(k,5)
            s31 = stressOld(k,6)
          end if
C Compute initial stress norm
          if (nshr .eq. 1) then
            Snorm0 = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0 * s12*s12)
          else
            Snorm0 = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0 * (s12*s12 + s23*s23 + s31*s31))
          end if
C Compute the new pressure from the strain increment
          p1 = p0 + bulk*deps
C Prediction of the stress deviator
          s11 = s11 + twoG * (strainInc(k,1) - deps/3.0) 
          s22 = s22 + twoG * (strainInc(k,2) - deps/3.0)
          s33 = s33 + twoG * (strainInc(k,3) - deps/3.0)
          s12 = s12 + twoG * strainInc(k,4)
          if (nshr .gt. 1) then
            s23 = s23 + twoG * strainInc(k,5)
            s31 = s31 + twoG * strainInc(k,6)
          end if
C Compute stress norm
          if (nshr .eq. 1) then
            Snorm = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0 * s12*s12)
          else
            Snorm = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0 * (s12*s12 + s23*s23 + s31*s31))
          end if
C Compute J2 equivalent stress
          Strial = sqrt32 * Snorm
C **********************************************************************  
C Compute the Constitutive law equivalent stress due to plastic flow
C ********************************************************************** 
C Get the current temperature at the beginning of the increment
          if (mCoupled .eq. 0) then
            tempInit = stateOld(k,5)
          else
            tempInit = tempOld(k)
          end if  
          temp = tempInit
C Get the previous values of plastic strain and plastic strain increment          
          epsp = stateOld(k,1)
          depsp = stateOld(k,2)
C Initialize gamma value to zero
          gamma = 0.0
C Get the previously stored yield stress of the material
          yield = stateOld(k,4)
C If the yield stress is zero
C compute the first yield stress thank's to the constitutive law
C using the default initial value of gamma
          if (yield .eq. 0.0) then
            yield = yieldStress(gammaInitial, gammaInitial/dt, temp,
     1        parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
          end if
C Initialize the iterate counter
          iterate = 0
          iBissection = 0
C **********************************************************************  
C Plasticity criterion test and begin of plastic corrector
C **********************************************************************  
          if (Strial > yield) then
C Minimum value of Gamma
            gammaMin = 0.0         
C Maximum value of Gamma
            gammaMax = Strial / twoG32
C Initialize gamma to the last value except if epsp = 0.0
            gamma = stateOld(k,3)
C If epsp=0 set gamma to the default initial value of gamma
            if (epsp .eq. 0.0) gamma = sqrt32 * gammaInitial
C Update the values of epsp, depsp and temp for next loop
            depsp = sqrt23 * gamma / dt
            epsp = stateOld(k,1) + sqrt23 * gamma
            temp = tempInit + 0.5 * gamma * heatFr * 
     1        (sqrt23 * yield + Snorm0)
C Initialisations for the Newton-Raphson routine
            irun = 1
C Main loop for the Newton-Raphson procedure
            do while (irun .eq. 1)
C Compute yield stress and hardening parameter
              yield = yieldStress(epsp, depsp, temp,
     1          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute the radial return equation for isotropic case
              fun = Strial - gamma*twoG32 - yield
C Reduce the range of solution depending on the sign of fun
              if (fun < 0.0) then
                gammaMax = gamma
              else
                gammaMin = gamma
              endif
C Compute three hardening parameters
              hardEpsp = yieldHardEpsp(epsp, depsp, temp,
     1          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
              hardDepsp = yieldHardDepsp(epsp, depsp, temp,
     1          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
              hardTemp = yieldHardTemp(epsp, depsp, temp,
     1          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
C Compute the hardening coefficient
              hard = hardEpsp + hardDepsp/dt + heatFr * yield * hardTemp
C Compute derivative of the radial return equation for isotropic case
              dfun = twoG32 + sqrt23 * hard
C Compute the increment of the gamma parameter
              dgamma = fun/dfun
C Increment on the gamma value for Newton-Raphson
              gamma = gamma + dgamma
C If solution is outside of the brackets do one bisection step
              if ((gammaMax - gamma) * (gamma - gammaMin) < 0.0) then
                dgamma = 0.5 * (gammaMax - gammaMin)
                gamma = gammaMin + dgamma
                iBissection = iBissection + 1
              end if
C Algorithm converged, end of computations
              if (abs(dgamma) < tolNR) irun = 0
C Update the values of epsp, depsp and temp for next loop
              depsp = sqrt23 * gamma / dt
              epsp = stateOld(k,1) + sqrt23 * gamma
              temp = tempInit + 0.5 * gamma * heatFr * 
     1          (sqrt23 * yield + Snorm0)
C Increase the number of iterations
              iterate = iterate + 1
              if (iterate > itMax) then
C Break with no convergence !!
                write (*,*) "NO CONVERGENCE in Newton-Raphson"
                write (*,*) "After", iterate, "iterations"
                write (*,*) "Time", stepTime, dt
                write (*,*) "Precision", abs(fun/yield)
                write (*,*) "Strial", Strial
                write (*,*) "Gamma0", stateOld(k,3)
                write (*,*) "Gamma", gamma
                write (*,*) "Gamma M", gammaMin, gammaMax
                write (*,*) "DGamma", dgamma
                write (*,*) "epsp0", stateOld(k,1)+sqrt23*stateOld(k,3)
                write (*,*) "depsp0", sqrt23*stateOld(k,3)/dt
                write (*,*) "epsp", epsp
                write (*,*) "depsp", depsp
                write (*,*) "temp", temp
                write (*,*) "hardEpsp", hardEpsp
                write (*,*) "hardDepsp", hardDepsp
                write (*,*) "hardTemp", hardTemp
                write (*,*) "old sdv1", stateOld(k,1)
                write (*,*) "old sdv2", stateOld(k,2)
                write (*,*) "old sdv3", stateOld(k,3)
                write (*,*) "old sdv4", stateOld(k,4)
                write (*,*) "old sdv5", stateOld(k,5)
                call EXIT(-1)
              end if
            end do
C **********************************************************************  
C End of Newton-Raphson procedure
C **********************************************************************  
C Compute the new stress tensor
            xcor = (1.0 - twoG * gamma / Snorm)
            s11 = s11 * xcor
            s22 = s22 * xcor
            s33 = s33 * xcor
            s12 = s12 * xcor
            if (nshr .gt. 1) then
              s23 = s23 * xcor
              s31 = s31 * xcor
            end if            
          end if
C **********************************************************************  
C End of Plastic correction algorithm
C **********************************************************************  
C Store the new plastic strain and plastic strain rate
          stateNew(k,1) = epsp
          stateNew(k,2) = depsp
C Store the value of gamma for next plastic step
          stateNew(k,3) = gamma
C Store the new yield stress of the material
          stateNew(k,4) = yield
C Store the number of Newton-Raphson iterations
          stateNew(k,6) = stateOld(k,6) + iterate
C Store the number of Bissection steps
          stateNew(k,7) = stateOld(k,7) + iBissection
C Store the new stress tensor
          stressNew(k,1) = s11 + p1
          stressNew(k,2) = s22 + p1
          stressNew(k,3) = s33 + p1
          stressNew(k,4) = s12
          if (nshr .gt. 1) then
            stressNew(k,5) = s23
            stressNew(k,6) = s31
          end if
C Compute the new specific internal energy
          if (nshr .eq. 1) then
            stressPower = 0.5 * (
     1        (stressOld(k,1) + stressNew(k,1)) * strainInc(k,1)
     2        + (stressOld(k,2) + stressNew(k,2)) * strainInc(k,2)
     3        + (stressOld(k,3) + stressNew(k,3)) * strainInc(k,3)
     4        + 2.0*(stressOld(k,4) + stressNew(k,4)) * strainInc(k,4))
          else
            stressPower = 0.5 * (
     1        (stressOld(k,1) + stressNew(k,1)) * strainInc(k,1)
     2        + (stressOld(k,2) + stressNew(k,2)) * strainInc(k,2)
     3        + (stressOld(k,3) + stressNew(k,3)) * strainInc(k,3)
     4        + 2.0*(stressOld(k,4) + stressNew(k,4)) * strainInc(k,4)
     5        + 2.0*(stressOld(k,5) + stressNew(k,5)) * strainInc(k,5)
     6        + 2.0*(stressOld(k,6) + stressNew(k,6)) * strainInc(k,6))
          end if
C Store the new specific internal energy
          enerInternNew(k) = enerInternOld(k) + stressPower / density(k)
C Compute the new dissipated inelastic specific energy
          if (gamma .eq. 0.0) then
C Transfer the old value of the inelastic specific energy
            enerInelasNew(k) = enerInelasOld(k)
C Transfer the old value of the temperature
            stateNew(k,5) = tempInit
          else
            if (nshr .eq. 1) then
              plWorkInc = 0.5 * gamma*(sqrt(s11*s11 + s22*s22 + s33*s33 
     1          + 2.0*s12*s12) + Snorm0)
            else
              plWorkInc = 0.5 * gamma*(sqrt(s11*s11 + s22*s22 + s33*s33 
     1          + 2.0*(s12*s12 + s23*s23 + s31*s31)) + Snorm0)
            end if
C Store the new dissipated inelastic specific energy
            enerInelasNew(k) = enerInelasOld(k) + plWorkInc / density(k)
C Store the new temperature
            stateNew(k,5) = tempInit + heatFr * plWorkInc
          end if
        end do
      end if
      return
      end
