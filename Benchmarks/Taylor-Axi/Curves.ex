# Global parameters
Parameters, xrange=7, xname=$Elongation\ of\ the\ end\ of\ the\ bar\ (mm)$, marksnumber=15, title=$Bar\ Necking\ Benchmark\ Test$, crop=True

# Temperature curve
Temperature, yname=$Temperature\ in\ ^{\circ}C$, legendlocate=bottomright, removename=-temp, Taylor_VA_temp.plot, Taylor_VN_temp.plot, Taylor_VH_temp.plot, Taylor_VB_temp.plot, Taylor_VD_temp.plot, Taylor_BI_temp.plot

# Plastic strain curve
PlasticStrain, yname=$Equivalent\ plastic\ strain\ \overline{\varepsilon}^{p}$, legendlocate=bottomright, removename=-peeq, Taylor_VA_peeq.plot, Taylor_VN_peeq.plot, Taylor_VH_peeq.plot, Taylor_VB_peeq.plot, Taylor_VD_peeq.plot, Taylor_BI_peeq.plot

# von Mises curve
VonMises, yname=$von\ Mises\ stress\ \overline{\sigma}$, legendlocate=bottomright, removename=-mises, Taylor_VA_mises.plot, Taylor_VN_mises.plot, Taylor_VH_mises.plot, Taylor_VB_mises.plot, Taylor_VD_mises.plot, Taylor_BI_mises.plot

# Density curve
Density, yname=$Density \rho$, legendlocate=topright, removename=-density, Taylor_VA_density.plot, Taylor_VN_density.plot, Taylor_VH_density.plot, Taylor_VB_density.plot, Taylor_VD_density.plot, Taylor_BI_density.plot

# Timestep curve
TimeStep, yname=$TimeStep\ increment\ \Delta t$, legendlocate=topright, removename=-dt, Taylor_VA_dt.plot, Taylor_VN_dt.plot, Taylor_VH_dt.plot, Taylor_VB_dt.plot, Taylor_VD_dt.plot, Taylor_BI_dt.plot



