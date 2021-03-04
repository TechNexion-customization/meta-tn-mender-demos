# TechNexion Mender Demo Setup Script
#
# Copyright 2021 TechNexion

if [ -x setup-environment.sh -a -L setup-environment.sh ]; then
  . setup-environment.sh $@
elif [ -x tn-setup-mender.sh -a -L tn-setup-mender.sh ]; then
  . tn-setup-mender.sh $@
fi

if [ $? != 0 ]; then
  echo ""
  echo "Failed to setup technexion mender demo build environment"
  echo ""
  return 1
fi

echo "BBLAYERS += \" \${BSPDIR}/sources/meta-tn-mender-demos \"" >> conf/bblayers.conf
if [ -f conf/bblayers.conf ]; then
  if grep -q "DISTRO.*b2qt" conf/local.conf; then
    if ! grep -qF "meta-mender-core" conf/bblayers.conf; then
      echo "BBLAYERS += \"\${BSPDIR}/sources/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
    fi
    if ! grep -qF "meta-mender-demo" conf/bblayers.conf; then
      echo "BBLAYERS += \"\${BSPDIR}/sources/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf
    fi
    if ! grep -qF "meta-mender-tn-imx-bsp" conf/bblayers.conf; then
      echo "BBLAYERS += \"\${BSPDIR}/sources/meta-mender-community/meta-mender-tn-imx-bsp \"" >> conf/bblayers.conf
    fi
    cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
    cat ../sources/meta-mender-community/meta-mender-tn-imx-bsp/templates/local.conf.append >> conf/local.conf
  fi
  if ! grep -qF "meta-mender-update-modules" conf/bblayers.conf; then
    if [ -d ../sources/meta-mender-community/meta-mender-update-modules ]; then
      echo "BBLAYERS += \"\${BSPDIR}/sources/meta-mender-community/meta-mender-update-modules \"" >> conf/bblayers.conf
    fi
  fi
fi

# Append additional settings to local.conf for virtualization/boot2qt,
# at this point conf/local.conf should be setup already,
# so parse for DISTRO ?= "boot2qt" or MULTICONFIG = "container" and append accordingly
if [ -f conf/local.conf ]; then
  if grep -q "DISTRO.*b2qt" conf/local.conf; then
    cat ../sources/meta-tn-mender-demos/templates/local.conf.append.boot2qt >> conf/local.conf
    echo "QBSP_IMAGE_CONTENT_remove = \"\${IMAGE_LINK_NAME}.img\"" >> conf/local.conf
    echo "QBSP_IMAGE_CONTENT_prepend = \"\${IMAGE_LINK_NAME}.sdimg\"" >> conf/local.conf
    echo "IMAGE_CLASSES_remove = \"deploy-conf\"" >> conf/local.conf
    echo "IMAGE_CLASSES_append = \" deploy-conf-b2qt\"" >> conf/local.conf
    echo "BBMASK += \"meta-tn-imx-bsp/recipes-tn/images/tn-image-multimedia-full.bb\"" >> conf/local.conf
  fi
  if grep -q "BBMULTICONFIG.*container" conf/local.conf; then
    cat ../sources/meta-tn-mender-demos/templates/local.conf.append.virtualization >> conf/local.conf
    echo -e "\n# Setup additional local.conf settings for mender virtualization." | tee -a conf/local.conf
    echo "BBMASK += \"meta-boot2qt/meta-boot2qt-distro/recipes-qt/qt5/ogl-runtime_git.bbappend\"" >> conf/local.conf
  fi
  echo "IMAGE_FSTYPES_remove = \"wic wic.xz\"" >> conf/local.conf
  echo "IMAGE_FSTYPES_append_tn = \" sdimg.gz\"" >> conf/local.conf
  echo "MENDER_UBOOT_STORAGE_DEVICE_tn = \"2\"" >> conf/local.conf
  echo "MENDER_BOOT_PART_NUMBER_tn = \"2\"" >> conf/local.conf
  echo "MENDER_STORAGE_TOTAL_SIZE_MB_tn = \"8176\"" >> conf/local.conf
  echo "MENDER_DATA_PART_SIZE_MB_tn = \"2048\"" >> conf/local.conf
  echo "IMAGE_ROOTFS_MAXSIZE_tn = \"25165824\"" >> conf/local.conf
  echo "PACKAGE_CLASSES += \"package-mender-artifacts\"" >> conf/local.conf
fi

echo ""
echo "TechNexion Mender demo setup complete."
echo ""

