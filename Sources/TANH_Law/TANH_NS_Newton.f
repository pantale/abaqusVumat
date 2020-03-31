C **********************************************************************
C Function to compute the TANH yield stress
C **********************************************************************
      function yieldStress (
C Parameters
     1 epsp, depsp, temp,
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, parTrec
     3 parp, parq, epsp00 )
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
C tanh(T)
      tanhT = tanh(((temp - parT0) / (parTrec - parT0))**parq)      
C part D      
      partD = 1.0 - tanhT * parp * epsp / (1.0 + parp * epsp)
C Compute and return the yield stress
      yieldStress =  hardPart * viscPart * tempPart * (partD + 
     1  (1 - partD) * tanh(1 / ( epsp + epsp00 ))) 
      return
      end

C **********************************************************************
C Function to compute the TANH hardening
C **********************************************************************
      function yieldHardNS (
C Parameters
     1 epsp, depsp, temp, dt,  
C Constants of the constitutive law
     2 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, parTrec
     3 parp, parq, epsp00  )
      include 'vaba_param.inc'
C epspForward and depspForward
      deltaSP = 1.0e-4
      deltaDP = 1.0e-8      
      delta = deltaSP
      if (j_sys_Dimension .eq. 2) delta = deltaDP
      epspForward = epsp + delta
      depspForward = depsp + delta
C derivative versus strain
      yieldStrain = yieldStress ( epspForward, depsp, temp,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, parTrec
     2 parp, parq, epsp00  )
c     
      yield = yieldStress ( epsp, depsp, temp,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, parTrec
     2 parp, parq, epsp00  )
c     
      hard1 = (yieldStrain - yield) / delta
C derivative versus strain rate
      yieldRate = yieldStress ( epsp, depspForward, temp,
     1 parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, parTrec
     2 parp, parq, epsp00  )
c     
      hard2 = (yieldRate - yield) / delta
C DyieldStress and yieldHardNS
      yieldHardNS = hard1 + hard2 / dt                                               
      return
      end                  
      
C **********************************************************************
C J2 Mises Plasticity with isotropic Johnson-Cook hardening for plane 
C strain case and 3D case.
C Elastic predictor, radial corrector algorithm.
C
C The state variables are stored as:
C      STATE(*,1) = equivalent plastic strain
C      STATE(*,2) = equivalent plastic strain rate
C      STATE(*,3) = percentage of plasticity of last plastic increment
C      STATE(*,4) = yield stress of the material
C      STATE(*,5) = number of Newton-Raphson iterations for information
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
     5  stressNew, stateNew, enerInternNew, enerInelasNew )
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
     8  defgradNew(nblock,ndir+nshr+nshr),
     9  fieldNew(nblock,nfieldv),
     1  stressNew(nblock,ndir+nshr), stateNew(nblock,nstatev),
     2  enerInternNew(nblock), enerInelasNew(nblock)
C
      character*80 cmname
C
      parameter (itMax = 250, TolNRSP = 1.0e-4, TolNRDP = 1.0e-8, 
     1   gammaInitial = 1.0e-10,
     2   sqrt23 = 0.81649658092772603273242802490196,
     3   sqrt32 = 1.2247448713915890490986420373529)
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
      parTrec   = props(11)
      parp      = props(12)
      parq      = props(13)
      epsp00    = props(14)
C **********************************************************************  
      twoG = Young / (1.0 + xnu)
      twoG32 = sqrt32*twoG
      alamda = xnu * twoG / (1.0 - 2.0*xnu)
      bulk = Young / (3.0*(1.0 - 2.0*xnu))
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
      if (stepTime .eq. 0.0) then
        write (*,*)"Summary of the parameters for the constitutive law"
        write (*,*) "Elastic properties"
        write (*,*) "E=",Young
        write (*,*) "nu=",xnu
        write (*,*) "Johnson-Cook parameters"
        write (*,*) "A=",parA
        write (*,*) "B=",parB
        write (*,*) "C=",parC
        write (*,*) "n=",parn
        write (*,*) "m=",parm
        write (*,*) "deps0=",pardepsp0
        write (*,*) "T0=",parT0
        write (*,*) "Tm=",parTm
        write (*,*) "Trec=",parTrec
        write (*,*) "p=",parp
        write (*,*) "q=",parq
        write (*,*) "epsp00=",epsp00        
        write (*,*) "Precision NR=",TolNR
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
     1     + twoG*strainInc(k,1) + alamda*deps3
          stressNew(k,2) = stressOld(k,2)
     1     + twoG*strainInc(k,2) + alamda*deps3
          stressNew(k,3) = stressOld(k,3)
     1     + twoG*strainInc(k,3) + alamda*deps3
          stressNew(k,4)=stressOld(k,4) + twoG*strainInc(k,4)
          if (nshr .gt. 1) then
            stressNew(k,5) = stressOld(k,5) + twoG*strainInc(k,5)
            stressNew(k,6) = stressOld(k,6) + twoG*strainInc(k,6)
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
          p0 = (stressOld(k,1) + stressOld(k,2) + stressOld(k,3))/3.0
          s11 = stressOld(k,1) - p0
          s22 = stressOld(k,2) - p0
          s33 = stressOld(k,3) - p0
          s12 = stressOld(k,4)
          if (nshr .gt. 1) then
            s23 = stressOld(k,5)
            s31 = stressOld(k,6)
          end if
