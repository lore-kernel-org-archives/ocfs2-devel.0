From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:14 2008
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2: Correct use of ! and & in aops.c
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 86c838b03daf35e2af6555842d04fe09a89f8d93
Author: Julia Lawall <julia@diku.dk>
Date: Tue, 26 Feb 2008 21:45:56 +0100

In mainline commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7db3a5d..c06b7b1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -257,7 +257,7 @@ static int ocfs2_readpage_inline(struct inode *inode, struct page *page)
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	BUG_ON(!PageLocked(page));
-	BUG_ON(!OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
+	BUG_ON(!(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL));
 
 	ret = ocfs2_read_block(osb, OCFS2_I(inode)->ip_blkno, &di_bh,
 			       OCFS2_BH_CACHED, inode);
-- 
1.5.3.4
