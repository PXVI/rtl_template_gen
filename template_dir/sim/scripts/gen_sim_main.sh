
# Purpose of this script is to create a sim_main.cpp file specifically for a verilog top

dc='"'
topname=$1

echo "#include <iostream>" >> sim_main.cpp
echo "" >> sim_main.cpp
echo "#include ${dc}V${topname}.h${dc}" >> sim_main.cpp
echo "#include ${dc}verilated.h${dc}" >> sim_main.cpp
echo "int main(int argc, char **argv, char **env)" >> sim_main.cpp
echo "{" >> sim_main.cpp
echo "        Verilated::commandArgs(argc, argv);" >> sim_main.cpp
echo "        V${topname} *top = new V${topname};" >> sim_main.cpp
echo "        while (!Verilated::gotFinish())" >> sim_main.cpp
echo "        {" >> sim_main.cpp
#echo "                if (top->clock)" >> sim_main.cpp
#echo "                        std::cout << ${dc} ${dc} << top->fn << std::endl;" >> sim_main.cpp
echo "                top->${topname}_clock ^= 1;" >> sim_main.cpp
echo "                top->eval();" >> sim_main.cpp
echo "        }" >> sim_main.cpp
echo "        delete top;" >> sim_main.cpp
echo "        exit(0);" >> sim_main.cpp
echo "}" >> sim_main.cpp
