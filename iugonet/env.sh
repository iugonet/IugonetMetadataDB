#!/bin/bash

WORK=/home/dspace/iugonet

DSPACE_VERSION=1.7.0
CUSTOM_DIR=${WORK}/iugonet/${DSPACE_VERSION}
CUSTOM_IUGONET_WEBAPPS=${CUSTOM_DIR}/webapps/iugonet

DSPACE_RELEASE_DIR=${WORK}/dspace-${DSPACE_VERSION}-release
DSPACE_SRC_RELEASE_DIR=${WORK}/dspace-${DSPACE_VERSION}-src-release

DSPACE_INSTALL_DIR=/opt/dspace
DEFAULT_WEBAPPS=${DSPACE_INSTALL_DIR}/webapps/jspui
IUGONET_WEBAPPS=${DSPACE_INSTALL_DIR}/webapps/iugonet
