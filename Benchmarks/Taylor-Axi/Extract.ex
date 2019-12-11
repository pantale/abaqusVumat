# Built-in model
TimeHistory, job=Taylor_BI, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_BI, value=PEEQ, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_BI, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_BI, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_BI, value=DT, name=dt, region=Assembly ASSEMBLY

# VUHARD routine
TimeHistory, job=Taylor_VH, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VH, value=PEEQ, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VH, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VH, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VH, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Analytical Newton-Raphson
TimeHistory, job=Taylor_VA, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VA, value=SDV1, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VA, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VA, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VA, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Numerical Newton-Raphson
TimeHistory, job=Taylor_VN, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VN, value=SDV1, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VN, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VN, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VN, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Bisection
TimeHistory, job=Taylor_VB, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VB, value=SDV1, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VB, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VB, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VB, value=DT, name=dt, region=Assembly ASSEMBLY

# VUMAT Direct
TimeHistory, job=Taylor_VD, value=MISES, name=mises, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VD, value=SDV1, name=peeq, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VD, value=TEMP, name=temp, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VD, value=DENSITY, name=density, region=Element CYLINDER-1.1 Int Point 1
TimeHistory, job=Taylor_VD, value=DT, name=dt, region=Assembly ASSEMBLY

