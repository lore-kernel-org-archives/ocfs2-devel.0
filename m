From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date: Tue, 14 Apr 2020 14:42:54 +0200
Subject: [Ocfs2-devel] [PATCH 0/8] Simplefs: group and simplify linux fs code
Message-ID: <20200414124304.4470-1-eesposit@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nfs@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Emanuele Giuseppe Esposito <eesposit@redhat.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

This series of patches introduce wrappers for functions,
arguments simplification in functions calls and most importantly
groups duplicated code in a single header, simplefs, to avoid redundancy
in the linux fs, especially debugfs and tracefs.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

Emanuele Giuseppe Esposito (8):
  apparmor: just use vfs_kern_mount to make .null
  fs: extract simple_pin/release_fs to separate files
  fs: wrap simple_pin_fs/simple_release_fs arguments in a struct
  fs: introduce simple_new_inode
  simplefs: add alloc_anon_inode wrapper
  simplefs: add file creation functions
  debugfs: switch to simplefs inode creation API
  tracefs: switch to simplefs inode creation API

 arch/powerpc/platforms/cell/spufs/inode.c |   4 +-
 arch/s390/hypfs/inode.c                   |   4 +-
 drivers/gpu/drm/Kconfig                   |   1 +
 drivers/gpu/drm/drm_drv.c                 |  13 +-
 drivers/infiniband/hw/qib/qib_fs.c        |   6 +-
 drivers/misc/cxl/Kconfig                  |   1 +
 drivers/misc/cxl/api.c                    |  14 +-
 drivers/misc/ibmasm/ibmasmfs.c            |   8 +-
 drivers/misc/ocxl/Kconfig                 |   1 +
 drivers/oprofile/oprofilefs.c             |   8 +-
 drivers/scsi/cxlflash/ocxl_hw.c           |  15 +-
 drivers/usb/gadget/function/f_fs.c        |   8 +-
 fs/Kconfig                                |   3 +
 fs/Kconfig.binfmt                         |   1 +
 fs/Makefile                               |   1 +
 fs/autofs/inode.c                         |   4 +-
 fs/binfmt_misc.c                          |  27 +--
 fs/configfs/Kconfig                       |   1 +
 fs/configfs/mount.c                       |  12 +-
 fs/debugfs/inode.c                        | 171 +++----------------
 fs/efivarfs/inode.c                       |   4 +-
 fs/fuse/control.c                         |   4 +-
 fs/hugetlbfs/inode.c                      |   8 +-
 fs/libfs.c                                |  48 ++----
 fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
 fs/proc/base.c                            |   4 +-
 fs/proc/proc_sysctl.c                     |   5 +-
 fs/pstore/inode.c                         |  14 +-
 fs/ramfs/inode.c                          |   4 +-
 fs/simplefs.c                             | 194 ++++++++++++++++++++++
 fs/tracefs/inode.c                        | 108 ++----------
 include/linux/fs.h                        |   3 +-
 include/linux/simplefs.h                  |  36 ++++
 ipc/mqueue.c                              |   4 +-
 kernel/bpf/inode.c                        |   7 +-
 lib/Kconfig.debug                         |  16 +-
 mm/shmem.c                                |   4 +-
 net/sunrpc/rpc_pipe.c                     |   4 +-
 security/Kconfig                          |   1 +
 security/apparmor/apparmorfs.c            |  48 +++---
 security/inode.c                          |  17 +-
 41 files changed, 385 insertions(+), 459 deletions(-)
 create mode 100644 fs/simplefs.c
 create mode 100644 include/linux/simplefs.h

-- 
2.25.2
