# Global parameters
Parameters, xscale=1000, xname=$Horizontal\ displacement\ along\ x\ axis\ (mm)$, marksnumber=15, title=$One\ Element\ Torus\ Test$, crop=True

# Temperature curve
Temperature, yname=$Temperature\ in\ ^{\circ}C$, legendlocate=bottomright, removename=-temp, Torus_VA_temp.plot, Torus_VN_temp.plot, Torus_VH_temp.plot, Torus_VB_temp.plot, Torus_VD_temp.plot, Torus_BI_temp.plot

# Plastic strain curve
PlasticStrain, yname=$Equivalent\ plastic\ strain\ \overline{\varepsilon}^{p}$, legendlocate=bottomright, removename=-peeq, Torus_VA_peeq.plot, Torus_VN_peeq.plot, Torus_VH_peeq.plot, Torus_VB_peeq.plot, Torus_VD_peeq.plot, Torus_BI_peeq.plot

# von Mises curve
VonMises, yname=$von\ Mises\ stress\ \overline{\sigma}$, legendlocate=bottomright, removename=-mises, Torus_VA_mises.plot, Torus_VN_mises.plot, Torus_VH_mises.plot, Torus_VB_mises.plot, Torus_VD_mises.plot, Torus_BI_mises.plot

# Density curve
Density, yname=$Density \rho$, legendlocate=topright, removename=-density, Torus_VA_density.plot, Torus_VN_density.plot, Torus_VH_density.plot, Torus_VB_density.plot, Torus_VD_density.plot, Torus_BI_density.plot

# Timestep curve
TimeStep, yname=$TimeStep\ increment\ \Delta t$, legendlocate=topright, removename=-dt, Torus_VA_dt.plot, Torus_VN_dt.plot, Torus_VH_dt.plot, Torus_VB_dt.plot, Torus_VD_dt.plot, Torus_BI_dt.plot



