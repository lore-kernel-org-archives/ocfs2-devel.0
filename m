From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 4 Sep 2009 10:48:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlog_errno to aops.c
Message-ID: <200909040249.n842n0W7027642@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  when an error is hit, printing the error number is helpful.
this patch adds prints in such cases in aops.c.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b2c52b3..04e0760 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -349,8 +349,10 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
 	 * lock inversion, but don't bother with retrying.
 	 */
 	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
-	if (ret)
+	if (ret) {
+		mlog_errno(ret);
 		return err;
+	}
 
 	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
 		ocfs2_inode_unlock(inode, 0);
@@ -842,8 +844,10 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 	 */
 	while(wait_bh > wait) {
 		wait_on_buffer(*--wait_bh);
-		if (!buffer_uptodate(*wait_bh))
+		if (!buffer_uptodate(*wait_bh)) {
 			ret = -EIO;
+			mlog_errno(ret);
+		}
 	}
 
 	if (ret == 0 || !new)
@@ -1527,6 +1531,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	if (!PageUptodate(page)) {
 		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
 		if (ret) {
+			mlog_errno(ret);
 			ocfs2_commit_trans(osb, handle);
 
 			goto out;
-- 
1.6.2.5
