From: Adrian Bunk <bunk@stusta.de>
Date: Tue Apr 10 14:09:00 2007
Subject: [Ocfs2-devel] [RFC: -mm patch] fs/ocfs2/: make 3 functions static
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
Message-ID: <20070410210842.GK28370@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm4:
>...
>  git-ocfs2.patch
>...
>  git trees.
>...


This patch makes the following needlessly global functions static:
- aops.c: ocfs2_write_data_page()
- dlmglue.c: ocfs2_dump_meta_lvb_info()
- file.c: ocfs2_set_inode_size()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/ocfs2/aops.c    |    6 ++---
 fs/ocfs2/dlmglue.c |   54 ++++++++++++++++++++++++---------------------
 fs/ocfs2/dlmglue.h |    7 -----
 fs/ocfs2/file.c    |    8 +++---
 fs/ocfs2/file.h    |    5 ----
 5 files changed, 36 insertions(+), 44 deletions(-)

--- linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c.old	2007-04-10 00:38:47.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c	2007-04-10 00:38:55.000000000 +0200
@@ -934,9 +934,9 @@
  * Returns a negative error code or the number of bytes copied into
  * the page.
  */
-int ocfs2_write_data_page(struct inode *inode, handle_t *handle,
-			  u64 *p_blkno, struct page *page,
-			  struct ocfs2_write_ctxt *wc, int new)
+static int ocfs2_write_data_page(struct inode *inode, handle_t *handle,
+				 u64 *p_blkno, struct page *page,
+				 struct ocfs2_write_ctxt *wc, int new)
 {
 	int ret, copied = 0;
 	unsigned int from = 0, to = 0;
--- linux-2.6.21-rc6-mm1/fs/ocfs2/dlmglue.h.old	2007-04-10 00:41:39.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/ocfs2/dlmglue.h	2007-04-10 00:47:06.000000000 +0200
@@ -119,11 +119,4 @@
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
-/* aids in debugging and tracking lvbs */
-void ocfs2_dump_meta_lvb_info(u64 level,
-			      const char *function,
-			      unsigned int line,
-			      struct ocfs2_lock_res *lockres);
-#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
-
 #endif	/* DLMGLUE_H */
--- linux-2.6.21-rc6-mm1/fs/ocfs2/dlmglue.c.old	2007-04-10 00:42:19.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/ocfs2/dlmglue.c	2007-04-10 00:44:23.000000000 +0200
@@ -103,6 +103,35 @@
 static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 				     struct ocfs2_lock_res *lockres);
 
+
+#define mlog_meta_lvb(__level, __lockres) ocfs2_dump_meta_lvb_info(__level, __PRETTY_FUNCTION__, __LINE__, __lockres)
+
+/* This aids in debugging situations where a bad LVB might be involved. */
+static void ocfs2_dump_meta_lvb_info(u64 level,
+				     const char *function,
+				     unsigned int line,
+				     struct ocfs2_lock_res *lockres)
+{
+	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+
+	mlog(level, "LVB information for %s (called from %s:%u):\n",
+	     lockres->l_name, function, line);
+	mlog(level, "version: %u, clusters: %u, generation: 0x%x\n",
+	     lvb->lvb_version, be32_to_cpu(lvb->lvb_iclusters),
+	     be32_to_cpu(lvb->lvb_igeneration));
+	mlog(level, "size: %llu, uid %u, gid %u, mode 0x%x\n",
+	     (unsigned long long)be64_to_cpu(lvb->lvb_isize),
+	     be32_to_cpu(lvb->lvb_iuid), be32_to_cpu(lvb->lvb_igid),
+	     be16_to_cpu(lvb->lvb_imode));
+	mlog(level, "nlink %u, atime_packed 0x%llx, ctime_packed 0x%llx, "
+	     "mtime_packed 0x%llx iattr 0x%x\n", be16_to_cpu(lvb->lvb_inlink),
+	     (long long)be64_to_cpu(lvb->lvb_iatime_packed),
+	     (long long)be64_to_cpu(lvb->lvb_ictime_packed),
+	     (long long)be64_to_cpu(lvb->lvb_imtime_packed),
+	     be32_to_cpu(lvb->lvb_iattr));
+}
+
+
 /*
  * OCFS2 Lock Resource Operations
  *
@@ -3078,28 +3107,3 @@
 
 	mlog_exit_void();
 }
-
-/* This aids in debugging situations where a bad LVB might be involved. */
-void ocfs2_dump_meta_lvb_info(u64 level,
-			      const char *function,
-			      unsigned int line,
-			      struct ocfs2_lock_res *lockres)
-{
-	struct ocfs2_meta_lvb *lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
-
-	mlog(level, "LVB information for %s (called from %s:%u):\n",
-	     lockres->l_name, function, line);
-	mlog(level, "version: %u, clusters: %u, generation: 0x%x\n",
-	     lvb->lvb_version, be32_to_cpu(lvb->lvb_iclusters),
-	     be32_to_cpu(lvb->lvb_igeneration));
-	mlog(level, "size: %llu, uid %u, gid %u, mode 0x%x\n",
-	     (unsigned long long)be64_to_cpu(lvb->lvb_isize),
-	     be32_to_cpu(lvb->lvb_iuid), be32_to_cpu(lvb->lvb_igid),
-	     be16_to_cpu(lvb->lvb_imode));
-	mlog(level, "nlink %u, atime_packed 0x%llx, ctime_packed 0x%llx, "
-	     "mtime_packed 0x%llx iattr 0x%x\n", be16_to_cpu(lvb->lvb_inlink),
-	     (long long)be64_to_cpu(lvb->lvb_iatime_packed),
-	     (long long)be64_to_cpu(lvb->lvb_ictime_packed),
-	     (long long)be64_to_cpu(lvb->lvb_imtime_packed),
-	     be32_to_cpu(lvb->lvb_iattr));
-}
--- linux-2.6.21-rc6-mm1/fs/ocfs2/file.h.old	2007-04-10 00:45:00.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/ocfs2/file.h	2007-04-10 00:45:07.000000000 +0200
@@ -56,11 +56,6 @@
 int ocfs2_permission(struct inode *inode, int mask,
 		     struct nameidata *nd);
 
-int ocfs2_set_inode_size(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *fe_bh,
-			 u64 new_i_size);
-
 int ocfs2_should_update_atime(struct inode *inode,
 			      struct vfsmount *vfsmnt);
 int ocfs2_update_inode_atime(struct inode *inode,
--- linux-2.6.21-rc6-mm1/fs/ocfs2/file.c.old	2007-04-10 00:45:15.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/ocfs2/file.c	2007-04-10 00:45:24.000000000 +0200
@@ -207,10 +207,10 @@
 	return ret;
 }
 
-int ocfs2_set_inode_size(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *fe_bh,
-			 u64 new_i_size)
+static int ocfs2_set_inode_size(handle_t *handle,
+				struct inode *inode,
+				struct buffer_head *fe_bh,
+				u64 new_i_size)
 {
 	int status;
 
