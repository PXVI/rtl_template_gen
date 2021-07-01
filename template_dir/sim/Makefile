# -----------------------------------------------------------------------------------
# Module Name  :
# Date Created : 10:27:43 IS, 14 January, 2020 [ Tuesday ] 
#
# Author       : pxvi
# Description  :
# -----------------------------------------------------------------------------------
#
# MIT License
#
# Copyright (c) 2020 k-sva
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the Software), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# ----------------------------------------------------------------------------------- */

# **********************
# Arguments Declarations
# **********************

TESTNAME?=NO_TEST

#FILENAME?=./../top/ip_amba_apb_slave_top.v
#TOP_NAME?=ip_amba_apb_slave_top

ifeq ($(SIM),IV)
COMPILE_FILELIST?=./comp_filelist/compile_filelist.ivlist
else
COMPILE_FILELIST?=./comp_filelist/compile_filelist.list
endif

ifdef $(DO_FILE)
DO_CMD= -do $(DO_FILE)
else
DO_CMD= -do "run -all; quit -f"
endif

# --------------------------------------
# Select the supported simulator ( SIM )
# --------------------------------------
# QuestaSim - Q
# Icarus Verilog - IV
# Verilator - VL
SIM?=IV

LINT?=0
WALL?=0
DEBUG?=0
DUMP?=0
#LAN?=V
ASSERT?=0
CHECK?=0
TB?=0
SIM_DETAILS=

DEBUG_ARGS?=
CHECK_ARGS?=
ASSERT_ARGS?=
DUMP_ARGS?=

# TB = 0 ( Simple RTL top will be simulated )
# TB = 1 ( Testbench top will b simulated and by default SV will be enabled )
ifeq ($(TB),1)
LAN?=SV
FILENAME?=./../top/tb/ip_amba_apb_slave_tb_top.sv
TOP_NAME?=ip_amba_apb_slave_tb_top
else
LAN?=V
FILENAME?=./../top/rtl/ip_amba_apb_slave_top.v
TOP_NAME?=ip_amba_apb_slave_top
endif

VLFILENAME?=V$(FILENAME)

ifeq ($(LAN),SV)
LAN_RTL_ARGS=sv
else
LAN_RTL_ARGS=v
endif

ifeq ($(DEBUG),1)
DEBUG_ARGS=+define+ip_amba_apb_slave_debug_en
endif

ifeq ($(ASSERT),1)
ASSERT_ARGS=+define+ip_amba_apb_slave_fa_en
endif

ifeq ($(CHECK),1)
CHECK_ARGS=+define+ip_amba_apb_slave_check_en
endif

ifeq ($(DUMP),1)
ifeq ($(TB),1)
DUMP_ARGS=+define+ip_amba_apb_slave_tb_dump_en
else
DUMP_ARGS=+define+ip_amba_apb_slave_dump_en
endif
endif

ifeq ($(WALL),1)
WALL_ARG=-Wall
else
WALL__ARG=
endif

# **********************
# Labels Declarations
# **********************

ifeq ($(LINT),1)
before_comp: cmd_disp clean lint
else
before_comp: cmd_disp clean
endif

#.PHONY :
#	@echo "# The supplied make command is not supported. Use make help to look at the supported labels."

ifeq ($(SIM),Q)
all : before_comp lib comp opt sim
endif
ifeq ($(SIM),IV)
all : before_comp iv_comp iv_sim
endif
ifeq ($(SIM),VL)
all : before_comp vl_comp vl_sim
endif

comp_only : cmd_dis clean lib comp

cmd_disp:
	@echo "# ------------------"
	@echo "# Script Run Details"
	@echo "# ------------------"
	@echo "# Simulator : $(SIM)"
	@echo "# Compile filelist : $(COMPILE_FILELIST)"
	@echo "# Top File : $(FILENAME)"
	@echo "# Lint Enabled : $(LINT)"
	@echo "# Testbench Enabled : $(TB)"
	@echo "# Assertions Enabled : $(ASSERT)"
	@echo "# Debug Enabled : $(DEBUG)"
	@echo "# DUMP Enabled : $(DUMP)"
	@echo ""

# -----------------------------------------
# To Clean Redundant Files and Other Things
# -----------------------------------------
clean:
	@echo "# Running Clean Command...";
	@rm -rf *.log *.vcd *.wlf;
	@rm -rf work questa.tops transcript;
	@rm -rf ./debug;
	@rm -rf ./obj_dir;
	@rm -rf ./vvp_out;

# -----------
# Compilation
# -----------
comp:
	@echo "# Compiling the files...";
	@vlog \
	-64 \
	-work ./work \
	+acc \
	-l compile.log \
	-$(LAN_RTL_ARGS) \
	-vopt \
	-writetoplevels questa.tops \
	$(FILENAME) \
	$(DEBUG_ARGS) \
	$(ASSERT_ARGS) \
	$(CHECK_ARGS) \
	$(DUMP_ARGS) \
	-f $(COMPILE_FILELIST);
	

# ----------
# Simulation
# ----------
sim:
	@echo "# Starting Simulation...";
	@vsim \
	top_opt \
	-wlf vsim.wlf \
	$(DO_CMD) \
	-l $(TESTNAME).log \
	-64 \
	-c \
	+define+UVM_NO_DPI \
	+UVM_TESTNAME=$(TESTNAME);

