# meta-tn-mender-demos

## Dependencies

This layer depends on [TechNexion Yocto 3.0 Zeus 5.4.y GA BSP](https://github.com/TechNexion/tn-imx-yocto-manifest/tree/zeus_5.4.y-next)

## Quick start

The following commands will setup the environment and allow you to build images
that have TechNexion Mender Demos integrated.


```
mkdir mender-tn-imx-bsp && cd mender-tn-imx-bsp
repo init -u https://github.com/TechNexion/tn-imx-yocto-manifest.git -b zeus_5.4.y-next -m imx-5.4.70-2.3.0.xml
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/TechNexion-customization/meta-tn-mender-demos/zeus/scripts/mender-tn-demo.xml
repo sync -j$(nproc)
DISTRO=fsl-imx-xwayland MACHINE=pico-imx8mm source tn-setup-mender-demo.sh -b build-xwayland-imx8mm
bitbake core-image-base
```

## Maintainer

The authors and maintainers of this layer are:

- Po Cheng - <po.cheng@technexion.com> -

Always include the maintainers when suggesting code changes to this layer.
