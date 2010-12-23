From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:09 +0800
Subject: [Ocfs2-devel] [PATCH 26/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/dir.c
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-26-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

This is the 2nd step to remove the debug info of NAMEI.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/dir.c         |   83 +++++++++-----------
 fs/ocfs2/ocfs2_trace.h |  197 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 234 insertions(+), 46 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 65546e3..2dfb8ad 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -43,7 +43,6 @@
 #include <linux/quotaops.h>
 #include <linux/sort.h>
 
-#define MLOG_MASK_PREFIX ML_NAMEI
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
@@ -61,6 +60,7 @@
 #include "super.h"
 #include "sysfile.h"
 #include "uptodate.h"
+#include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
 
@@ -400,7 +400,7 @@ static int inline ocfs2_search_dirblock(struct buffer_head *bh,
 	}
 
 bail:
-	mlog(0, "ret = %d\n", ret);
+	trace_ocfs2_search_dirblock(ret);
 	return ret;
 }
 
@@ -445,8 +445,7 @@ static int ocfs2_validate_dir_block(struct super_block *sb,
 	 * We don't validate dirents here, that's handled
 	 * in-place when the code walks them.
 	 */
-	mlog(0, "Validating dirblock %llu\n",
-	     (unsigned long long)bh->b_blocknr);
+	trace_ocfs2_validate_dir_block((unsigned long long)bh->b_blocknr);
 
 	BUG_ON(!buffer_uptodate(bh));
 
@@ -784,7 +783,7 @@ cleanup_and_exit:
 	for (; ra_ptr < ra_max; ra_ptr++)
 		brelse(bh_use[ra_ptr]);
 
-	mlog(0, "ret = %p\n", ret);
+	trace_ocfs2_find_entry_el(ret);
 	return ret;
 }
 
@@ -946,11 +945,9 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 		goto out;
 	}
 
