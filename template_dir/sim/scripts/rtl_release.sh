path=`echo "$IP_AMBA_APB_SLAVE_HOME"`;

mkdir ${path}/sim/release_ip_amba_apb_slave;
cp -r ${path}/common/* ${path}/sim/release_ip_amba_apb_slave/;
cp -r ${path}/top/rtl/* ${path}/sim/release_ip_amba_apb_slave/;

touch ${path}/sim/release_ip_amba_apb_slave/.install;
chmod 777 ${path}/sim/release_ip_amba_apb_slave/.install;

echo 'temp_path=`echo $PWD`;' >> ${path}/sim/release_ip_amba_apb_slave/.install;
echo '' >> ${path}/sim/release_ip_amba_apb_slave/.install;
echo 'export IP_AMBA_APB_SLAVE_HOME="${temp_path}/../";' >> ${path}/sim/release_ip_amba_apb_slave/.install;
echo 'echo -n "IP_AMBA_APB_SLAVE_HOME : ";' >> ${path}/sim/release_ip_amba_apb_slave/.install;
echo 'echo $IP_AMBA_APB_SLAVE_HOME;' >> ${path}/sim/release_ip_amba_apb_slave/.install;

touch ${path}/sim/release_ip_amba_apb_slave/compile_filelist.list;

echo '+incdir+$IP_AMBA_APB_SLAVE_HOME/' >> ${path}/sim/release_ip_amba_apb_slave/compile_filelist.list;
