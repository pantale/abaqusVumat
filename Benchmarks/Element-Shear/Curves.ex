# Global parameters
Parameters, xscale=1000, xname=$Horizontal\ displacement\ along\ x\ axis\ (mm)$, marksnumber=15, title=$One\ Element\ Shear\ Test$, crop=True

# Temperature curve
Temperature, yname=$Temperature\ in\ ^{\circ}C$, legendlocate=bottomright, removename=-temp, Shear_VA_temp.plot, Shear_VN_temp.plot, Shear_VH_temp.plot, Shear_VB_temp.plot, Shear_VD_temp.plot, Shear_BI_temp.plot

# Plastic strain curve
PlasticStrain, yname=$Equivalent\ plastic\ strain\ \overline{\varepsilon}^{p}$, legendlocate=bottomright, removename=-peeq, Shear_VA_peeq.plot, Shear_VN_peeq.plot, Shear_VH_peeq.plot, Shear_VB_peeq.plot, Shear_VD_peeq.plot, Shear_BI_peeq.plot

# von Mises curve
VonMises, yname=$von\ Mises\ stress\ \overline{\sigma}$, legendlocate=bottomright, removename=-mises, Shear_VA_mises.plot, Shear_VN_mises.plot, Shear_VH_mises.plot, Shear_VB_mises.plot, Shear_VD_mises.plot, Shear_BI_mises.plot

# Density curve
Density, yname=$Density \rho$, legendlocate=topright, removename=-density, Shear_VA_density.plot, Shear_VN_density.plot, Shear_VH_density.plot, Shear_VB_density.plot, Shear_VD_density.plot, Shear_BI_density.plot

# Timestep curve
TimeStep, yname=$TimeStep\ increment\ \Delta t$, legendlocate=topright, removename=-dt, Shear_VA_dt.plot, Shear_VN_dt.plot, Shear_VH_dt.plot, Shear_VB_dt.plot, Shear_VD_dt.plot, Shear_BI_dt.plot



