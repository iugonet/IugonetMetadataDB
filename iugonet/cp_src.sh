#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

# src
cp ${CUSTOM_DIR}/src/dspace-api/src/main/resources/Messages.properties                 ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/resources/Messages.properties
cp ${CUSTOM_DIR}/src/dspace-api/src/main/java/org/dspace/administer/StructBuilder.java ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/java/org/dspace/administer/StructBuilder.java
cp ${CUSTOM_DIR}/src/dspace-api/src/main/java/org/dspace/app/util/SyndicationFeed.java ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/java/org/dspace/app/util/SyndicationFeed.java
cp ${CUSTOM_DIR}/src/dspace-api/src/main/java/org/dspace/app/statistics/ReportGenerator.java ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/java/org/dspace/app/statistics/ReportGenerator.java
cp ${CUSTOM_DIR}/src/dspace-api/src/main/java/org/dspace/content/Item.java             ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/java/org/dspace/content/Item.java
cp ${CUSTOM_DIR}/src/dspace-api/src/main/java/org/dspace/content/DCValue.java          ${DSPACE_SRC_RELEASE_DIR}/dspace-api/src/main/java/org/dspace/content/DCValue.java

cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/SearchServlet.java  ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/SearchServlet.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/OpenURLServlet.java ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/OpenURLServlet.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/HandleServlet.java  ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/HandleServlet.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/OpenSearchServlet.java  ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/OpenSearchServlet.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/BrowserServlet.java ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/servlet/BrowserServlet.java

cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/ItemListTag.java     ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/ItemListTag.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/BrowseListTag.java   ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/BrowseListTag.java
cp ${CUSTOM_DIR}/src/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/ItemTag.java         ${DSPACE_SRC_RELEASE_DIR}/dspace-jspui/dspace-jspui-api/src/main/java/org/dspace/app/webui/jsptag/ItemTag.java
