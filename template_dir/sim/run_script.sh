# -----------------------------------------------------------------------------------
# module name  :
# date created : 10:27:43 is, 14 january, 2020 [ tuesday ] 
#
# author       : pxvi
# description  : Run script for the repository
# -----------------------------------------------------------------------------------
#
# mit license
#
# copyright (c) 2020 k-sva
#
# permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the software), to deal
# in the software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the software, and to permit persons to whom the software is
# furnished to do so, subject to the following conditions:
#
# the above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the software.
#
# the software is provided as is, without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. in no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising from,
# out of or in connection with the software or the use or other dealings in the
# software.
#
# ----------------------------------------------------------------------------------- */

# Switch Declaration

enableDebug=0 # -d
enableAssert=0 # -a
enableDump=0 # -du
enableLint=0 # -l
enableCheck=0 # -ck
enableCustomCompileFilelist=0 # -cf
enableCustomDoFile=0 # -do
enableCustomFileName=0 # -fn
enableCustomTopName=0 # -tn
enableSVLanguage=0 # -sv
enableTB=0 # -tb
enableQuesta=1 # -qs
enableVerilator=0 # -vl
enableIcarus=0 # -iv
enableVLWrap=0 # --vlwrap

enableBuild=0 # --build
enableClean=0 # --clean

compileFilelist="./comp_filelist/compile_filelist.list"
doFile="./def_do.do"
fileName="./../top/rtl/ip_amba_apb_slave_top.v"
topName="ip_amba_apb_slave_top"
vFileName="V${topName}"
simLang="Q"
SVLanguageArgs="-v"
verilatorWallArg=""

# Subroutines
eco(){
    echo "# $1";
}

show_help(){
    eco ""
    eco "--------------------------"
    eco "run_script.sh Help Section "
    eco "--------------------------"
    eco "Syntax : run_script [arg1] [arg2] ..."

    eco "Control Switches"
    eco ""
    eco "-d         : Enabling Debug"
    eco "-a         : Toggling Assertions"
    eco "-du        : Enabling DUMP Generatiom"
    eco "-l         : Linting ( Verilator )"
    eco "-ck        : Enable Checkers"
    eco "-cf        : Compilefilelist ( Arg )"
    eco "-do        : DO File ( Arg )"
    eco "-fn        : Top Filename ( Arg )"
    eco "-tn        : Top Name ( Arg )"
    eco "-sv        : Enable SystemVerilog 1800 Language"
    eco "-qs        : QuestaSim Tool"
    eco "-vl        : Verilator Tool"
    eco "-iv        : Igarus Verilog Tool"
    eco "-h         : Show the help section"
    eco ""
    eco "Command Switches"
    eco ""
    eco "--clean    : Remove all the redundant files and directories"
    eco "--build    : Compile & build the sim run"
    eco "--vlwrap   : Generate a verilator wrapper for the verilog top file"
    eco "--help     : Show the help section"
}

