From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun Jan  6 13:44:24 2008
Subject: [Ocfs2-devel] [PATCH 0/2] Unwritten extent merge update,V1
In-Reply-To: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
Message-ID: <20080106214249.GS23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 04, 2008 at 04:32:14PM +0800, tao.ma wrote:
> The old extent merging code down underneath "ocfs2_mark_extent_written()"
> can't merge extents between leaf blocks. This patch resolve this.
> So that a large unwritten extent which has been split up with a bunch of
> writes can be merged together once all unwritten regions have been written to.

So, just to get things started I'll attach a patch which I think you might
find useful. It adds a function 'ocfs2_check_tree()' which you can call
after marking an extent unwritten. It'll walk the entire btree and look for
certain inconsistencies. If one is found, the journal is synced and then the
box is paniced. The syncing gives us the chance to inspect the btree after
rebooting the box.

Last time I was hacking on the tree code, I modified
ocfs2-test/programs/fill_verify_holes/old_burn-in.sh to call
fill_verify_holes with '-u' (for unwritten extents) and ran the script
against a 512 blocksize/4k clustersize file system. The kernel I was running
had the tree check patch applied. This setup helped me catch the vast
majority of bugs which I had introduced by my changes. These days, I'd also
disable the extent map cache (which wasn't around then) as it would also
hide some problems.


By the way - the page cache can also hide problems by allowing the "verify"
program to read cached data which it wouldn't actually be able to find if
the btree was actually searched. I think we can might be able to minimize
this by inserting:

echo 1 > /proc/sys/vm/drop_caches

right before the verify step in old_burn-in.sh.


Ultimately of course, you can do whatever you want for testing, but I'd
definitely like to get a detailed description of what you did or what you're
planning to do in that area. I'm paranoid about btree changes, even though
I'm really happy that you took this task on ;)
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com


diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index cf30761..0bebced 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -49,6 +49,8 @@ #include "uptodate.h"
 
 #include "buffer_head_io.h"
 
+static void ocfs2_check_tree(struct inode *inode);
+
 static void ocfs2_free_truncate_context(struct ocfs2_truncate_context *tc);
 static int ocfs2_cache_extent_block_free(struct ocfs2_cached_dealloc_ctxt *ctxt,
 					 struct ocfs2_extent_block *eb);
@@ -3782,6 +3784,9 @@ int ocfs2_insert_extent(struct ocfs2_sup
 	else
 		ocfs2_extent_map_insert_rec(inode, &rec);
 
+	if (status == 0)
+		ocfs2_check_tree(inode);
+
 bail:
 	if (bh)
 		brelse(bh);
@@ -4134,6 +4139,9 @@ int ocfs2_mark_extent_written(struct ino
 	if (ret)
 		mlog_errno(ret);
 
+	if (ret == 0)
+		ocfs2_check_tree(inode);
+
 out:
 	ocfs2_free_path(left_path);
 	return ret;
@@ -4501,6 +4509,9 @@ int ocfs2_remove_extent(struct inode *in
 		}
 	}
 
+	if (ret == 0)
+		ocfs2_check_tree(inode);
+
 out:
 	ocfs2_free_path(path);
 	return ret;
@@ -6122,3 +6133,177 @@ static void ocfs2_free_truncate_context(
 
 	kfree(tc);
 }
+
+#define INDEX_DEPTH (OCFS2_MAX_PATH_DEPTH - 1)
+
+static void ocfs2_path_error(void)
+{
+	handle_t *handle = journal_current_handle();
+
+	handle->h_sync = 1;
+	journal_stop(handle);
+
+	BUG();
+}
+
+static void ocfs2_check_path(struct inode *inode,
+			     struct ocfs2_path *path,
+			     int *check_index)
+{
+	int i, next_free, node;
+	u32 parent_range, child_range;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_rec *rec;
+	struct ocfs2_extent_rec *rec1;
+	struct ocfs2_extent_rec *parent_rec;
+
+	for(node = 0; node < path_num_items(path); node++) {
+		el = path->p_node[node].el;
+
+		next_free = le16_to_cpu(el->l_next_free_rec);
+
+		/* Check for duplicate records */
+		/* Check for records in order */
+		for(i = 0; i < (next_free - 1); i++) {
+			rec = &el->l_recs[i];
+			rec1 = &el->l_recs[i+1];
+
+			if (!ocfs2_is_empty_extent(rec) &&
+			    le32_to_cpu(rec1->e_cpos) <=
+			    le32_to_cpu(rec->e_cpos))
+				goto bad_records;
+		}
+	}
+
+	/* Check ranges of records */
+	el = path_root_el(path);
+	parent_rec = &el->l_recs[check_index[0]];
+	i = 1;
+	while (i <= path->p_tree_depth) {
+		struct ocfs2_extent_rec *child_rec;
+
+		el = path->p_node[i].el;
+
+		parent_range = le32_to_cpu(parent_rec->e_cpos) +
+			le32_to_cpu(parent_rec->e_int_clusters);
+		child_range = ocfs2_sum_rightmost_rec(el);
+		if (child_range > parent_range)
+			goto bad_range;
+
+		child_rec = &el->l_recs[0];
+
+		/*
+		 * The leftmost branch is allowed to have a starting
+		 * cpos of zero but children who actually start after
+		 * that.
+		 */
+		if (parent_rec->e_cpos &&
+		    (le32_to_cpu(parent_rec->e_cpos) <
+		     le32_to_cpu(child_rec->e_cpos)))
+			goto bad_range;
+
+		parent_rec = &el->l_recs[check_index[i]];
+
+		i++;
+	}
+
+	return;
+
+bad_records:
+	mlog(ML_ERROR, "Inode %lu: Bad Records\n",
+	     (unsigned long)inode->i_ino);
+	ocfs2_path_error();
+	return;
+
+bad_range:
+	mlog(ML_ERROR, "Inode %lu: Bad Range\n",
+	     (unsigned long)inode->i_ino);
+	mlog(ML_ERROR, "Child block: %llu, Parent rec: (%u, %u, %llu)\n",
+	     (unsigned long long)path->p_node[i].bh->b_blocknr,
+	     le32_to_cpu(parent_rec->e_cpos),
+	     le32_to_cpu(parent_rec->e_int_clusters),
+	     (unsigned long long)le64_to_cpu(parent_rec->e_blkno));
+	ocfs2_path_error();
+}
+
+static void ocfs2_check_tree(struct inode *inode)
+{
+	int ret, i;
+	int check_index[INDEX_DEPTH] = {0, };
+	u64 blkno;
+	struct ocfs2_dinode *di;
+	struct buffer_head *di_bh = NULL;
+	struct buffer_head *bh;
+	struct buffer_head *first_tail_bh = NULL;
+	struct ocfs2_path *path = NULL;
+	struct ocfs2_extent_block *eb;
+	struct ocfs2_extent_list *el;
+
+	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), OCFS2_I(inode)->ip_blkno,
+			       &di_bh, OCFS2_BH_CACHED, inode);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	path = ocfs2_new_inode_path(di_bh);
+	if (!path) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+restart:
+	i = 0;
+	while (i < path->p_tree_depth) {
+		el = path->p_node[i].el;
+
+		BUG_ON(check_index[i] >= le16_to_cpu(el->l_next_free_rec));
+
+		blkno = le64_to_cpu(el->l_recs[check_index[i]].e_blkno);
+		bh = NULL;
+		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
+				       &bh, OCFS2_BH_CACHED, inode);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ocfs2_path_insert_eb(path, i + 1, bh);
+
+		eb = (struct ocfs2_extent_block *) bh->b_data;
+		if (!OCFS2_IS_VALID_EXTENT_BLOCK(eb))
+			BUG();
+
+		i++;
+	}
+
+	ocfs2_check_path(inode, path, check_index);
+
+	if (le64_to_cpu(di->i_last_eb_blk) != path_leaf_bh(path)->b_blocknr
+	    && path->p_tree_depth) {
+		int max;
+
+		for(i = (path->p_tree_depth - 1); i >= 0; i--) {
+			el = path->p_node[i].el;
+
+			max = le16_to_cpu(el->l_next_free_rec);
+
+			check_index[i]++;
+			if (check_index[i] >= max)
+				check_index[i] = 0;
+			else
+				break;
+		}
+
+		ocfs2_reinit_path(path, 1);
+		goto restart;
+	}
+
+out:
+	ocfs2_free_path(path);
+	brelse(di_bh);
+	brelse(first_tail_bh);
+}