C Compute the new pressure from the strain increment
          p1 = p0 + bulk*deps
C Prediction of the stress deviator
          s11 = s11 + twoG*(strainInc(k,1) - deps/3.0) 
          s22 = s22 + twoG*(strainInc(k,2) - deps/3.0)
          s33 = s33 + twoG*(strainInc(k,3) - deps/3.0)
          s12 = s12 + twoG*strainInc(k,4)
          if (nshr .gt. 1) then
            s23 = s23 + twoG*strainInc(k,5)
            s31 = s31 + twoG*strainInc(k,6)
          end if
C Compute stress norm
          if (nshr .eq. 1) then
            Snorm = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0*s12*s12)
          else
            Snorm = sqrt(s11*s11 + s22*s22 + s33*s33 + 
     1        2.0*(s12*s12 + s23*s23 + s31*s31))
          end if
C Compute J2 equivalent stress
          Strial = sqrt32*Snorm
C **********************************************************************  
C Compute the Constitutive law equivalent stress due to plastic flow
C ********************************************************************** 
C Compute the mean value of the temperature during the increment
          temp = (tempOld(k) + tempNew(k))/2.0
C Transfer the value of gamma to next step
          stateNew(k,3) = stateOld(k,3)
C Initialize gamma value to zero
          gamma = 0.0
C Get the previously stored yield stress of the material
          yield = stateOld(k,4)
C If the yield stress is zero
C compute the first yield stress thank's to the constitutive law
C using the default initial value of gamma
          if (yield .eq. 0.0) then
            yield = yieldStress(gammaInitial, gammaInitial/dt, temp,
     1        parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, 
     2        parTrec, parp, parq, epsp00 )
          end if
C Initialize the iterate counter
          iterate = 0
C **********************************************************************  
C Plasticity criterion test and begin of plastic corrector
C **********************************************************************  
          if (Strial > yield) then
C Minimum value of Gamma
            gammaMin = 0.0         
C Maximum value of Gamma
            gammaMax = (Strial - yield) / twoG32
            gammaMax0 = gammaMax
C Set the predicted plastic increment by interpolation
            gamma = stateOld(k,3) * gammaMax
C If first plastic increment, initialise value of gamma
            if (gamma .eq. 0.0) gamma = 0.5 * gammaMax
C Update the values of epsp and depsp for next loop
            depsp = sqrt23*gamma/dt
            epsp = stateOld(k,1) + sqrt23*gamma
C Initialisations for the Newton-Raphson routine
            irun = 1
C Main loop for the Newton-Raphson procedure
            do while (irun .eq. 1)
C Compute yield stress and hardening parameter
              yield =yieldStress ( epsp, depsp, temp,
     2          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm, 
     3          parTrec, parp, parq, epsp00 )
C Compute the radial return equation for isotropic case
              fun = Strial - gamma*twoG32 - yield
C Reduce the range of solution depending on the sign of fun
              if (fun < 0.0) then
                gammaMax = gamma
              else
                gammaMin = gamma
              endif
C Compute hardening parameter
              hard = yieldHardNS(epsp, depsp, temp, dt,
     2          parA, parB, parC, parn, parm, pardepsp0, parT0, parTm,
     3          parTrec, parp, parq, epsp00)
C Compute derivative of the radial return equation for isotropic case
              dfun = -twoG32 - sqrt23*hard
C Compute the increment of the gamma parameter
              dgamma = -fun/dfun
C Test if flat zone
              if (dfun .eq. 0.0) dgamma = gammaMax - gammaMin
C Increment on the gamma value for Newton-Raphson
              gamma = gamma + dgamma
C If solution is outside of the brackets
              if ((gammaMax - gamma) * (gamma - gammaMin) < 0.0) then
                dgamma = 0.5 * (gammaMax - gammaMin)
                gamma = gammaMin + dgamma
              end if
