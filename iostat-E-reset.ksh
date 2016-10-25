#!/bin/ksh
# File name : iostat-E-reset
# Run as
# ./iostat-E-reset <sd instance as in /etc/path_to_inst>
# to reset the hard, soft and tran errors in the iostat -E o/p.

os=`uname -r`
if [ $os != "5.10" ]; then
echo "Sorry $os is not supported;"
exit
fi
if [ $# -ne 1 ]; then
echo "Usage : iostat-E-reset "
exit
fi
sd=`echo "*sd_state::softstate $1" | mdb -kw`
es=`echo "$sd::print struct sd_lun un_errstats"| mdb -k | cut -d" " -f3`
ks=`echo "$es::print kstat_t ks_data" | mdb -k | cut -d" " -f3`
echo Resetting Hard Error
ha=`echo "$ks::print -a struct sd_errstats sd_harderrs.value.ui32" | mdb -k | cut -d" " -f1`
echo $ha/W 0 | mdb -kw
echo Resetting Soft Error
ha=`echo "$ks::print -a struct sd_errstats sd_softerrs.value.ui32" | mdb -k | cut -d" " -f1`
echo $ha/W 0 | mdb -kw
echo Resetting Tran Error
ha=`echo "$ks::print -a struct sd_errstats sd_transerrs.value.ui32" | mdb -k | cut -d" " -f1`
echo $ha/W 0 | mdb -kw
