From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 17 Mar 2020 14:10:39 +0100
Subject: [Ocfs2-devel] [PATCH 00/12] Fix broken references for
	Documentation/*
Message-ID: <cover.1584450500.git.mchehab+huawei@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch series is against next-20200317. It fixes all references to files
under Documentation/* that were moved, renamed or removed.

After this patch series, this script:
	./scripts/documentation-file-ref-check

Doesn't complain about any broken reference.

Mauro Carvalho Chehab (12):
  MAINTAINERS: dt: update display/allwinner file entry
  MAINTAINERS: dt: update etnaviv file reference
  MAINTAINERS: drop an old reference to stm32 pwm timers doc
  docs: dt: fix references to m_can.txt file
  docs: dt: fix references to ap806-system-controller.txt
  docs: dt: fix a broken reference to input.yaml
  docs: dt: fix broken reference to phy-cadence-torrent.yaml
  docs: fix broken references to text files
  docs: fix broken references for ReST files that moved around
  docs: dt: display/ti: fix typos at the devicetree/ directory name
  docs: filesystems: fix renamed references
  docs: kernel-parameters.txt: remove reference for removed Intel MPX

 Documentation/ABI/stable/sysfs-devices-node   |  2 +-
 Documentation/ABI/testing/procfs-smaps_rollup |  2 +-
 Documentation/admin-guide/cpu-load.rst        |  2 +-
 .../admin-guide/kernel-parameters.txt         | 11 ++--
 Documentation/admin-guide/nfs/nfsroot.rst     |  2 +-
 .../bindings/arm/freescale/fsl,scu.txt        |  2 +-
 .../bindings/display/ti/ti,am65x-dss.yaml     |  2 +-
 .../bindings/display/ti/ti,j721e-dss.yaml     |  2 +-
 .../bindings/display/ti/ti,k2g-dss.yaml       |  2 +-
 .../devicetree/bindings/gpio/gpio-mvebu.txt   |  2 +-
 .../devicetree/bindings/net/can/tcan4x5x.txt  |  2 +-
 .../bindings/phy/ti,phy-j721e-wiz.yaml        |  2 +-
 .../bindings/thermal/armada-thermal.txt       |  2 +-
 .../doc-guide/maintainer-profile.rst          |  2 +-
 .../driver-api/driver-model/device.rst        |  4 +-
 .../driver-api/driver-model/overview.rst      |  2 +-
 Documentation/filesystems/dax.txt             |  2 +-
 Documentation/filesystems/dnotify.txt         |  2 +-
 .../filesystems/ramfs-rootfs-initramfs.rst    |  2 +-
 Documentation/filesystems/sysfs.rst           |  2 +-
 Documentation/memory-barriers.txt             |  2 +-
 .../powerpc/firmware-assisted-dump.rst        |  2 +-
 Documentation/process/adding-syscalls.rst     |  2 +-
 Documentation/process/submit-checklist.rst    |  2 +-
 .../it_IT/process/adding-syscalls.rst         |  2 +-
 .../it_IT/process/submit-checklist.rst        |  2 +-
 .../translations/ko_KR/memory-barriers.txt    |  2 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |  8 +--
 .../zh_CN/process/submit-checklist.rst        |  2 +-
 Documentation/virt/kvm/arm/pvtime.rst         |  2 +-
 Documentation/virt/kvm/devices/vcpu.rst       |  2 +-
 Documentation/virt/kvm/hypercalls.rst         |  4 +-
 Documentation/virt/kvm/mmu.rst                |  2 +-
 Documentation/virt/kvm/review-checklist.rst   |  2 +-
 MAINTAINERS                                   | 61 +++++++++----------
 Next/merge.log                                | 12 ++--
 arch/powerpc/include/uapi/asm/kvm_para.h      |  2 +-
 arch/x86/kvm/mmu/mmu.c                        |  2 +-
 drivers/base/core.c                           |  2 +-
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |  2 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  2 +-
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |  2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  2 +-
 drivers/gpu/drm/Kconfig                       |  2 +-
 drivers/gpu/drm/drm_ioctl.c                   |  2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h       |  2 +-
 drivers/hwtracing/coresight/Kconfig           |  2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c         |  2 +-
 fs/Kconfig                                    |  2 +-
 fs/Kconfig.binfmt                             |  2 +-
 fs/adfs/Kconfig                               |  2 +-
 fs/affs/Kconfig                               |  2 +-
 fs/afs/Kconfig                                |  6 +-
 fs/bfs/Kconfig                                |  2 +-
 fs/cramfs/Kconfig                             |  2 +-
 fs/ecryptfs/Kconfig                           |  2 +-
 fs/fat/Kconfig                                |  8 +--
 fs/fuse/Kconfig                               |  2 +-
 fs/fuse/dev.c                                 |  2 +-
 fs/hfs/Kconfig                                |  2 +-
 fs/hpfs/Kconfig                               |  2 +-
 fs/isofs/Kconfig                              |  2 +-
 fs/namespace.c                                |  2 +-
 fs/notify/inotify/Kconfig                     |  2 +-
 fs/ntfs/Kconfig                               |  2 +-
 fs/ocfs2/Kconfig                              |  2 +-
 fs/overlayfs/Kconfig                          |  6 +-
 fs/proc/Kconfig                               |  4 +-
 fs/romfs/Kconfig                              |  2 +-
 fs/sysfs/dir.c                                |  2 +-
 fs/sysfs/file.c                               |  2 +-
 fs/sysfs/mount.c                              |  2 +-
 fs/sysfs/symlink.c                            |  2 +-
 fs/sysv/Kconfig                               |  2 +-
 fs/udf/Kconfig                                |  2 +-
 include/linux/kobject.h                       |  2 +-
 include/linux/kobject_ns.h                    |  2 +-
 include/linux/mm.h                            |  4 +-
 include/linux/relay.h                         |  2 +-
 include/linux/sysfs.h                         |  2 +-
 include/uapi/linux/ethtool_netlink.h          |  2 +-
 include/uapi/linux/kvm.h                      |  4 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h      |  2 +-
 kernel/relay.c                                |  2 +-
 lib/kobject.c                                 |  4 +-
 mm/gup.c                                      | 12 ++--
 tools/include/uapi/linux/kvm.h                |  4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |  2 +-
 virt/kvm/arm/vgic/vgic.h                      |  4 +-
 89 files changed, 151 insertions(+), 151 deletions(-)

-- 
2.24.1
