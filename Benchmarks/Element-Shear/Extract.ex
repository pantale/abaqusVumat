# Built-in model
TimeHistory, job=Shear_BI, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_BI, value=PEEQ, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_BI, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_BI, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_BI, value=DT, name=dt, region=Assembly ASSEMBLY

# VUHARD routine
TimeHistory, job=Shear_VH, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VH, value=PEEQ, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VH, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VH, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VH, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Analytical Newton-Raphson
TimeHistory, job=Shear_VA, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VA, value=SDV1, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VA, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VA, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VA, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Numerical Newton-Raphson
TimeHistory, job=Shear_VN, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VN, value=SDV1, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VN, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VN, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VN, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Bisection
TimeHistory, job=Shear_VB, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VB, value=SDV1, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VB, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VB, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VB, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Direct
TimeHistory, job=Shear_VD, value=MISES, name=mises, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VD, value=SDV1, name=peeq, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VD, value=TEMP, name=temp, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VD, value=DENSITY, name=density, region=Element SQUARE-1.1 Int Point 1
TimeHistory, job=Shear_VD, value=DT, name=dt, region=Assembly ASSEMBLY

