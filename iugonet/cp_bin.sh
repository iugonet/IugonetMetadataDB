#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

cp ${CUSTOM_DIR}/bin/* ${DSPACE_INSTALL_DIR}/bin/.

