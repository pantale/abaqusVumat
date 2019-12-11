# List of subdirectories
# Element tests
SUBDIRS = Element-Radial Element-Shear Element-Shear-Elastic Element-Torus 
# Bar Necking
SUBDIRS += Bar-Necking Bar-Necking-Fine
# Bar Necking
SUBDIRS += Taylor-Axi Taylor-3D Taylor-3D-Fine

# Nothing to touch here after

# Store current path
HERE = $(PWD)

all:
	@for SUBDIR in $(SUBDIRS); do cd $(HERE)/$$SUBDIR; make; done
	
clean:
	@for SUBDIR in $(SUBDIRS); do cd $(HERE)/$$SUBDIR; make clean; done

subclean:
	@for SUBDIR in $(SUBDIRS); do cd $(HERE)/$$SUBDIR; make subclean; done


