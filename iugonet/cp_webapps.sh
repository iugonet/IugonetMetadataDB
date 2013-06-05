#!/bin/bash

if [ -e env.sh ]; then
. env.sh
else
 echo "Error"
 exit
fi

rm -rf ${IUGONET_WEBAPPS}
cp -r ${DEFAULT_WEBAPPS} ${IUGONET_WEBAPPS}

cp ${CUSTOM_IUGONET_WEBAPPS}/index.jsp                 ${IUGONET_WEBAPPS}/index.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/collection-home.jsp       ${IUGONET_WEBAPPS}/collection-home.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/community-home.jsp        ${IUGONET_WEBAPPS}/community-home.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/community-list.jsp        ${IUGONET_WEBAPPS}/community-list.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/display-item.jsp          ${IUGONET_WEBAPPS}/display-item.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/utils.js                  ${IUGONET_WEBAPPS}/utils.js
cp ${CUSTOM_IUGONET_WEBAPPS}/apple-touch-icon.png      ${IUGONET_WEBAPPS}/apple-touch-icon.png
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/helpFreeWord.js ${IUGONET_WEBAPPS}/static/js/helpFreeWord.js
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/helpTime.js     ${IUGONET_WEBAPPS}/static/js/helpTime.js
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/helpResourceType.js ${IUGONET_WEBAPPS}/static/js/helpResourceType.js
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/gmaps.js        ${IUGONET_WEBAPPS}/static/js/gmaps.js
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/searchbox.js    ${IUGONET_WEBAPPS}/static/js/searchbox.js
cp ${CUSTOM_IUGONET_WEBAPPS}/static/js/helpSpatialCoverage.js ${IUGONET_WEBAPPS}/static/js/helpSpatialCoverage.js
cp -r ${CUSTOM_IUGONET_WEBAPPS}/static/js/scriptaculous ${IUGONET_WEBAPPS}/static/js/.
cp ${CUSTOM_IUGONET_WEBAPPS}/styles.css                ${IUGONET_WEBAPPS}/styles.css
cp ${CUSTOM_IUGONET_WEBAPPS}/lightbox.css              ${IUGONET_WEBAPPS}/lightbox.css
cp ${CUSTOM_IUGONET_WEBAPPS}/favicon.ico               ${IUGONET_WEBAPPS}/favicon.ico
cp ${CUSTOM_IUGONET_WEBAPPS}/browse/full.jsp           ${IUGONET_WEBAPPS}/browse/full.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/browse/full_nobody.jsp    ${IUGONET_WEBAPPS}/browse/full_nobody.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/layout/header-default.jsp ${IUGONET_WEBAPPS}/layout/header-default.jsp 
cp ${CUSTOM_IUGONET_WEBAPPS}/layout/footer-default.jsp ${IUGONET_WEBAPPS}/layout/footer-default.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/layout/navbar-default.jsp ${IUGONET_WEBAPPS}/layout/navbar-default.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/layout/location-bar.jsp ${IUGONET_WEBAPPS}/layout/location-bar.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/search/results.jsp        ${IUGONET_WEBAPPS}/search/results.jsp
cp ${CUSTOM_IUGONET_WEBAPPS}/WEB-INF/web.xml           ${IUGONET_WEBAPPS}/WEB-INF/web.xml
cp -r ${CUSTOM_IUGONET_WEBAPPS}/iugonet                ${IUGONET_WEBAPPS}/.
cp -r ${CUSTOM_DIR}/webapps/iphone ${DSPACE_INSTALL_DIR}/webapps
cp -r ${CUSTOM_IUGONET_WEBAPPS}/WEB-INF/xsl            ${IUGONET_WEBAPPS}/WEB-INF/.
