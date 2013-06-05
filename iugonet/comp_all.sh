#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

echo ${DSPACE_SRC_RELEASE_DIR}
echo ${DSPACE_INSTALL_DIR}
echo ${IUGONET_WEBAPPS}

cd ${DSPACE_SRC_RELEASE_DIR}/dspace
mvn package

cd ${DSPACE_SRC_RELEASE_DIR}/dspace/target/dspace-${DSPACE_VERSION}-build.dir

cp -p lib/dspace-api-${DSPACE_VERSION}.jar ${DSPACE_INSTALL_DIR}/lib/.
cp -p webapps/jspui/WEB-INF/lib/dspace-api-${DSPACE_VERSION}.jar ${IUGONET_WEBAPPS}/WEB-INF/lib/.
cp -p webapps/jspui/WEB-INF/lib/dspace-jspui-api-${DSPACE_VERSION}.jar ${IUGONET_WEBAPPS}/WEB-INF/lib/.

