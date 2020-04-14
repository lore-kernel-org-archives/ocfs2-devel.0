From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date: Tue, 14 Apr 2020 14:42:59 +0200
Subject: [Ocfs2-devel] [PATCH 5/8] simplefs: add alloc_anon_inode wrapper
In-Reply-To: <20200414124304.4470-1-eesposit@redhat.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
Message-ID: <20200414124304.4470-6-eesposit@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nfs@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Emanuele Giuseppe Esposito <eesposit@redhat.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>, linux-fsdevel@vger.kernel.org, "Manoj N. Kumar" <manoj@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>

Start adding file creation wrappers, the simplest returns an anonymous
inode.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 drivers/gpu/drm/drm_drv.c       | 2 +-
 drivers/misc/cxl/api.c          | 2 +-
 drivers/scsi/cxlflash/ocxl_hw.c | 2 +-
 fs/simplefs.c                   | 6 ++++++
 include/linux/simplefs.h        | 2 ++
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index b4b357725be2..4e4ea1bf312c 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -539,7 +539,7 @@ static struct inode *drm_fs_inode_new(void)
 		return ERR_PTR(r);
 	}
 
-	inode = alloc_anon_inode(drm_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&drm_fs);
 	if (IS_ERR(inode))
 		simple_release_fs(&drm_fs);
 
diff --git a/drivers/misc/cxl/api.c b/drivers/misc/cxl/api.c
index 6c6566d8bc17..a3d2682eb3a7 100644
--- a/drivers/misc/cxl/api.c
+++ b/drivers/misc/cxl/api.c
@@ -73,7 +73,7 @@ static struct file *cxl_getfile(const char *name,
 		goto err_module;
 	}
 
-	inode = alloc_anon_inode(cxl_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&cxl_fs);
 	if (IS_ERR(inode)) {
 		file = ERR_CAST(inode);
 		goto err_fs;
diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
index 23afde0c6c0e..770fdf186028 100644
--- a/drivers/scsi/cxlflash/ocxl_hw.c
+++ b/drivers/scsi/cxlflash/ocxl_hw.c
@@ -86,7 +86,7 @@ static struct file *ocxlflash_getfile(struct device *dev, const char *name,
 		goto err2;
 	}
 
-	inode = alloc_anon_inode(ocxlflash_fs.mount->mnt_sb);
+	inode = simple_alloc_anon_inode(&ocxlflash_fs);
 	if (IS_ERR(inode)) {
 		rc = PTR_ERR(inode);
 		dev_err(dev, "%s: alloc_anon_inode failed rc=%d\n",
diff --git a/fs/simplefs.c b/fs/simplefs.c
index 790d8beb9cc3..c59eb8d996be 100644
--- a/fs/simplefs.c
+++ b/fs/simplefs.c
@@ -36,3 +36,9 @@ void simple_release_fs(struct simple_fs *fs)
 	mntput(mnt);
 }
 EXPORT_SYMBOL(simple_release_fs);
+
+struct inode *simple_alloc_anon_inode(struct simple_fs *fs)
+{
+	return alloc_anon_inode(fs->mount->mnt_sb);
+}
+EXPORT_SYMBOL(simple_alloc_anon_inode);
diff --git a/include/linux/simplefs.h b/include/linux/simplefs.h
index 18010414a16f..c62ab526414e 100644
--- a/include/linux/simplefs.h
+++ b/include/linux/simplefs.h
@@ -12,4 +12,6 @@ struct simple_fs {
 extern int simple_pin_fs(struct simple_fs *, struct file_system_type *);
 extern void simple_release_fs(struct simple_fs *);
 
+extern struct inode *simple_alloc_anon_inode(struct simple_fs *fs);
+
 #endif
-- 
2.25.2
