From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 04 Feb 2015 16:00:52 -0800
Subject: [Ocfs2-devel] [patch 3/4] ocfs2: call ocfs2_journal_access_di()
 before ocfs2_journal_dirty() in ocfs2_write_end_nolock()
Message-ID: <54d2b2b4.GzWVdwR/oLikcZTO%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: yangwenfang <vicky.yangwenfang@huawei.com>
Subject: ocfs2: call ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()

After we call ocfs2_journal_access_di() in ocfs2_write_begin(),
jbd2_journal_restart() may also be called, in this function transaction
A's t_updates-- and obtains a new transaction B.  If
jbd2_journal_commit_transaction() is happened to commit transaction A,
when t_updates==0, it will continue to complete commit and unfile buffer.

So when jbd2_journal_dirty_metadata(), the handle is pointed a new
transaction B, and the buffer head's journal head is already freed,
jh->b_transaction == NULL, jh->b_next_transaction == NULL, it returns
EINVAL, So it triggers the BUG_ON(status).

thread 1:                             jbd2:
ocfs2_write_begin                     jbd2_journal_commit_transaction
ocfs2_write_begin_nolock
  ocfs2_start_trans
    jbd2__journal_start(t_updates+1,
                       transaction A)
    ocfs2_journal_access_di
    ocfs2_write_cluster_by_desc
      ocfs2_mark_extent_written
        ocfs2_change_extent_flag
          ocfs2_split_extent
            ocfs2_extend_rotate_transaction
              jbd2_journal_restart
              (t_updates-1,transaction B) t_updates==0
                                        __jbd2_journal_refile_buffer

ocfs2_write_end
ocfs2_write_end_nolock
    ocfs2_journal_dirty
        jbd2_journal_dirty_metadata(bug)
   ocfs2_commit_trans

In ext4, I found that: jbd2_journal_get_write_access() called by

ext4_write_end.
ext4_write_begin
    ext4_journal_start
        __ext4_journal_start_sb
            ext4_journal_check_start
            jbd2__journal_start

ext4_write_end
    ext4_mark_inode_dirty
        ext4_reserve_inode_write
            ext4_journal_get_write_access
                jbd2_journal_get_write_access
        ext4_mark_iloc_dirty
            ext4_do_update_inode
                ext4_handle_dirty_metadata
                    jbd2_journal_dirty_metadata


So I think we should put ocfs2_journal_access_di before
  ocfs2_journal_dirty in the ocfs2_write_end.  and it works well after my
  modification.

Signed-off-by: vicky <vicky.yangwenfang@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-call-ocfs2_journal_access_di-before-ocfs2_journal_dirty-in-ocfs2_write_end_nolock
+++ a/fs/ocfs2/aops.c
@@ -1822,16 +1822,6 @@ try_again:
 		if (ret)
 			goto out_commit;
 	}
-	/*
-	 * We don't want this to fail in ocfs2_write_end(), so do it
-	 * here.
-	 */
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_quota;
-	}
 
 	/*
 	 * Fill our page array first. That way we've grabbed enough so
@@ -1982,7 +1972,7 @@ int ocfs2_write_end_nolock(struct addres
 			   loff_t pos, unsigned len, unsigned copied,
 			   struct page *page, void *fsdata)
 {
-	int i;
+	int i, ret;
 	unsigned from, to, start = pos & (PAGE_CACHE_SIZE - 1);
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2032,6 +2022,14 @@ int ocfs2_write_end_nolock(struct addres
 		}
 	}
 
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret) {
+		copied = ret;
+		mlog_errno(ret);
+		goto out;
+	}
+
 out_write_size:
 	pos += copied;
 	if (pos > i_size_read(inode)) {
@@ -2053,6 +2051,7 @@ out_write_size:
 	 */
 	ocfs2_unlock_pages(wc);
 
+out:
 	ocfs2_commit_trans(osb, handle);
 
 	ocfs2_run_deallocs(osb, &wc->w_dealloc);
_
