From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 27 17:16:04 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20071128011526.GX28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,
	Here's some more Ocfs2 patches for 2.6.24. This series also includes
a small performance fixup from Jan Kara. The rest of the patches are bug
fixes or very trivial cleanups.

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/Kconfig                 |    9 +++++++++
 fs/ocfs2/aops.c            |    2 +-
 fs/ocfs2/cluster/masklog.h |    2 +-
 fs/ocfs2/dcache.c          |   20 ++++++++++++++++----
 fs/ocfs2/dlm/dlmmaster.c   |    4 ++--
 fs/ocfs2/file.c            |   19 +++++++++++++++----
 fs/ocfs2/inode.c           |    6 +++---
 fs/ocfs2/localalloc.c      |    5 +++--
 fs/ocfs2/super.c           |    6 +++---
 9 files changed, 53 insertions(+), 20 deletions(-)

Jan Kara (1):
      ocfs2: Remove expensive bitmap scanning

Joe Perches (1):
      fs/ocfs2: Add missing "space"

Mark Fasheh (6):
      ocfs2: Reset journal parameters after s_mount_opt update
      ocfs2: Filter -ENOSPC in mlog_errno()
      ocfs2: log valid inode # on bad inode
      ocfs2: Remove bug statement in ocfs2_dentry_iput()
      ocfs2: Fix comparison in ocfs2_size_fits_inline_data()
      ocfs2: reverse inline-data truncate args

diff --git a/fs/Kconfig b/fs/Kconfig
index 429a002..635f3e2 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -459,6 +459,15 @@ config OCFS2_DEBUG_MASKLOG
 	  This option will enlarge your kernel, but it allows debugging of
 	  ocfs2 filesystem issues.
 
+config OCFS2_DEBUG_FS
+	bool "OCFS2 expensive checks"
+	depends on OCFS2_FS
+	default n
+	help
+	  This option will enable expensive consistency checks. Enable
+	  this option for debugging only as it is likely to decrease
+	  performance of the filesystem.
+
 config MINIX_FS
 	tristate "Minix fs support"
 	help
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 556e34c..56f7790 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1514,7 +1514,7 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
 {
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	if (new_size < le16_to_cpu(di->id2.i_data.id_count))
+	if (new_size <= le16_to_cpu(di->id2.i_data.id_count))
 		return 1;
 	return 0;
 }
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index cd04606..597e064 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -212,7 +212,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 #define mlog_errno(st) do {						\
 	int _st = (st);							\
 	if (_st != -ERESTARTSYS && _st != -EINTR &&			\
-	    _st != AOP_TRUNCATED_PAGE)					\
+	    _st != AOP_TRUNCATED_PAGE && _st != -ENOSPC)		\
 		mlog(ML_ERROR, "status = %lld\n", (long long)_st);	\
 } while (0)
 
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 1957a5e..9923278 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -344,12 +344,24 @@ static void ocfs2_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 
-	mlog_bug_on_msg(!dl && !(dentry->d_flags & DCACHE_DISCONNECTED),
-			"dentry: %.*s\n", dentry->d_name.len,
-			dentry->d_name.name);
+	if (!dl) {
+		/*
+		 * No dentry lock is ok if we're disconnected or
+		 * unhashed.
+		 */
+		if (!(dentry->d_flags & DCACHE_DISCONNECTED) &&
+		    !d_unhashed(dentry)) {
+			unsigned long long ino = 0ULL;
+			if (inode)
+				ino = (unsigned long long)OCFS2_I(inode)->ip_blkno;
+			mlog(ML_ERROR, "Dentry is missing cluster lock. "
+			     "inode: %llu, d_flags: 0x%x, d_name: %.*s\n",
+			     ino, dentry->d_flags, dentry->d_name.len,
+			     dentry->d_name.name);
+		}
 
-	if (!dl)
 		goto out;
+	}
 
 	mlog_bug_on_msg(dl->dl_count == 0, "dentry: %.*s, count: %u\n",
 			dentry->d_name.len, dentry->d_name.name,
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 62e4a7d..a54d33d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -908,7 +908,7 @@ lookup:
 		 * but they might own this lockres.  wait on them. */
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
@@ -962,7 +962,7 @@ redo_request:
 		spin_lock(&dlm->spinlock);
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index bbac7cd..b75b2e1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -399,7 +399,7 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
-					       i_size_read(inode), 0);
+					       i_size_read(inode), 1);
 		if (status)
 			mlog_errno(status);
 
