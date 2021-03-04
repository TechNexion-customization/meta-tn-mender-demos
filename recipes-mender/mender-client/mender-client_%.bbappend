FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_mender-signing = " file://artifact-verify-key.pem"
# build mender update modules (plugins)
PACKAGECONFIG_append = " modules"