C Algorithm converged, end of computations
              if (abs(dgamma) < tolNR) irun = 0
C Update the values of epsp and depsp for next loop
              depsp = sqrt23*gamma/dt
              epsp = stateOld(k,1) + sqrt23*gamma
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
                write (*,*) "y0", yieldStress(stateOld(k,1) + 
     1            sqrt23*stateOld(k,3), sqrt23*stateOld(k,3)/dt, temp,
     2            parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
                write (*,*) "h0", yieldHardNS(stateOld(k,1) + sqrt23*
     1            stateOld(k,3), sqrt23*stateOld(k,3)/dt, temp, dt,
     2            parA, parB, parC, parn, parm, pardepsp0, parT0, parTm)
                write (*,*) "y1", yieldStress ( epsp, depsp, temp,
     1            parA, parB, parC, parn, parm, pardepsp0, parT0, parTm,
     2            parTrec, parp, parq, epsp00 )
                write (*,*) "h1", yieldHardNS(epsp, depsp, temp, dt,
     1            parA, parB, parC, parn, parm, pardepsp0, parT0, parTm,
     2            parTrec, parp, parq, epsp00)
                call EXIT(-1)
              end if
            end do
C **********************************************************************  
C End of Newton-Raphson procedure
C **********************************************************************  
C Compute the normal tensor to the plastic surface
            xn11 = s11/Snorm
            xn22 = s22/Snorm
            xn33 = s33/Snorm
            xn12 = s12/Snorm
            if (nshr .gt. 1) then
              xn23 = s23/Snorm
              xn31 = s31/Snorm
            end if
C Compute the new stress tensor
            s11 = s11 - twoG*gamma*xn11
            s22 = s22 - twoG*gamma*xn22
            s33 = s33 - twoG*gamma*xn33
            s12 = s12 - twoG*gamma*xn12
            if (nshr .gt. 1) then
              s23 = s23 - twoG*gamma*xn23
              s31 = s31 - twoG*gamma*xn31
            end if            
C Store the plastic percentage for next plastic step
            stateNew(k,3) = gamma / gammaMax0
          end if
C **********************************************************************  
C End of Plastic correction algorithm
C **********************************************************************  
C Store the new plastic strain and plastic strain rate
          stateNew(k,1) = stateOld(k,1) + sqrt23*gamma
          stateNew(k,2) = sqrt23*gamma/dt
C Store the new yield stress of the material
C          stateNew(k,4) = max(yield,stateOld(k,4))
          stateNew(k,4) = yield
C Store the total number of iterations
          stateNew(k,5) = stateOld(k,5) + iterate
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
            stressPower = 0.5*(
     1        (stressOld(k,1) + stressNew(k,1)) * strainInc(k,1)
     1        + (stressOld(k,2) + stressNew(k,2)) * strainInc(k,2)
     1        + (stressOld(k,3) + stressNew(k,3)) * strainInc(k,3)
     1        + 2.0*(stressOld(k,4) + stressNew(k,4)) * strainInc(k,4))
          else
            stressPower = 0.5*(
     1        (stressOld(k,1) + stressNew(k,1)) * strainInc(k,1)
     1        + (stressOld(k,2) + stressNew(k,2)) * strainInc(k,2)
     1        + (stressOld(k,3) + stressNew(k,3)) * strainInc(k,3)
     1        + 2.0*(stressOld(k,4) + stressNew(k,4)) * strainInc(k,4)
     1        + 2.0*(stressOld(k,5) + stressNew(k,5)) * strainInc(k,5)
     1        + 2.0*(stressOld(k,6) + stressNew(k,6)) * strainInc(k,6))
          end if
C Store the new specific internal energy
          enerInternNew(k) = enerInternOld(k) + stressPower/density(k)
C Compute the new dissipated inelastic specific energy
          if (gamma .eq. 0.0) then
C Transfer the old value of the inelastic specific energy
            enerInelasNew(k) = enerInelasOld(k)
          else
            if (nshr .eq. 1) then
              plWorkInc = sqrt23*gamma*sqrt(3.0/2.0*
     1          (s11*s11 + s22*s22 + s33*s33 + 2.0*s12*s12))
            else
              plWorkInc = sqrt23*gamma*sqrt(3.0/2.0*
     1          (s11*s11 + s22*s22 + s33*s33 
     2          + 2.0*(s12*s12 + s23*s23 + s31*s31)))
            end if
C Store the new dissipated inelastic specific energy
            enerInelasNew(k) = enerInelasOld(k) + plWorkInc/density(k)
          end if
        end do
      end if
      return
      end