lb_clean(){
    eco "Running Clean Command...";
    rm -rf *.log *.vcd *.wlf;
    rm -rf work questa.tops transcript;
    rm -rf ./debug;
    rm -rf ./obj_dir;
    rm -rf ./vvp_out;
    rm -rf ./*.do;
}

lb_cmd_disp(){
    eco "--------------------------------"
    eco "Script Run Details / Build v1.00"
    eco "--------------------------------"
    if [ $enableQuesta -eq 1 ]
    then
        eco "Simulator : QuestaSim"
    elif [ $enableVerilator -eq 1 ]
    then
        eco "Simulator : Verilator"
    else
        eco "Simulator : Icarus Verilog"
    fi
    eco "Compile filelist : $compileFilelist"
    eco "Top File : $fileName"
    eco "Lint Enabled : $enableLint"
    eco "Testbench Enabled : $enableTB"
    eco "Assertions Enabled : $enableAssert"
    eco "Debug Enabled : $enableDebug"
    eco "DUMP Enabled : $enableDump"
    if [ $enableQuesta -eq 1 ]
    then
        eco "Options : More QS Options"
    elif [ $enableVerilator -eq 1 ]
    then
        eco "Create New CPP Wrapper : $enableVLWrap"
    else
        eco "Options : More IV Options"
    fi
    eco ""
}

# File Creations
create_do_file(){
    eco "Creating a dummy DO file..."
    echo "run -all;" > $doFile
    echo "quit -f;" >> $doFile
}

# QuestaSim
lb_qs_lib(){
    eco "Making Work Directory...";
    vlib work;
}

lb_qs_comp(){
	eco "Compiling the files...";
	vlog \
	-64 \
	-work ./work \
	+acc \
	-l compile.log \
	$SVLanguageArgs \
	-vopt \
	-writetoplevels questa.tops \
	$fileName \
	-f $compileFilelist;
}

lb_qs_opt(){
    eco "Running Optimization...";
    vopt \
	+acc \
	$topName \
	-o top_opt;
}

lb_qs_sim(){
	eco "Starting Simulation...";
	vsim \
	top_opt \
	-wlf vsim.wlf \
	-do $doFile \
	-l run.log \
	-64 \
	-c;
}

lb_qs_wave(){
    eco "Converting dump.vcd file to dump.wlf...";
    eco "Removing all the redundant dumps...";
    eco "Complete!";
    vcd2wlf dump.vcd dump.wlf;
    rm -rf dump.vcd;
}

lb_qs_logs(){
    eco "Creating a new ./debug directory...";
    mkdir ./debug;
    mv *debug.log ./debug/;
    eco "Moved all the logs successfully.";
}

lb_qs_qv(){
	qverilog $fileName;
}

lb_qs_qvc(){
    lb_qs_qv
}

# Linting Only
lb_vl_lint(){
    eco "Linting the design..."
    verilator \
	-f $compileFilelist \
	$fileName \
	-Wall \
	--lint-only;
	eco "Linting Complete!"
}

# Icarus Verilog
lb_iv_comp(){
	eco "Compiling verilog/systemverilog files using icarus..."
	iverilog -o vvp_out \
	-c $compileFilelist \
	$fileName
	eco "Compilation complete"
}

lb_iv_sim(){
	eco "Running the icarun generated vvp file..."
	eco "----------------------------------------"
	eco ""
	vvp vvp_out
}

# Verilator
lb_vl_res(){

    # Generate a simple cpp wrapper for the verilated design

    eco "Removing and re-creating the sim_main.cpp for verilator"
    rm -rf sim_main.cpp
    ./scripts/gen_sim_main.sh $topName;
    eco "sim_main.cpp file generated for the top ( $topName )!"
}

lb_vl_comp(){
    eco "Verilating..."
    verilator -Wall --cc --exe --build sim_main.cpp -f $compileFilelist $fileName;
}

lb_vl_sim(){
    eco "----------------------------"
    eco "Running verilated design..."
    eco "---------------------------"
    eco ""
    obj_dir/V${topName};
    eco ""
    eco "---------------------------"
}

# Miscelleneous
lb_release_nocomp(){
	make clean
	eco "Compilation/simulation was a clean run on the rtl. Moving onto release package creation."
	./scripts/rtl_release.sh
	eco "Release RTL package prepared."
}

lb_release(){
	make clean
	eco "Compilation/simulation was a clean run on the rtl. Moving onto release package creation."
	./scripts/rtl_release.sh
	eco "Release RTL package prepared."
}

# Execute Build
run_build(){

    # Default File Creations
    if [ $enableCustomDoFile -eq 0 ]
    then
        create_do_file
    fi

    if [ $enableQuesta -eq 1 ]
    then
        lb_qs_lib
        lb_qs_comp
        lb_qs_opt
        lb_qs_sim
    fi
    
    if [ $enableVerilator -eq 1 ]
    then
        lb_vl_comp
        lb_vl_sim
    fi
    
    if [ $enableIcarus -eq 1 ]
    then
        lb_iv_comp
        lb_iv_sim
    fi
}

check_switch(){
    ntemp=0;
    anum=$#;

    if [ $anum -eq 0 ]
    then
        show_help
        exit 1
    fi

    while [ $ntemp -ne $anum ]
    do        
        case "$1" in
            "-d")       enableDebug=1;;
            "--build")  enableBuild=1;;
            "--clean")  enableClean=1;;
            "-a")       enableAssert=1;;
            "-du")      enableDump=1;;
            "-l")       enableLint=1;;
            "-ck")      enableCheck=1;;
            "-tb")      enableTB=1;;
            "--vlwrap") enableVLWrap=1;;
            "-cf")      enableCustomCompileFilelist=1
                        ntemp=`expr $ntemp + 1`
                        shift;;
                        #eco "Complile Filelist Overridden ( $1 )";;
            "-do")      enableCustomDoFile=1
                        ntemp=`expr $ntemp + 1`
                        shift;;
                        #eco "Do File Overridden ( $1 )";;
            "-fn")      enableCustomFileName=1
                        ntemp=`expr $ntemp + 1`
                        shift;;
                        #eco "Simulation File Overridden ( $1 )";;
            "-tn")      enableCustomTopName=1
                        ntemp=`expr $ntemp + 1`
                        shift;;
                        #eco "Simulation TOP Overridden ( $1 )";;
            "-sv")      enableSVLanguage=1
                        SVLanguageArgs="-sv";;
                        #eco "System Verilog Language Enabled";;
            "-qs")      enableQuesta=1
                        enableVerilator=0
                        enableIcarus=0;;
            "-vl")      enableVerilator=1
                        enableQuesta=0
                        enableIcarus=0;;
            "-iv")      enableIcarus=1
                        enableQuesta=0
                        enableVerilator=0
                        compileFilelist="./comp_filelist/compile_filelist.ivlist";;
            "-h")       show_help
                        exit 1;;
            "--help")   show_help
                        exit 1;;
            *)          eco "Unsupported argument passed ( $1 )"
                        show_help
                        exit 1;;
        esac
        shift

        ntemp=`expr $ntemp + 1`
    done
    
    # Switch Overriding
    if [ $enableCustomTopName -eq 0 -a $enableCustomFileName -eq 0 ]
    then
        if [ $enableTB -eq 1 ]
        then
            topName="ip_amba_apb_slave_tb_top"
            fileName="./../top/tb/ip_amba_apb_slave_tb_top.sv"
            SVLanguageArgs="-sv"
        fi
    fi

    # Build And Simulations
    lb_cmd_disp

    if [ $enableClean -eq 1 ]
    then
        lb_clean
    fi

    if [ $enableVLWrap -eq 1 ]
    then
        lb_vl_res       
    fi

    if [ $enableBuild -eq 1 ]
    then
        run_build
    fi
}

run_main(){
    check_switch $@
}

# Main Script Execution
#eco "------------------------"
#eco "Run Script / Build v1.00"
#eco "------------------------"
eco "Command Arguments : $#"
#eco ""

run_main $@
