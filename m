From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu May  3 11:57:10 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070503185702.GO21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Here's some various fixes and cleanups I had slated for a later pull, but
our Ocfs2 testing is ahead of schedule.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c             |    6 ++--
 fs/ocfs2/aops.c              |   11 ++++----
 fs/ocfs2/cluster/heartbeat.c |    2 -
 fs/ocfs2/cluster/tcp.c       |   10 +++----
 fs/ocfs2/dir.c               |    7 ++++-
 fs/ocfs2/dlm/dlmast.c        |   12 ++++-----
 fs/ocfs2/dlm/dlmrecovery.c   |    4 +--
 fs/ocfs2/dlm/dlmthread.c     |    2 -
 fs/ocfs2/dlmglue.c           |   54 +++++++++++++++++++++++--------------------
 fs/ocfs2/dlmglue.h           |    7 -----
 fs/ocfs2/export.c            |    6 +++-
 fs/ocfs2/file.c              |   17 +++++++++----
 fs/ocfs2/file.h              |    5 ---
 fs/ocfs2/inode.c             |   35 +++++++++++++++++++++++----
 fs/ocfs2/inode.h             |    1 
 fs/ocfs2/ioctl.c             |   24 +++++++++++++++++++
 fs/ocfs2/ioctl.h             |    1 
 fs/ocfs2/journal.c           |    7 +++--
 fs/ocfs2/namei.c             |    5 ++-
 fs/ocfs2/ocfs2.h             |   12 ++++-----
 fs/ocfs2/ocfs2_fs.h          |    2 +
 fs/ocfs2/suballoc.c          |   10 +++----
 fs/ocfs2/super.c             |    2 -
 23 files changed, 151 insertions(+), 91 deletions(-)

Adrian Bunk:
      fs/ocfs2/: make 3 functions static

Jan Kara:
      Copy i_flags to ocfs2 inode flags on write

Joel Becker:
      ocfs2: Wrap access of directory allocations with ip_alloc_sem.

Mark Fasheh:
      ocfs2: Implement compat_ioctl()
      ocfs2: fix sparse warnings in fs/ocfs2
      ocfs2: fix sparse warnings in fs/ocfs2/dlm
      ocfs2: fix sparse warnings in fs/ocfs2/cluster
      ocfs2: Force use of GFP_NOFS in ocfs2_write()

Milind Arun Choudhary:
      ocfs2: use __set_current_state()

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a0c8667..19712a7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2869,7 +2869,7 @@ int ocfs2_complete_truncate_log_recovery
 	tl = &tl_copy->id2.i_dealloc;
 	num_recs = le16_to_cpu(tl->tl_used);
 	mlog(0, "cleanup %u records from %llu\n", num_recs,
-	     (unsigned long long)tl_copy->i_blkno);
+	     (unsigned long long)le64_to_cpu(tl_copy->i_blkno));
 
 	mutex_lock(&tl_inode->i_mutex);
 	for(i = 0; i < num_recs; i++) {
@@ -3801,8 +3801,8 @@ int ocfs2_prepare_truncate(struct ocfs2_
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
 	mlog(0, "fe->i_clusters = %u, new_i_clusters = %u, fe->i_size ="
-	     "%llu\n", fe->i_clusters, new_i_clusters,
-	     (unsigned long long)fe->i_size);
+	     "%llu\n", le32_to_cpu(fe->i_clusters), new_i_clusters,
+	     (unsigned long long)le64_to_cpu(fe->i_size));
 
 	*tc = kzalloc(sizeof(struct ocfs2_truncate_context), GFP_KERNEL);
 	if (!(*tc)) {
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 56963e6..8e7cafb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -78,7 +78,8 @@ static int ocfs2_symlink_get_block(struc
 
 	if (!OCFS2_IS_VALID_DINODE(fe)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)fe->i_blkno, 7, fe->i_signature);
+		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
+		     fe->i_signature);
 		goto bail;
 	}
 
