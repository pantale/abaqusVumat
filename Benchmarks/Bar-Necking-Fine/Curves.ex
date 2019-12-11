# Global parameters
Parameters, xrange=7, xname=$Elongation\ of\ the\ end\ of\ the\ bar\ (mm)$, marksnumber=15, title=$Bar\ Necking\ Benchmark\ Test$, crop=True

# Temperature curve
Temperature, yname=$Temperature\ in\ ^{\circ}C$, legendlocate=bottomright, removename=-temp, BarNecking_VA_temp.plot, BarNecking_VN_temp.plot, BarNecking_VH_temp.plot, BarNecking_VB_temp.plot, BarNecking_VD_temp.plot, BarNecking_BI_temp.plot

# Plastic strain curve
PlasticStrain, yname=$Equivalent\ plastic\ strain\ \overline{\varepsilon}^{p}$, legendlocate=bottomright, removename=-peeq, BarNecking_VA_peeq.plot, BarNecking_VN_peeq.plot, BarNecking_VH_peeq.plot, BarNecking_VB_peeq.plot, BarNecking_VD_peeq.plot, BarNecking_BI_peeq.plot

# von Mises curve
VonMises, yname=$von\ Mises\ stress\ \overline{\sigma}$, legendlocate=bottomright, removename=-mises, BarNecking_VA_mises.plot, BarNecking_VN_mises.plot, BarNecking_VH_mises.plot, BarNecking_VB_mises.plot, BarNecking_VD_mises.plot, BarNecking_BI_mises.plot

# Density curve
Density, yname=$Density \rho$, legendlocate=topright, removename=-density, BarNecking_VA_density.plot, BarNecking_VN_density.plot, BarNecking_VH_density.plot, BarNecking_VB_density.plot, BarNecking_VD_density.plot, BarNecking_BI_density.plot

# Timestep curve
TimeStep, yname=$TimeStep\ increment\ \Delta t$, legendlocate=topright, removename=-dt, BarNecking_VA_dt.plot, BarNecking_VN_dt.plot, BarNecking_VH_dt.plot, BarNecking_VB_dt.plot, BarNecking_VD_dt.plot, BarNecking_BI_dt.plot



