From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 4 Sep 2009 10:48:38 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlog_errno to aops.c -V2
Message-ID: <200909080621.n886L8pH028023@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  when an error is hit, printing the error number is helpful.
this patch adds prints in such cases in aops.c.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 aops.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b2c52b3..97ea4f6 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -349,8 +349,11 @@ static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
 	 * lock inversion, but don't bother with retrying.
 	 */
 	ret = ocfs2_inode_lock_full(inode, NULL, 0, OCFS2_LOCK_NONBLOCK);
-	if (ret)
+	if (ret) {
+		if (ret != -EAGAIN && ret != -EIOCBRETRY && ret != -ENOENT)
+			mlog_errno(ret);
 		return err;
+	}
 
 	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
 		ocfs2_inode_unlock(inode, 0);
@@ -842,8 +845,10 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
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
@@ -1527,6 +1532,7 @@ static int ocfs2_write_begin_inline(struct address_space *mapping,
 	if (!PageUptodate(page)) {
 		ret = ocfs2_read_inline_data(inode, page, wc->w_di_bh);
 		if (ret) {
+			mlog_errno(ret);
 			ocfs2_commit_trans(osb, handle);
 
 			goto out;

1.6.2.5
