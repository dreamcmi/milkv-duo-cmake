# /bin/bash

if [ "$1" == "down" ];then
    unset -v MILKV_DUO_CMAKE_ROOT
    unset -v MILKV_DUO_CMAKE_C906B_ROOT
    unset -v MILKV_DUO_CMAKE_C906L_ROOT
    unset -v MILKV_DUO_CMAKE_CA53_ROOT
    echo "env down"
else
    CRTDIR=$(pwd)
    export MILKV_DUO_CMAKE_ROOT=$CRTDIR
    export MILKV_DUO_CMAKE_C906B_ROOT=$CRTDIR/C906B
    export MILKV_DUO_CMAKE_C906L_ROOT=$CRTDIR/C906L
    export MILKV_DUO_CMAKE_CA53_ROOT=$CRTDIR/CA53
    echo "env setup done"
fi

