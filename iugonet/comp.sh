#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

cd ${DSPACE_SRC_RELEASE_DIR}/dspace-api
mvn install

cd ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api
mvn install

cd ${WORK}
cp ${DSPACE_SRC_RELEASE_DIR}/dspace-api/target/dspace-api-${DSPACE_VERSION}.jar ${DSPACE_INSTALL_DIR}/lib/.
cp ${DSPACE_SRC_RELEASE_DIR}/dspace-api/target/dspace-api-${DSPACE_VERSION}.jar ${IUGONET_WEBAPPS}/WEB-INF/lib/.
cp ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/target/dspace-jspui-api-${DSPACE_VERSION}.jar ${IUGONET_WEBAPPS}/WEB-INF/lib/.
