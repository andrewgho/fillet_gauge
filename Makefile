# Makefile - create STL files from OpenSCAD source
# Andrew Ho (andrew@zeuscat.com)

ifeq ($(shell uname), Darwin)
  OPENSCAD = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
  OPENSCAD = openscad
endif

TARGETS = fillet_gauge.stl

all: $(TARGETS)

fillet_gauge.stl: fillet_gauge.scad
	$(OPENSCAD) -o fillet_gauge.stl fillet_gauge.scad

clean:
	@rm -f $(TARGETS)
