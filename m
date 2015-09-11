From: Ryan Ding <ryan.ding@oracle.com>
Date: Fri, 11 Sep 2015 16:19:15 +0800
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: do not change i_size in write_end
	for direct io
In-Reply-To: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
Message-ID: <1441959559-29947-5-git-send-email-ryan.ding@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Append direct io do not change i_size in get block phase. It only move to
orphan when starting write. After data is written to disk, it will delete
itself from orphan and update i_size. So skip i_size change section in
write_begin for direct io.
And when there is no extents alloc, no meta data changes needed for direct io
(since write_begin start trans for 2 reason: alloc extents & change i_size. Now
none of them needed). So we can skip start trans procedure.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c |   79 ++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index eff5b59..41563aa 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2035,8 +2035,10 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 
-	wc->w_first_new_cpos =
-		ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
+	/* There is no wc if this is call from direct. */
+	if (wc)
+		wc->w_first_new_cpos =
+			ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
 
 	return ret;
 }
@@ -2127,14 +2129,17 @@ try_again:
 		}
 	}
 
-	if (ocfs2_sparse_alloc(osb))
-		ret = ocfs2_zero_tail(inode, di_bh, pos);
-	else
-		ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos, len,
-						   wc);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
+	/* Direct io change i_size late, should not zero tail here. */
+	if (type != OCFS2_WRITE_DIRECT) {
+		if (ocfs2_sparse_alloc(osb))
+			ret = ocfs2_zero_tail(inode, di_bh, pos);
+		else
+			ret = ocfs2_expand_nonsparse_inode(inode, di_bh, pos,
+							   len, wc);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 	}
 
 	ret = ocfs2_check_range_for_refcount(inode, pos, len);
@@ -2195,8 +2200,9 @@ try_again:
 
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
 						    &di->id2.i_list);
-
-	}
+	} else if (type == OCFS2_WRITE_DIRECT)
+		/* direct write needs not to start trans if no extents alloc. */
+		goto success;
 
 	/*
 	 * We have to zero sparse allocated clusters, unwritten extent clusters,
@@ -2394,12 +2400,14 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	handle_t *handle = wc->w_handle;
 	struct page *tmppage;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
-			OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		copied = ret;
-		mlog_errno(ret);
-		goto out;
+	if (handle) {
+		ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
+				wc->w_di_bh, OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			copied = ret;
+			mlog_errno(ret);
+			goto out;
+		}
 	}
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
@@ -2442,25 +2450,29 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		}
 
 		if (page_has_buffers(tmppage)) {
-			if (ocfs2_should_order_data(inode))
-				ocfs2_jbd2_file_inode(wc->w_handle, inode);
+			if (handle && ocfs2_should_order_data(inode))
+				ocfs2_jbd2_file_inode(handle, inode);
 			block_commit_write(tmppage, from, to);
 		}
 	}
 
 out_write_size:
-	pos += copied;
-	if (pos > i_size_read(inode)) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
-	}
-	inode->i_blocks = ocfs2_inode_sector_count(inode);
-	di->i_size = cpu_to_le64((u64)i_size_read(inode));
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
-	di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
-	ocfs2_update_inode_fsync_trans(handle, inode, 1);
-	ocfs2_journal_dirty(handle, wc->w_di_bh);
+	/* Direct io do not update i_size here. */
+	if (wc->w_type != OCFS2_WRITE_DIRECT) {
+		pos += copied;
+		if (pos > i_size_read(inode)) {
+			i_size_write(inode, pos);
+			mark_inode_dirty(inode);
+		}
+		inode->i_blocks = ocfs2_inode_sector_count(inode);
+		di->i_size = cpu_to_le64((u64)i_size_read(inode));
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
+		di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
+		ocfs2_update_inode_fsync_trans(handle, inode, 1);
+	}
+	if (handle)
+		ocfs2_journal_dirty(handle, wc->w_di_bh);
 
 out:
 	/* unlock pages before dealloc since it needs acquiring j_trans_barrier
@@ -2470,7 +2482,8 @@ out:
 	 */
 	ocfs2_unlock_pages(wc);
 
-	ocfs2_commit_trans(osb, handle);
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
 
-- 
1.7.1
