# Abaqus file to treat
BI_MODEL = BarNecking_BI
VH_MODEL = BarNecking_VH
VU_MODEL = BarNecking_V
VUMAT_NR = BarNecking_VA
VUMAT_NNR = BarNecking_VN
VUMAT_D = BarNecking_VD
VUMAT_B = BarNecking_VB

# Nothing to touch here after
FILES_TARGET = $(BI_MODEL) $(VH_MODEL) $(VUMAT_NR) $(VUMAT_NNR) $(VUMAT_D) $(VUMAT_B)
CPULOG = CPU-Times.log

all:
	# Clean the CPU log file
	@rm -f $(CPULOG)
	# Run Abaqus build-in model
	abaqus job=$(BI_MODEL) double=both interactive ask_delete=OFF
	echo "Summary of Built-In Model" >> $(CPULOG)
	tail -n11 $(BI_MODEL).sta | head -n1 >> $(CPULOG)
	# Run VUHARD model
	abaqus job=$(VH_MODEL) user=../../Sources/VUHARD.f double=both interactive ask_delete=OFF
	echo "Summary of VUHARD Model" >> $(CPULOG)
	tail -n11 $(VH_MODEL).sta | head -n1 >> $(CPULOG)
	# VUMAT Analytical Newton-Raphson
	abaqus job=$(VUMAT_NR) input=$(VU_MODEL) user=../../Sources/VUMAT-NR.f double=both interactive ask_delete=OFF
	echo "Summary of A-N-R Model" >> $(CPULOG)
	tail -n11 $(VUMAT_NR).sta | head -n1 >> $(CPULOG)
	# VUMAT Numerical Newton-Raphson
	abaqus job=$(VUMAT_NNR) input=$(VU_MODEL) user=../../Sources/VUMAT-NR-NS.f double=both interactive ask_delete=OFF
	echo "Summary of N-N-R Model" >> $(CPULOG)
	tail -n11 $(VUMAT_NNR).sta | head -n1 >> $(CPULOG)
	# VUMAT Direct
	abaqus job=$(VUMAT_D) input=$(VU_MODEL) user=../../Sources/VUMAT-Direct.f double=both interactive ask_delete=OFF
	echo "Summary of Direct Model" >> $(CPULOG)
	tail -n11 $(VUMAT_D).sta | head -n1 >> $(CPULOG)
	# VUMAT Bisection
	abaqus job=$(VUMAT_B) input=$(VU_MODEL) user=../../Sources/VUMAT-Bisection.f double=both interactive ask_delete=OFF
	echo "Summary of Bissection Model" >> $(CPULOG)
	tail -n11 $(VUMAT_B).sta | head -n1 >> $(CPULOG)
	# Clean files
	@for FILE in $(FILES_TARGET); do rm -f $$FILE.abq $$FILE.com $$FILE.dat $$FILE.mdl $$FILE.msg $$FILE.pac $$FILE.prt $$FILE.res $$FILE.sel $$FILE.sta $$FILE.stt ; done
	abaqus python ../Python/AbaqusExtract.py
	python ../Python/replaceString.py $(VUMAT_NR) $(VUMAT_NR)_ A-N-R-
	python ../Python/replaceString.py $(VUMAT_NNR) $(VUMAT_NNR)_ N-N-R-
	python ../Python/replaceString.py $(VH_MODEL) $(VH_MODEL)_ VUHARD-
	python ../Python/replaceString.py $(VUMAT_D) $(VUMAT_D)_ Direct-
	python ../Python/replaceString.py $(VUMAT_B) $(VUMAT_B)_ Bisection-
	python ../Python/replaceString.py $(BI_MODEL) $(BI_MODEL)_ Built-in-
	python ../Python/PlotCurves.py 

clean:
	@echo "Cleaning: $(PWD)"
	@rm -f *.odb *.plot

subclean: clean

