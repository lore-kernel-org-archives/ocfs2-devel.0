From: sunil.mushran at gmail.com <sunil.mushran@gmail.com>
Date: Fri,  3 Aug 2012 17:36:17 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix oops in
	ocfs2_fast_symlink_readpage() code path
Message-ID: <1344011777-26527-1-git-send-email-sunil.mushran@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Sunil Mushran <smushran@yahoo.com>

Commit ea022dfb3c2a4680483b00eb2fecc9fc4f6091d1 was missing a var init.

Reported-and-Tested-by: Vincent Etienne <vetienne@aprogsys.com>
Signed-off-by: Sunil Mushran <sunil.mushran@gmail.com>
---
 fs/ocfs2/symlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index f1fbb4b..66edce7 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -57,7 +57,7 @@
 static int ocfs2_fast_symlink_readpage(struct file *unused, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct buffer_head *bh;
+	struct buffer_head *bh = NULL;
 	int status = ocfs2_read_inode_block(inode, &bh);
 	struct ocfs2_dinode *fe;
 	const char *link;
-- 
1.7.4.4
