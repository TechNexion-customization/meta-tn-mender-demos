HOMEPAGE = "https://mender.io"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"
DESCRIPTION = "The dfu Update Module installs a firmware file in the target."

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/mendersoftware/mender-update-modules.git"

SRCREV = "c54c5c6d69aaf3e261d316eb1b1f9d6ae45f17a2"

S = "${WORKDIR}/git"

inherit allarch

DEPENDS += "mender-dfu-native"

SRC_URI += "file://0001-dfu-artifact-gen-must-use-bash.patch"

do_install_class-target() {
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/dfu/module/dfu ${D}/${datadir}/mender/modules/v3/dfu
}

do_install_class-native() {
    install -d ${D}/${bindir}
    install -m 755 ${S}/dfu/module-artifact-gen/dfu-artifact-gen ${D}/${bindir}/dfu-artifact-gen
}

FILES_${PN} += "${datadir}/mender/modules/v3/dfu"
FILES_${PN}-class-native += "${bindir}/dfu-artifact-gen"

BBCLASSEXTEND = "native"
