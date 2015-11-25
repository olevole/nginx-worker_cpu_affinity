#!/bin/sh

OS=$( uname -s )

case "${OS}" in
	FreeBSD)
		n=$( sysctl -n hw.ncpu )
		;;
	*)      # Linux
		n=$(awk '/^processor/{n=$3} END{print n}' /proc/cpuinfo)
		;;
esac

[ $n -eq 0 ] && exit;
printf "worker_cpu_affinity "

for a in $( seq 0 $n ); do
	poss=$((n - a))
	pose=$((n - poss))
	if [ $pose -eq 0 ]; then
		printf "%0${poss}d1" 0
	elif [ $poss -eq 0 ]; then
		[ $poss -eq 0 ] && printf "1%0${pose}d" 0
	else
		[ $pose -ne 0 ] && printf "%0${poss}d1%0${pose}d" 0 0
	fi

	[ $n != $a ] && echo -n " " || echo ";";
done
