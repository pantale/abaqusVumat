# Global parameters
Parameters, xscale=1000, xname=$Horizontal\ displacement\ along\ x\ axis\ (mm)$, marksnumber=15, title=$One\ Element\ Radial\ Test$, crop=True

# Temperature curve
Temperature, yname=$Temperature\ in\ ^{\circ}C$, legendlocate=bottomright, removename=-temp, Radial_VA_temp.plot, Radial_VN_temp.plot, Radial_VH_temp.plot, Radial_VB_temp.plot, Radial_VD_temp.plot, Radial_BI_temp.plot

# Plastic strain curve
PlasticStrain, yname=$Equivalent\ plastic\ strain\ \overline{\varepsilon}^{p}$, legendlocate=bottomright, removename=-peeq, Radial_VA_peeq.plot, Radial_VN_peeq.plot, Radial_VH_peeq.plot, Radial_VB_peeq.plot, Radial_VD_peeq.plot, Radial_BI_peeq.plot

# von Mises curve
VonMises, yname=$von\ Mises\ stress\ \overline{\sigma}$, legendlocate=bottomright, removename=-mises, Radial_VA_mises.plot, Radial_VN_mises.plot, Radial_VH_mises.plot, Radial_VB_mises.plot, Radial_VD_mises.plot, Radial_BI_mises.plot

# Density curve
Density, yname=$Density \rho$, legendlocate=topright, removename=-density, Radial_VA_density.plot, Radial_VN_density.plot, Radial_VH_density.plot, Radial_VB_density.plot, Radial_VD_density.plot, Radial_BI_density.plot

# Timestep curve
TimeStep, yname=$TimeStep\ increment\ \Delta t$, legendlocate=topright, removename=-dt, Radial_VA_dt.plot, Radial_VN_dt.plot, Radial_VH_dt.plot, Radial_VB_dt.plot, Radial_VD_dt.plot, Radial_BI_dt.plot