-	mlog(0, "Dir %llu: name: \"%.*s\", lookup of hash: %u.0x%x "
-	     "returns: %llu\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
-	     namelen, name, hinfo->major_hash, hinfo->minor_hash,
-	     (unsigned long long)phys);
+	trace_ocfs2_dx_dir_search((unsigned long long)OCFS2_I(dir)->ip_blkno,
+				  namelen, name, hinfo->major_hash,
+				  hinfo->minor_hash, (unsigned long long)phys);
 
 	ret = ocfs2_read_dx_leaf(dir, phys, &dx_leaf_bh);
 	if (ret) {
@@ -960,9 +957,9 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 
 	dx_leaf = (struct ocfs2_dx_leaf *) dx_leaf_bh->b_data;
 
-	mlog(0, "leaf info: num_used: %d, count: %d\n",
-	     le16_to_cpu(dx_leaf->dl_list.de_num_used),
-	     le16_to_cpu(dx_leaf->dl_list.de_count));
+	trace_ocfs2_dx_dir_search_leaf_info(
+			le16_to_cpu(dx_leaf->dl_list.de_num_used),
+			le16_to_cpu(dx_leaf->dl_list.de_count));
 
 	entry_list = &dx_leaf->dl_list;
 
@@ -1162,8 +1159,6 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 	int i, status = -ENOENT;
 	ocfs2_journal_access_func access = ocfs2_journal_access_db;
 
-	mlog(0, "(0x%p, 0x%p, 0x%p, 0x%p)\n", handle, dir, de_del, bh);
-
 	if (OCFS2_I(dir)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		access = ocfs2_journal_access_di;
 
@@ -1343,8 +1338,8 @@ static int ocfs2_delete_entry_dx(handle_t *handle, struct inode *dir,
 		}
 	}
 
-	mlog(0, "Dir %llu: delete entry at index: %d\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno, index);
+	trace_ocfs2_delete_entry_dx((unsigned long long)OCFS2_I(dir)->ip_blkno,
+				    index);
 
 	ret = __ocfs2_delete_entry(handle, dir, lookup->dl_entry,
 				   leaf_bh, leaf_bh->b_data, leaf_bh->b_size);
@@ -2022,8 +2017,7 @@ int ocfs2_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int lock_level = 0;
 
-	mlog(0, "dirino=%llu\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	trace_ocfs2_readdir((unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	error = ocfs2_inode_lock_atime(inode, filp->f_vfsmnt, &lock_level);
 	if (lock_level && error >= 0) {
@@ -2064,8 +2058,8 @@ int ocfs2_find_files_on_disk(const char *name,
 {
 	int status = -ENOENT;
 
-	mlog(0, "name=%.*s, blkno=%p, inode=%llu\n", namelen, name, blkno,
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	trace_ocfs2_find_files_on_disk(namelen, name, blkno,
+				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
 	status = ocfs2_find_entry(name, namelen, inode, lookup);
 	if (status)
@@ -2109,8 +2103,8 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 	int ret;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
-	mlog(0, "dir %llu, name '%.*s'\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
+	trace_ocfs2_check_dir_for_entry(
+		(unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
 
 	ret = -EEXIST;
 	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
@@ -2402,9 +2396,9 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 		goto out;
 	}
 
-	mlog(0, "Dir %llu, attach new index block: %llu\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
-	     (unsigned long long)dr_blkno);
+	trace_ocfs2_dx_dir_attach_index(
+				(unsigned long long)OCFS2_I(dir)->ip_blkno,
+				(unsigned long long)dr_blkno);
 
 	dx_root_bh = sb_getblk(osb->sb, dr_blkno);
 	if (dx_root_bh == NULL) {
@@ -2502,11 +2496,10 @@ static int ocfs2_dx_dir_format_cluster(struct ocfs2_super *osb,
 		dx_leaf->dl_list.de_count =
 			cpu_to_le16(ocfs2_dx_entries_per_leaf(osb->sb));
 
-		mlog(0,
-		     "Dir %llu, format dx_leaf: %llu, entry count: %u\n",
-		     (unsigned long long)OCFS2_I(dir)->ip_blkno,
-		     (unsigned long long)bh->b_blocknr,
-		     le16_to_cpu(dx_leaf->dl_list.de_count));
+		trace_ocfs2_dx_dir_format_cluster(
+				(unsigned long long)OCFS2_I(dir)->ip_blkno,
+				(unsigned long long)bh->b_blocknr,
+				le16_to_cpu(dx_leaf->dl_list.de_count));
 
 		ocfs2_journal_dirty(handle, bh);
 	}
@@ -2750,12 +2743,11 @@ static void ocfs2_dx_dir_index_root_block(struct inode *dir,
 
 		ocfs2_dx_dir_name_hash(dir, de->name, de->name_len, &hinfo);
 
-		mlog(0,
-		     "dir: %llu, major: 0x%x minor: 0x%x, index: %u, name: %.*s\n",
-		     (unsigned long long)dir->i_ino, hinfo.major_hash,
-		     hinfo.minor_hash,
-		     le16_to_cpu(dx_root->dr_entries.de_num_used),
-		     de->name_len, de->name);
+		trace_ocfs2_dx_dir_index_root_block(
+				(unsigned long long)dir->i_ino,
+				hinfo.major_hash, hinfo.minor_hash,
+				de->name_len, de->name,
+				le16_to_cpu(dx_root->dr_entries.de_num_used));
 
 		ocfs2_dx_entry_list_insert(&dx_root->dr_entries, &hinfo,
 					   dirent_blk);
@@ -3308,8 +3300,8 @@ static int ocfs2_extend_dir(struct ocfs2_super *osb,
 	down_write(&OCFS2_I(dir)->ip_alloc_sem);
 	drop_alloc_sem = 1;
 	dir_i_size = i_size_read(dir);
-	mlog(0, "extending dir %llu (i_size = %lld)\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno, dir_i_size);
+	trace_ocfs2_extend_dir((unsigned long long)OCFS2_I(dir)->ip_blkno,
+			       dir_i_size);
 
 	/* dir->i_size is always block aligned. */
 	spin_lock(&OCFS2_I(dir)->ip_lock);
@@ -3803,9 +3795,9 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 	struct ocfs2_dx_root_block *dx_root;
 	struct ocfs2_dx_leaf *tmp_dx_leaf = NULL;
 
-	mlog(0, "DX Dir: %llu, rebalance leaf leaf_blkno: %llu insert: %u\n",
-	     (unsigned long long)OCFS2_I(dir)->ip_blkno,
-	     (unsigned long long)leaf_blkno, insert_hash);
+	trace_ocfs2_dx_dir_rebalance((unsigned long long)OCFS2_I(dir)->ip_blkno,
+				     (unsigned long long)leaf_blkno,
+				     insert_hash);
 
 	ocfs2_init_dx_root_extent_tree(&et, INODE_CACHE(dir), dx_root_bh);
 
@@ -3885,8 +3877,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 		goto  out_commit;
 	}
 
-	mlog(0, "Split leaf (%u) at %u, insert major hash is %u\n",
-	     leaf_cpos, split_hash, insert_hash);
+	trace_ocfs2_dx_dir_rebalance_split(leaf_cpos, split_hash, insert_hash);
 
 	/*
 	 * We have to carefully order operations here. There are items
@@ -4343,8 +4334,8 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 	unsigned int blocks_wanted = 1;
 	struct buffer_head *bh = NULL;
 
-	mlog(0, "getting ready to insert namelen %d into dir %llu\n",
-	     namelen, (unsigned long long)OCFS2_I(dir)->ip_blkno);
+	trace_ocfs2_prepare_dir_for_insert(
+		(unsigned long long)OCFS2_I(dir)->ip_blkno, namelen);
 
 	if (!namelen) {
 		ret = -EINVAL;
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index f87a203..6456975 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -3110,6 +3110,203 @@ DEFINE_EVENT(ocfs2__uint_int, ocfs2_mark_dquot_dirty,
 	TP_ARGS(id, type)
 );
 /* End of trace events for fs/ocfs2/quota_global.c. */
+
+/* Trace events for fs/ocfs2/dir.c. */
+DEFINE_EVENT(ocfs2__int, ocfs2_search_dirblock,
+
+	TP_PROTO(int ret),
+
+	TP_ARGS(ret)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_validate_dir_block,
+
+	TP_PROTO(unsigned long long blkno),
+
+	TP_ARGS(blkno)
+);
+
+DEFINE_EVENT(ocfs2__pointer, ocfs2_find_entry_el,
+
+	TP_PROTO(void *ret),
+
+	TP_ARGS(ret)
+);
+
+TRACE_EVENT(ocfs2_dx_dir_search,
+
+	TP_PROTO(unsigned long long ino, int namelen, const char *name,
+		 unsigned int major_hash, unsigned int minor_hash,
+		 unsigned long long blkno),
+
+	TP_ARGS(ino, namelen, name, major_hash, minor_hash, blkno),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	ino		)
+		__field(	int,			namelen		)
+		__field(	const char *,		name		)
+		__field(	unsigned int,		major_hash	)
+		__field(	unsigned int,		minor_hash	)
+		__field(	unsigned long long,	blkno		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= 	ino;
+		__entry->namelen	= 	namelen;
+		__entry->name		= 	name;
+		__entry->major_hash	= 	major_hash;
+		__entry->minor_hash	= 	minor_hash;
+		__entry->blkno		= 	blkno;
+	),
+
+	TP_printk("%llu %.*s %u %u %llu", __entry->ino,
+		   __entry->namelen, __entry->name,
+		  __entry->major_hash, __entry->minor_hash, __entry->blkno)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint, ocfs2_dx_dir_search_leaf_info,
+
+	TP_PROTO(unsigned int num_used, unsigned int count),
+
+	TP_ARGS(num_used, count)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_delete_entry_dx,
+
+	TP_PROTO(unsigned long long dir, int index),
+
+	TP_ARGS(dir, index)
+);
+
+DEFINE_EVENT(ocfs2__ull, ocfs2_readdir,
+
+	TP_PROTO(unsigned long long dir),
+
+	TP_ARGS(dir)
+);
+
+TRACE_EVENT(ocfs2_find_files_on_disk,
+
+	TP_PROTO(int namelen, const char *name, void *blkno,
+		 unsigned long long dir),
+
+	TP_ARGS(namelen, name, blkno, dir),
+
+	TP_STRUCT__entry(
+		__field(	int,			namelen		)
+		__field(	const char *,		name		)
+		__field(	void *,			blkno		)
+		__field(	unsigned long long,	dir		)
+	),
+
+	TP_fast_assign(
+		__entry->namelen	= 	namelen;
+		__entry->name		= 	name;
+		__entry->blkno		= 	blkno;
+		__entry->dir		= 	dir;
+	),
+
+	TP_printk("%.*s %p %llu", __entry->namelen, __entry->name,
+		  __entry->blkno, __entry->dir)
+);
+
+TRACE_EVENT(ocfs2_check_dir_for_entry,
+
+	TP_PROTO(unsigned long long dir, int namelen, const char *name),
+
+	TP_ARGS(dir, namelen, name),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	dir		)
+		__field(	int,			namelen		)
+		__field(	const char *,		name		)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->namelen	= 	namelen;
+		__entry->name		= 	name;
+	),
+
+	TP_printk("%llu %.*s", __entry->dir, __entry->namelen, __entry->name)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_dx_dir_attach_index,
+
+	TP_PROTO(unsigned long long dir, unsigned long long new_blkno),
+
+	TP_ARGS(dir, new_blkno)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_dx_dir_format_cluster,
+
+	TP_PROTO(unsigned long long dir, unsigned long long new_blkno,
+		 unsigned int count),
+
+	TP_ARGS(dir, new_blkno, count)
+);
+
+TRACE_EVENT(ocfs2_dx_dir_index_root_block,
+
+	TP_PROTO(unsigned long long dir,
+		 unsigned int major_hash, unsigned int minor_hash,
+		 int namelen, const char *name, unsigned int num_used),
+
+	TP_ARGS(dir, major_hash, minor_hash, namelen, name, num_used),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long long,	dir		)
+		__field(	unsigned int,		major_hash	)
+		__field(	unsigned int,		minor_hash	)
+		__field(	int,			namelen		)
+		__field(	const char *,		name		)
+		__field(	unsigned int,		num_used	)
+	),
+
+	TP_fast_assign(
+		__entry->dir		= 	dir;
+		__entry->major_hash	= 	major_hash;
+		__entry->minor_hash	= 	minor_hash;
+		__entry->namelen	= 	namelen;
+		__entry->name		= 	name;
+		__entry->num_used	= 	num_used;
+	),
+
+	TP_printk("%llu %x %x %.*s %u", __entry->dir,
+		  __entry->major_hash, __entry->minor_hash,
+		   __entry->namelen, __entry->name, __entry->num_used)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull, ocfs2_extend_dir,
+
+	TP_PROTO(unsigned long long dir, unsigned long long i_size),
+
+	TP_ARGS(dir, i_size)
+);
+
+DEFINE_EVENT(ocfs2__ull_ull_uint, ocfs2_dx_dir_rebalance,
+
+	TP_PROTO(unsigned long long dir, unsigned long long leaf_blkno,
+		 unsigned int insert_hash),
+
+	TP_ARGS(dir, leaf_blkno, insert_hash)
+);
+
+DEFINE_EVENT(ocfs2__uint_uint_uint, ocfs2_dx_dir_rebalance_split,
+
+	TP_PROTO(unsigned int leaf_cpos, unsigned int split_hash,
+		 unsigned int insert_hash),
+
+	TP_ARGS(leaf_cpos, split_hash, insert_hash)
+);
+
+DEFINE_EVENT(ocfs2__ull_int, ocfs2_prepare_dir_for_insert,
+
+	TP_PROTO(unsigned long long dir, int namelen),
+
+	TP_ARGS(dir, namelen)
+);
+/* End of trace events for fs/ocfs2/dir.c. */
 #endif /* _TRACE_OCFS2_H */
 
 /* This part must be outside protection */
-- 
1.7.0.4
