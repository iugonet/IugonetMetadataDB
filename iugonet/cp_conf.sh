#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

# config
cp ${CUSTOM_DIR}/config/dspace.cfg                       ${DSPACE_RELEASE_DIR}/dspace/config/dspace.cfg
cp ${CUSTOM_DIR}/config/registries/dublin-core-types.xml ${DSPACE_RELEASE_DIR}/dspace/config/registries/dublin-core-types.xml
