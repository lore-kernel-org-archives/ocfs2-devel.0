From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Thu, 11 Jun 2015 03:05:04 +0000
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 135, Issue 28
References: <mailman.3.1433012401.8601.ocfs2-devel@oss.oracle.com>
Message-ID: <2015061111050257458715@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I think the patch has a potential risk. as follows

Callback? ocfs2_write_end_nolock->ocfs2_journal_access_di->__ocfs2_journal_access->buffer_uptodate

So it increases the probability triggering BUG in the  __ocfs2_journal_access().

In addition, test results have been confirmed.

Finally, any feedback about this process (positive or negative) would be  greatly appreciated.


From: ocfs2-devel-bounces@oss.oracle.com<mailto:ocfs2-devel-bounces@oss.oracle.com>
Date: 2015-05-31 03:00
To: ocfs2-devel at oss.oracle.com<mailto:ocfs2-devel@oss.oracle.com>
Subject: Ocfs2-devel Digest, Vol 135, Issue 28

Send Ocfs2-devel mailing list submissions to
        ocfs2-devel at oss.oracle.com

To subscribe or unsubscribe via the World Wide Web, visit
        https://oss.oracle.com/mailman/listinfo/ocfs2-devel
or, via email, send a message with subject or body 'help' to
        ocfs2-devel-request at oss.oracle.com

You can reach the person managing the list at
        ocfs2-devel-owner at oss.oracle.com

When replying, please edit your Subject line so it is more specific
than "Re: Contents of Ocfs2-devel digest..."


Today's Topics:

   1. [PATCH V2] ocfs2: call ocfs2_journal_access_di() before
      ocfs2_journal_dirty() in ocfs2_write_end_nolock() (yangwenfang)


----------------------------------------------------------------------

Message: 1
Date: Sat, 30 May 2015 18:08:43 +0800
From: yangwenfang <vicky.yangwenfang@huawei.com>
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: call
        ocfs2_journal_access_di() before ocfs2_journal_dirty() in
        ocfs2_write_end_nolock()
To: Andrew Morton <akpm@linux-foundation.org>, <mfasheh@suse.com>
Cc: ocfs2-devel at oss.oracle.com
Message-ID: <55698C2B.9000801@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"

1.After we call ocfs2_journal_access_di() in ocfs2_write_begin(),
jbd2_journal_restart() may also be called, in this function
transaction A's t_updates-- and obtains a new transaction B.
If jbd2_journal_commit_transaction() is happened to commit
transaction A, when t_updates==0, it will continue to complete
commit and unfile buffer.

So when jbd2_journal_dirty_metadata(), the handle is pointed a new
transaction B, and the buffer head's journal head is already freed,
jh->b_transaction == NULL, jh->b_next_transaction == NULL,
it returns EINVAL, So it triggers the BUG_ON(status).

thread 1                                          jbd2
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
                                        (jh->b_transaction = NULL)
ocfs2_write_end
ocfs2_write_end_nolock
    ocfs2_journal_dirty
        jbd2_journal_dirty_metadata(bug)
   ocfs2_commit_trans

2. In ext4, I found that: jbd2_journal_get_write_access() called by
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

3.So I think we should put ocfs2_journal_access_di before
ocfs2_journal_dirty in the ocfs2_write_end.
and it works well after my modification.

Signed-off-by: vicky <vicky.yangwenfang@huawei.com>
---
 fs/ocfs2/aops.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f906a25..f3d7e52 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2176,10 +2176,7 @@ try_again:
                if (ret)
                        goto out_commit;
        }
-       /*
-        * We don't want this to fail in ocfs2_write_end(), so do it
-        * here.
-        */
+
        ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
                                      OCFS2_JOURNAL_ACCESS_WRITE);
        if (ret) {
@@ -2336,7 +2333,7 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
                           loff_t pos, unsigned len, unsigned copied,
                           struct page *page, void *fsdata)
 {
-       int i;
+       int i, ret;
        unsigned from, to, start = pos & (PAGE_CACHE_SIZE - 1);
        struct inode *inode = mapping->host;
        struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -2345,6 +2342,14 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
        handle_t *handle = wc->w_handle;
        struct page *tmppage;

+       ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), wc->w_di_bh,
+                       OCFS2_JOURNAL_ACCESS_WRITE);
+       if (ret) {
+               copied = ret;
+               mlog_errno(ret);
+               goto out;
+       }
+
        if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
                ocfs2_write_end_inline(inode, pos, len, &copied, di, wc);
                goto out_write_size;
@@ -2400,6 +2405,7 @@ out_write_size:
        ocfs2_update_inode_fsync_trans(handle, inode, 1);
        ocfs2_journal_dirty(handle, wc->w_di_bh);

+out:
        /* unlock pages before dealloc since it needs acquiring j_trans_barrier
         * lock, or it will cause a deadlock since journal commit threads holds
         * this lock and will ask for the page lock when flushing the data.
--
1.7.12.4




------------------------------

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel

End of Ocfs2-devel Digest, Vol 135, Issue 28
********************************************

-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150611/2334c0f2/attachment-0001.html 