# ------------------
# Library Generation
# ------------------
lib:
	@echo "# Making Work Directory...";
	@vlib work;

# --------------------
# For the Optimization
# --------------------
opt:
	@echo "# Running Optimization...";
	@vopt \
	+acc \
	$(TOP_NAME) \
	-o top_opt;

# ---------------------
# Generate WLF from VCD
# ---------------------
wave:
	@echo "# Converting dump.vcd file to dump.wlf...";
	@echo "# Removing all the redundant dumps...";
	@echo "# Complete!";
	@vcd2wlf dump.vcd dump.wlf;
	@rm -rf dump.vcd;

# -----------------------------
# Move the Geberated Debug Logs
# -----------------------------
logs:
	@echo "# Creating a new ./debug directory...";
	@mkdir ./debug;
	@mv *debug.log ./debug/;
	@echo "# Moved all the logs successfully.";

# ------------------------
# For the Qverilog Command
# ------------------------
qv:
	qverilog \
	$(FILENAME);

qvc: clean qv

# ------------------------------
# Running a Lint using Verilator
# ------------------------------
lint:
	@echo "# Linting the design..."
	@verilator \
	-f $(COMPILE_FILELIST) \
	$(FILENAME) \
	$(WALL_ARG) \
	--lint-only;
	@echo "# Linting Complete!"

# ------------------
# Icarus Compilation
# ------------------
iv_comp:
	@echo "# Compiling verilog/systemverilog files using icarus..."
	iverilog -o vvp_out \
	-c $(COMPILE_FILELIST) \
	$(FILENAME)
	@echo "# Compilation complete"

# -----------------
# Icarus Simulation
# -----------------
iv_sim:
	@echo "# Running the icarun generated vvp file..."
	@echo "# ----------------------------------------"
	@echo ""
	@vvp vvp_out

# ---------------------------------------
# Make a RTL release directory with RTL &
# build scripts
# ---------------------------------------
release: all
	make clean
	@echo "# Compilation/simulation was a clean run on the rtl. Moving onto release package creation."
	./scripts/rtl_release.sh
	@echo "# Release RTL package prepared."

# ----------------------------------
# No comp/sim version of the release
# ----------------------------------
release_nocomp:
	@echo "# Skipping basic compilation and other checks. Directly moving onto release preperation."
	./rtl_release.sh
	@echo "# Release RTL package prepared."

# --------------------------------------------------
# Create the neccessary Verilator .cpp template file
# --------------------------------------------------
vl_res:
	@echo "# Removing and re-creating the sim_main.cpp for verilator"
	@rm -rf sim_main.cpp
	@./scripts/gen_sim_main.sh $(TOP_NAME);
	@echo "# sim_main.cpp file generated for the top ( $(TOP_NAME) )!"

# -------------------------
# Verilate the design files
# -------------------------
vl_comp:
	@echo "# Verilating..."
	@verilator -Wall --cc --exe --build sim_main.cpp -f $(COMPILE_FILELIST) $(FILENAME);

# ------------------------------
# Run the verilated design files
# ------------------------------
vl_sim:
	@echo "#----------------------------"
	@echo "# Running verilated design..."
	@echo "# ---------------------------"
	@echo ""
	@obj_dir/V$(TOP_NAME);
	@echo ""
	@echo "# ---------------------------"

# ----------------------------------------
# Help label to print the relevant details 
# of the makefile
# ----------------------------------------
help:
	@echo "# ----------------------------------"
	@echo "# Usage : make <label> <arg1> <arg2>"
	@echo "# ----------------------------------"
	@echo "# "
	@echo "# List of avialable labels -"
	@echo "# "
	@echo "# all             : Runs a simple Questasim simulation ( after the neccessary pre-reusite steps )"
	@echo "# clean           : Removes all the simulation/compilation related files after a run"
	@echo "# lint            : Performs a verilator based lilnt on the verilog based top module"
	@echo "# wave            : Generates a .wlf file from a .vcd from the current directory"
	@echo "# logs            : Moves all the generated logs into a new directory"
	@echo "# qv              : Runs a simple qverilog command on the verilog top module"
	@echo "# qvc             : Performs a clean and qverilog run on the verilog top module"
	@echo "# release         : Creates a release directory after a sanity simulation with the module and the neccessary files for quick export"
	@echo "# release_nocomp  : Create a release of the verilog RTL without running a sanity simulation"
	@echo "# "
	@echo "# List of switches -"
	@echo "# "
	@echo "# SIM			 : Select the simulator with which to run the simulation ( Q, IV, VL )"
	@echo "# LINT            : Enable lint"
	@echo "# WALL            : Disable lint warnings"
	@echo "# DEBUG           : Enable debug defines and run time args"
	@echo "# DUMP            : Generate a simulation dump"
	@echo "# ASSERT          : Enable assertions"
	@echo "# CHECK           : Enable RTL functional checker blocks"
	@echo "# TB              : Enable a testbench and run it's top as the simulation block"
	@echo "# LAN             : ( V / SV ) Run simulation with Verilog syntax or SystemVerilog syntax"
