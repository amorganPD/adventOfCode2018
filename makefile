ifeq ($(OS),Windows_NT)
  ifeq ($(shell uname -s),) # not in a bash-like shell
	CLEANUP = del /F /Q
	MKDIR = mkdir
  else # in a bash-like shell, like msys
	CLEANUP = rm -f
	MKDIR = mkdir -p
  endif
	PREFIXSLASH=./
	TARGET_EXTENSION=exe
else
	PREFIXSLASH=.//
	CLEANUP = rm -f
	MKDIR = mkdir -p
	TARGET_EXTENSION=out
endif

.PHONY: clean
.PHONY: test

# Used to iterate through source list and generate compile rules
define COMPILERULE
$(addprefix $(PATHOBJ), $(subst .c,.o,$(notdir $(1)))): $(1) $(subst $(PREFIXSLASH),,$(shell find ./ -type f -name '$(subst .c,.h,$(notdir $(1)))'))
	$(COMPILE) $(1) $(CFLAGS) -o $(addprefix $(PATHOBJ), $(subst .c,.o,$(notdir $(1))))
endef

# Path declarations
# Required
PATHBUILD = tests/build/
PATHDEPENDS = tests/build/depends/
PATHOBJ = tests/build/objs/
PATHRESULTS = tests/build/results/
PATHUNITY = ../Unity/src/
PATHTESTSRC = tests/
PATHINC = $(subst inc,inc/,$(subst ./,-I,$(shell find . -type d -name 'inc')))
PATHINC += -Itests/

# START - Project dependent -------------------------------

PATHIAR =#/c/Program Files (x86)/IAR Systems/Embedded Workbench 8.0/
PATHINC_BOARD = -I../board/
# ----------------------------------------------------------
# Combine the above Path declarations into PATHINC_DEPS
PATHINC_DEPS = $(PATHINC_BOARD)

# Source File of Dependencies
# SRC_DEPENDS = ./exampleFile.c
# Objects of Dependencies
# OBJ_DEPENDS = $(PATHOBJ)exampleFile.o

# END - Project dependent ----------------------------------


# Find all Test_ source files
SRC_OFTESTS_NAMEONLY = $(notdir $(shell find ./ -type f -name 'Test_*.c'))
SRC_OFTESTS = $(subst $(PREFIXSLASH),,$(shell find ./ -type f -name 'Test_*.c'))
OBJ_OFTESTS = $(addprefix $(PATHOBJ), $(subst .c,.o,$(SRC_OFTESTS_NAMEONLY)))
# Find all of the source files that have Tests
SRC_NAMEONLY = $(subst Test_,,$(SRC_OFTESTS_NAMEONLY))
SRC = $(subst $(PREFIXSLASH),,$(foreach src,$(addprefix ',$(subst .c,.c',$(SRC_NAMEONLY))),$(shell find ./ -type f -name $(src))))
OBJ = $(addprefix $(PATHOBJ), $(subst .c,.o,$(SRC_NAMEONLY)))

# Add Unity reference
SRC_UNITY = $(wildcard $(PATHUNITY)*.c)
OBJ_UNITY = $(patsubst $(PATHUNITY)%.c, $(PATHOBJ)%.o, $(SRC_UNITY))

# Combin all source and object lists
SOURCES = $(PATHTESTSRC)test_main.c  $(SRC_DEPENDS) $(SRC_OFTESTS) $(SRC) $(SRC_UNITY)
OBJECTS = $(PATHOBJ)test_main.o $(OBJ_DEPENDS) $(OBJ_OFTESTS) $(OBJ) $(OBJ_UNITY)

BUILD_PATHSRC = $(PATHBUILD) $(PATHDEPENDS) $(PATHOBJ) $(PATHRESULTS)

# Compiler specific
COMPILE=gcc -c
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATHUNITY) $(PATHINC) $(PATHINC_DEPS) -DTEST -DUNITTESTS -DGCCCOMPILE
# LIBS=../emwin_522/emWin_library/VisualStudio_2010/GUIx86.lib

PASSED = `grep -s PASS $(PATHRESULTS)UnitTests.txt`
FAIL = `grep -s FAIL $(PATHRESULTS)UnitTests.txt`
IGNORE = `grep -s IGNORE $(PATHRESULTS)UnitTests.txt`

test: $(BUILD_PATHSRC) $(PATHRESULTS)UnitTests.txt
	@echo "*** UNIT TESTS - START ***"
	@echo ""
	@echo "PASSED:------------------------------------------------"
	@echo "$(PASSED)"
	@echo "IGNORES:-----------------------------------------------"
	@echo "$(IGNORE)"
	@echo "FAILURES:----------------------------------------------"
	@echo "$(FAIL)"
	@echo "*** UNIT TESTS - COMPLETE ***"

$(PATHRESULTS)UnitTests.txt: $(PATHBUILD)UnitTests.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

$(PATHBUILD)UnitTests.$(TARGET_EXTENSION): $(OBJ_UNITY) $(OBJECTS)
	$(LINK) $^ -o $@

$(foreach i,$(SOURCES),$(eval $(call COMPILERULE,$(i))))

$(PATHBUILD):
	$(MKDIR) $(PATHBUILD)

$(PATHDEPENDS):
	$(MKDIR) $(PATHDEPENDS)

$(PATHOBJ):
	$(MKDIR) $(PATHOBJ)

$(PATHRESULTS):
	$(MKDIR) $(PATHRESULTS)

clean:
	$(CLEANUP) $(wildcard $(PATHOBJ)*.o)
	$(CLEANUP) $(PATHBUILD)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATHRESULTS)UnitTests.txt

.PRECIOUS: $(PATHBUILD)*.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHDEPENDS)%.d
.PRECIOUS: $(PATHOBJ)*.o
.PRECIOUS: $(PATHRESULTS)%.txt


