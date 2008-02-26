From: Julia Lawall <julia@diku.dk>
Date: Tue, 26 Feb 2008 20:47:10 -0000
Subject: [Ocfs2-devel] [PATCH 8/9] fs/ocfs2/aops.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262145321.18200@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c 2008-02-05 20:56:02.000000000 +0100
+++ b/fs/ocfs2/aops.c 2008-02-26 08:16:47.000000000 +0100
@@ -257,7 +257,7 @@ static int ocfs2_readpage_inline(struct 
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(!OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
 			       OCFS2_BH_CACHED, inode);