@@ -939,9 +940,9 @@ out:
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
@@ -1086,7 +1087,7 @@ static ssize_t ocfs2_write(struct file *
 	for(i = 0; i < numpages; i++) {
 		index = start + i;
 
-		cpages[i] = grab_cache_page(mapping, index);
+		cpages[i] = find_or_create_page(mapping, index, GFP_NOFS);
 		if (!cpages[i]) {
 			ret = -ENOMEM;
 			mlog_errno(ret);
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index eba282d..9791134 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -438,7 +438,7 @@ static inline void o2hb_prepare_block(st
 								   hb_block));
 
 	mlog(ML_HB_BIO, "our node generation = 0x%llx, cksum = 0x%x\n",
-	     (long long)cpu_to_le64(generation),
+	     (long long)generation,
 	     le32_to_cpu(hb_block->hb_cksum));
 }
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 69caf3e..0b229a9 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1496,7 +1496,7 @@ static void o2net_start_connect(struct w
 	sock->sk->sk_allocation = GFP_ATOMIC;
 
 	myaddr.sin_family = AF_INET;
-	myaddr.sin_addr.s_addr = (__force u32)mynode->nd_ipv4_address;
+	myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
 	myaddr.sin_port = (__force u16)htons(0); /* any port */
 
 	ret = sock->ops->bind(sock, (struct sockaddr *)&myaddr,
@@ -1521,8 +1521,8 @@ static void o2net_start_connect(struct w
 	spin_unlock(&nn->nn_lock);
 
 	remoteaddr.sin_family = AF_INET;
-	remoteaddr.sin_addr.s_addr = (__force u32)node->nd_ipv4_address;
-	remoteaddr.sin_port = (__force u16)node->nd_ipv4_port;
+	remoteaddr.sin_addr.s_addr = node->nd_ipv4_address;
+	remoteaddr.sin_port = node->nd_ipv4_port;
 
 	ret = sc->sc_sock->ops->connect(sc->sc_sock,
 					(struct sockaddr *)&remoteaddr,
@@ -1810,8 +1810,8 @@ static int o2net_open_listening_sock(__b
 	int ret;
 	struct sockaddr_in sin = {
 		.sin_family = PF_INET,
-		.sin_addr = { .s_addr = (__force u32)addr },
-		.sin_port = (__force u16)port,
+		.sin_addr = { .s_addr = addr },
+		.sin_port = port,
 	};
 
 	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 67e6866..c441ef1 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -403,7 +403,7 @@ static int ocfs2_extend_dir(struct ocfs2
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
-	int credits, num_free_extents;
+	int credits, num_free_extents, drop_alloc_sem = 0;
 	loff_t dir_i_size;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
 	struct ocfs2_alloc_context *data_ac = NULL;
@@ -452,6 +452,9 @@ static int ocfs2_extend_dir(struct ocfs2
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
 	}
 
+	down_write(&OCFS2_I(dir)->ip_alloc_sem);
+	drop_alloc_sem = 1;
+
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -497,6 +500,8 @@ static int ocfs2_extend_dir(struct ocfs2
 	*new_de_bh = new_bh;
 	get_bh(*new_de_bh);
 bail:
+	if (drop_alloc_sem)
+		up_write(&OCFS2_I(dir)->ip_alloc_sem);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 241cad3..2fd8bde 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -312,8 +312,8 @@ int dlm_proxy_ast_handler(struct o2net_m
 	    past->type != DLM_BAST) {
 		mlog(ML_ERROR, "Unknown ast type! %d, cookie=%u:%llu"
 		     "name=%.*s\n", past->type, 
-		     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
-		     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+		     dlm_get_lock_cookie_node(cookie),
+		     dlm_get_lock_cookie_seq(cookie),
 		     locklen, name);
 		ret = DLM_IVLOCKID;
 		goto leave;
@@ -324,8 +324,8 @@ int dlm_proxy_ast_handler(struct o2net_m
 		mlog(0, "got %sast for unknown lockres! "
 		     "cookie=%u:%llu, name=%.*s, namelen=%u\n",
 		     past->type == DLM_AST ? "" : "b",
-		     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
-		     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+		     dlm_get_lock_cookie_node(cookie),
+		     dlm_get_lock_cookie_seq(cookie),
 		     locklen, name, locklen);
 		ret = DLM_IVLOCKID;
 		goto leave;
@@ -370,8 +370,8 @@ int dlm_proxy_ast_handler(struct o2net_m
 
 	mlog(0, "got %sast for unknown lock!  cookie=%u:%llu, "
 	     "name=%.*s, namelen=%u\n", past->type == DLM_AST ? "" : "b", 
-	     dlm_get_lock_cookie_node(be64_to_cpu(cookie)),
-	     dlm_get_lock_cookie_seq(be64_to_cpu(cookie)),
+	     dlm_get_lock_cookie_node(cookie),
+	     dlm_get_lock_cookie_seq(cookie),
 	     locklen, name, locklen);
 
 	ret = DLM_NORMAL;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index c1807a4..671c4ed 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1769,7 +1769,7 @@ static int dlm_process_recovery_data(str
 			/* lock is always created locally first, and
 			 * destroyed locally last.  it must be on the list */
 			if (!lock) {
-				u64 c = ml->cookie;
+				__be64 c = ml->cookie;
 				mlog(ML_ERROR, "could not find local lock "
 					       "with cookie %u:%llu!\n",
 				     dlm_get_lock_cookie_node(be64_to_cpu(c)),
@@ -1878,7 +1878,7 @@ skip_lvb:
 		spin_lock(&res->spinlock);
 		list_for_each_entry(lock, queue, list) {
 			if (lock->ml.cookie == ml->cookie) {
-				u64 c = lock->ml.cookie;
+				__be64 c = lock->ml.cookie;
 				mlog(ML_ERROR, "%s:%.*s: %u:%llu: lock already "
 				     "exists on this lockres!\n", dlm->name,
 				     res->lockname.len, res->lockname.name,
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 2b264c6..cebd089 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -76,7 +76,7 @@ repeat:
 		goto repeat;
 	}
 	remove_wait_queue(&res->wq, &wait);
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
 }
 
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 27e43b0..024777a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -104,6 +104,35 @@ static int ocfs2_dentry_convert_worker(s
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
@@ -3078,28 +3107,3 @@ static void ocfs2_schedule_blocked_lock(
 
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
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 59cb566..492bad3 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -119,11 +119,4 @@ void ocfs2_process_blocked_lock(struct o
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
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 56e1fef..bc48177 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -140,7 +140,7 @@ bail:
 	return parent;
 }
 
-static int ocfs2_encode_fh(struct dentry *dentry, __be32 *fh, int *max_len,
+static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 			   int connectable)
 {
 	struct inode *inode = dentry->d_inode;
@@ -148,6 +148,7 @@ static int ocfs2_encode_fh(struct dentry
 	int type = 1;
 	u64 blkno;
 	u32 generation;
+	__le32 *fh = (__force __le32 *) fh_in;
 
 	mlog_entry("(0x%p, '%.*s', 0x%p, %d, %d)\n", dentry,
 		   dentry->d_name.len, dentry->d_name.name,
@@ -199,7 +200,7 @@ bail:
 	return type;
 }
 
-static struct dentry *ocfs2_decode_fh(struct super_block *sb, __be32 *fh,
+static struct dentry *ocfs2_decode_fh(struct super_block *sb, u32 *fh_in,
 				      int fh_len, int fileid_type,
 				      int (*acceptable)(void *context,
 						        struct dentry *de),
@@ -207,6 +208,7 @@ static struct dentry *ocfs2_decode_fh(st
 {
 	struct ocfs2_inode_handle handle, parent;
 	struct dentry *ret = NULL;
+	__le32 *fh = (__force __le32 *) fh_in;
 
 	mlog_entry("(0x%p, 0x%p, %d, %d, 0x%p, 0x%p)\n",
 		   sb, fh, fh_len, fileid_type, acceptable, context);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 520a2a6..9395b4f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -207,10 +207,10 @@ out:
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
 
@@ -713,7 +713,8 @@ restarted_transaction:
 	}
 
 	mlog(0, "fe: i_clusters = %u, i_size=%llu\n",
-	     fe->i_clusters, (unsigned long long)fe->i_size);
+	     le32_to_cpu(fe->i_clusters),
+	     (unsigned long long)le64_to_cpu(fe->i_size));
 	mlog(0, "inode: ip_clusters=%u, i_size=%lld\n",
 	     OCFS2_I(inode)->ip_clusters, i_size_read(inode));
 
@@ -1853,6 +1854,9 @@ const struct file_operations ocfs2_fops 
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
 	.ioctl		= ocfs2_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = ocfs2_compat_ioctl,
+#endif
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
 };
@@ -1862,4 +1866,7 @@ const struct file_operations ocfs2_dops 
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
 	.ioctl		= ocfs2_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = ocfs2_compat_ioctl,
+#endif
 };
diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 2c4460f..a4dd1fa 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -56,11 +56,6 @@ int ocfs2_getattr(struct vfsmount *mnt, 
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
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 21a6050..bc844bf 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -89,6 +89,25 @@ void ocfs2_set_inode_flags(struct inode 
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to OCFS2_I(inode)->ip_attr */
+void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi)
+{
+	unsigned int flags = oi->vfs_inode.i_flags;
+
+	oi->ip_attr &= ~(OCFS2_SYNC_FL|OCFS2_APPEND_FL|
+			OCFS2_IMMUTABLE_FL|OCFS2_NOATIME_FL|OCFS2_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		oi->ip_attr |= OCFS2_SYNC_FL;
+	if (flags & S_APPEND)
+		oi->ip_attr |= OCFS2_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		oi->ip_attr |= OCFS2_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		oi->ip_attr |= OCFS2_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		oi->ip_attr |= OCFS2_DIRSYNC_FL;
+}
+
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, int flags)
 {
 	struct inode *inode = NULL;
@@ -196,7 +215,7 @@ int ocfs2_populate_inode(struct inode *i
 	int status = -EINVAL;
 
 	mlog_entry("(0x%p, size:%llu)\n", inode,
-		   (unsigned long long)fe->i_size);
+		   (unsigned long long)le64_to_cpu(fe->i_size));
 
 	sb = inode->i_sb;
 	osb = OCFS2_SB(sb);
@@ -248,7 +267,7 @@ int ocfs2_populate_inode(struct inode *i
 		mlog(ML_ERROR,
 		     "ip_blkno %llu != i_blkno %llu!\n",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
-		     (unsigned long long)fe->i_blkno);
+		     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
 
@@ -301,7 +320,7 @@ int ocfs2_populate_inode(struct inode *i
 		 * the generation argument to
 		 * ocfs2_inode_lock_res_init() will have to change.
 		 */
-		BUG_ON(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL));
+		BUG_ON(le32_to_cpu(fe->i_flags) & OCFS2_SYSTEM_FL);
 
 		ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_meta_lockres,
 					  OCFS2_LOCK_TYPE_META, 0, inode);
@@ -437,7 +456,8 @@ static int ocfs2_read_locked_inode(struc
 	fe = (struct ocfs2_dinode *) bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(fe)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)fe->i_blkno, 7, fe->i_signature);
+		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
+		     fe->i_signature);
 		goto bail;
 	}
 
@@ -812,8 +832,8 @@ static int ocfs2_query_inode_wipe(struct
 		     "Inode %llu (on-disk %llu) not orphaned! "
 		     "Disk flags  0x%x, inode flags 0x%x\n",
 		     (unsigned long long)oi->ip_blkno,
-		     (unsigned long long)di->i_blkno, di->i_flags,
-		     oi->ip_flags);
+		     (unsigned long long)le64_to_cpu(di->i_blkno),
+		     le32_to_cpu(di->i_flags), oi->ip_flags);
 		goto bail;
 	}
 
@@ -1106,8 +1126,10 @@ struct buffer_head *ocfs2_bread(struct i
 		return NULL;
 	}
 
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
 	tmperr = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL,
 					     NULL);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 	if (tmperr < 0) {
 		mlog_errno(tmperr);
 		goto fail;
@@ -1197,6 +1219,7 @@ int ocfs2_mark_inode_dirty(handle_t *han
 
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	fe->i_clusters = cpu_to_le32(OCFS2_I(inode)->ip_clusters);
+	ocfs2_get_inode_flags(OCFS2_I(inode));
 	fe->i_attr = cpu_to_le32(OCFS2_I(inode)->ip_attr);
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 03ae075..a41d081 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -141,6 +141,7 @@ int ocfs2_aio_read(struct file *file, st
 int ocfs2_aio_write(struct file *file, struct kiocb *req, struct iocb *iocb);
 
 void ocfs2_set_inode_flags(struct inode *inode);
+void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi);
 
 static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
 {
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 4768be5..f3ad21a 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -31,6 +31,7 @@ static int ocfs2_get_inode_attr(struct i
 		mlog_errno(status);
 		return status;
 	}
+	ocfs2_get_inode_flags(OCFS2_I(inode));
 	*flags = OCFS2_I(inode)->ip_attr;
 	ocfs2_meta_unlock(inode, 0);
 
@@ -134,3 +135,26 @@ int ocfs2_ioctl(struct inode * inode, st
 	}
 }
 
+#ifdef CONFIG_COMPAT
+long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int ret;
+
+	switch (cmd) {
+	case OCFS2_IOC32_GETFLAGS:
+		cmd = OCFS2_IOC_GETFLAGS;
+		break;
+	case OCFS2_IOC32_SETFLAGS:
+		cmd = OCFS2_IOC_SETFLAGS;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	lock_kernel();
+	ret = ocfs2_ioctl(inode, file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+#endif
diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
index 4a7c829..4d6c4f4 100644
--- a/fs/ocfs2/ioctl.h
+++ b/fs/ocfs2/ioctl.h
@@ -12,5 +12,6 @@ #define OCFS2_IOCTL_H
 
 int ocfs2_ioctl(struct inode * inode, struct file * filp,
 	unsigned int cmd, unsigned long arg);
+long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
 #endif /* OCFS2_IOCTL_H */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 5a8a90d..dc11880 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -435,7 +435,8 @@ static int ocfs2_journal_toggle_dirty(st
 		 * handle the errors in a specific manner, so no need
 		 * to call ocfs2_error() here. */
 		mlog(ML_ERROR, "Journal dinode %llu  has invalid "
-		     "signature: %.*s", (unsigned long long)fe->i_blkno, 7,
+		     "signature: %.*s",
+		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
 		     fe->i_signature);
 		status = -EIO;
 		goto out;
@@ -742,7 +743,7 @@ void ocfs2_complete_recovery(struct work
 		la_dinode = item->lri_la_dinode;
 		if (la_dinode) {
 			mlog(0, "Clean up local alloc %llu\n",
-			     (unsigned long long)la_dinode->i_blkno);
+			     (unsigned long long)le64_to_cpu(la_dinode->i_blkno));
 
 			ret = ocfs2_complete_local_alloc_recovery(osb,
 								  la_dinode);
@@ -755,7 +756,7 @@ void ocfs2_complete_recovery(struct work
 		tl_dinode = item->lri_tl_dinode;
 		if (tl_dinode) {
 			mlog(0, "Clean up truncate log %llu\n",
-			     (unsigned long long)tl_dinode->i_blkno);
+			     (unsigned long long)le64_to_cpu(tl_dinode->i_blkno));
 
 			ret = ocfs2_complete_truncate_log_recovery(osb,
 								   tl_dinode);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2bcf353..36289e6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -578,8 +578,9 @@ static int ocfs2_mknod_locked(struct ocf
 	if (ocfs2_populate_inode(inode, fe, 1) < 0) {
 		mlog(ML_ERROR, "populate inode failed! bh->b_blocknr=%llu, "
 		     "i_blkno=%llu, i_ino=%lu\n",
-		     (unsigned long long) (*new_fe_bh)->b_blocknr,
-		     (unsigned long long)fe->i_blkno, inode->i_ino);
+		     (unsigned long long)(*new_fe_bh)->b_blocknr,
+		     (unsigned long long)le64_to_cpu(fe->i_blkno),
+		     inode->i_ino);
 		BUG();
 	}
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 82cc92d..a860633 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -363,9 +363,9 @@ #define OCFS2_RO_ON_INVALID_DINODE(__sb,
 	typeof(__di) ____di = (__di);					\
 	ocfs2_error((__sb), 						\
 		"Dinode # %llu has bad signature %.*s",			\
-		(unsigned long long)(____di)->i_blkno, 7,		\
+		(unsigned long long)le64_to_cpu((____di)->i_blkno), 7, 	\
 		(____di)->i_signature);					\
-} while (0);
+} while (0)
 
 #define OCFS2_IS_VALID_EXTENT_BLOCK(ptr)				\
 	(!strcmp((ptr)->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE))
@@ -374,9 +374,9 @@ #define OCFS2_RO_ON_INVALID_EXTENT_BLOCK
 	typeof(__eb) ____eb = (__eb);					\
 	ocfs2_error((__sb), 						\
 		"Extent Block # %llu has bad signature %.*s",		\
-		(unsigned long long)(____eb)->h_blkno, 7,		\
+		(unsigned long long)le64_to_cpu((____eb)->h_blkno), 7,	\
 		(____eb)->h_signature);					\
-} while (0);
+} while (0)
 
 #define OCFS2_IS_VALID_GROUP_DESC(ptr)					\
 	(!strcmp((ptr)->bg_signature, OCFS2_GROUP_DESC_SIGNATURE))
@@ -385,9 +385,9 @@ #define OCFS2_RO_ON_INVALID_GROUP_DESC(_
 	typeof(__gd) ____gd = (__gd);					\
 		ocfs2_error((__sb),					\
 		"Group Descriptor # %llu has bad signature %.*s",	\
-		(unsigned long long)(____gd)->bg_blkno, 7,		\
+		(unsigned long long)le64_to_cpu((____gd)->bg_blkno), 7, \
 		(____gd)->bg_signature);				\
-} while (0);
+} while (0)
 
 static inline unsigned long ino_from_blkno(struct super_block *sb,
 					   u64 blkno)
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7130647..f0d9eb0 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -166,6 +166,8 @@ #define OCFS2_EXT_UNWRITTEN	(0x01)	/* Ex
  */
 #define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
 #define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
+#define OCFS2_IOC32_GETFLAGS	_IOR('f', 1, int)
+#define OCFS2_IOC32_SETFLAGS	_IOW('f', 2, int)
 
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0da655a..e343762 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -849,9 +849,9 @@ static int ocfs2_relink_block_group(hand
 	}
 
 	mlog(0, "Suballoc %llu, chain %u, move group %llu to top, prev = %llu\n",
-	     (unsigned long long)fe->i_blkno, chain,
-	     (unsigned long long)bg->bg_blkno,
-	     (unsigned long long)prev_bg->bg_blkno);
+	     (unsigned long long)le64_to_cpu(fe->i_blkno), chain,
+	     (unsigned long long)le64_to_cpu(bg->bg_blkno),
+	     (unsigned long long)le64_to_cpu(prev_bg->bg_blkno));
 
 	fe_ptr = le64_to_cpu(fe->id2.i_chain.cl_recs[chain].c_blkno);
 	bg_ptr = le64_to_cpu(bg->bg_next_group);
@@ -1162,7 +1162,7 @@ static int ocfs2_search_chain(struct ocf
 	}
 
 	mlog(0, "alloc succeeds: we give %u bits from block group %llu\n",
-	     tmp_bits, (unsigned long long)bg->bg_blkno);
+	     tmp_bits, (unsigned long long)le64_to_cpu(bg->bg_blkno));
 
 	*num_bits = tmp_bits;
 
@@ -1227,7 +1227,7 @@ static int ocfs2_search_chain(struct ocf
 	}
 
 	mlog(0, "Allocated %u bits from suballocator %llu\n", *num_bits,
-	     (unsigned long long)fe->i_blkno);
+	     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
 	*bg_blkno = le64_to_cpu(bg->bg_blkno);
 	*bits_left = le16_to_cpu(bg->bg_free_bits_count);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5c9e824..f549354 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1538,7 +1538,7 @@ static int ocfs2_verify_volume(struct oc
 		} else if (bh->b_blocknr != le64_to_cpu(di->i_blkno)) {
 			mlog(ML_ERROR, "bad block number on superblock: "
 			     "found %llu, should be %llu\n",
-			     (unsigned long long)di->i_blkno,
+			     (unsigned long long)le64_to_cpu(di->i_blkno),
 			     (unsigned long long)bh->b_blocknr);
 		} else if (le32_to_cpu(di->id2.i_super.s_clustersize_bits) < 12 ||
 			    le32_to_cpu(di->id2.i_super.s_clustersize_bits) > 20) {