@@ -1521,6 +1521,7 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 	u32 trunc_start, trunc_len, cpos, phys_cpos, alloc_size;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	struct address_space *mapping = inode->i_mapping;
 
 	ocfs2_init_dealloc_ctxt(&dealloc);
 
@@ -1529,10 +1530,20 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
 		ret = ocfs2_truncate_inline(inode, di_bh, byte_start,
-					    byte_start + byte_len, 1);
-		if (ret)
+					    byte_start + byte_len, 0);
+		if (ret) {
 			mlog_errno(ret);
-		return ret;
+			goto out;
+		}
+		/*
+		 * There's no need to get fancy with the page cache
+		 * truncate of an inline-data inode. We're talking
+		 * about less than a page here, which will be cached
+		 * in the dinode buffer anyway.
+		 */
+		unmap_mapping_range(mapping, 0, 0, 0);
+		truncate_inode_pages(mapping, 0);
+		goto out;
 	}
 
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1d5e0cb..ebb2bbe 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -455,8 +455,8 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	status = -EINVAL;
 	fe = (struct ocfs2_dinode *) bh->b_data;
 	if (!OCFS2_IS_VALID_DINODE(fe)) {
-		mlog(ML_ERROR, "Invalid dinode #%llu: signature = %.*s\n",
-		     (unsigned long long)le64_to_cpu(fe->i_blkno), 7,
+		mlog(0, "Invalid dinode #%llu: signature = %.*s\n",
+		     (unsigned long long)args->fi_blkno, 7,
 		     fe->i_signature);
 		goto bail;
 	}
@@ -863,7 +863,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	status = ocfs2_try_open_lock(inode, 1);
 	if (status == -EAGAIN) {
 		status = 0;
-		mlog(0, "Skipping delete of %llu because it is in use on"
+		mlog(0, "Skipping delete of %llu because it is in use on "
 		     "other nodes\n", (unsigned long long)oi->ip_blkno);
 		goto bail;
 	}
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index d272847..58ea88b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -484,6 +484,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 
+#ifdef OCFS2_DEBUG_FS
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
@@ -494,6 +495,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		status = -EIO;
 		goto bail;
 	}
+#endif
 
 	free_bits = le32_to_cpu(alloc->id1.bitmap1.i_total) -
 		le32_to_cpu(alloc->id1.bitmap1.i_used);
@@ -712,9 +714,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	void *bitmap;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	mlog_entry("total = %u, COUNT = %u, used = %u\n",
+	mlog_entry("total = %u, used = %u\n",
 		   le32_to_cpu(alloc->id1.bitmap1.i_total),
-		   ocfs2_local_alloc_count_bits(alloc),
 		   le32_to_cpu(alloc->id1.bitmap1.i_used));
 
 	if (!alloc->id1.bitmap1.i_total) {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index be562ac..5ee7754 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -438,14 +438,14 @@ unlock_osb:
 	}
 
 	if (!ret) {
-		if (!ocfs2_is_hard_readonly(osb))
-			ocfs2_set_journal_params(osb);
-
 		/* Only save off the new mount options in case of a successful
 		 * remount. */
 		osb->s_mount_opt = parsed_options.mount_opt;
 		osb->s_atime_quantum = parsed_options.atime_quantum;
 		osb->preferred_slot = parsed_options.slot;
+
+		if (!ocfs2_is_hard_readonly(osb))
+			ocfs2_set_journal_params(osb);
 	}
 out:
 	return ret;
