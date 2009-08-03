From: Jan Kara <jack@suse.cz>
Date: Mon,  3 Aug 2009 18:24:21 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Handle quota file corruption more
	gracefully
Message-ID: <1249316661-28657-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_read_virt_blocks() does BUG when we try to read a block from a file
beyond its end. Since this can happen due to filesystem corruption, it
is not really an appropriate answer. Make ocfs2_read_quota_block() check
the condition and handle it by calling ocfs2_error() and returning EIO.

Reported-by: Tristan Ye <tristan.ye@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Joel, could you please merge this fix? Thanks.

 fs/ocfs2/quota_global.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index d604a6a..8988d8b 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -23,6 +23,7 @@
 #include "sysfile.h"
 #include "dlmglue.h"
 #include "uptodate.h"
+#include "super.h"
 #include "quota.h"
 
 static struct workqueue_struct *ocfs2_quota_wq = NULL;
@@ -114,6 +115,14 @@ int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 	int rc = 0;
 	struct buffer_head *tmp = *bh;
 
+	if (i_size_read(inode) >> inode->i_sb->s_blocksize_bits <= v_block) {
+		ocfs2_error(inode->i_sb,
+			    "Quota file %lu is probably corrupted! Requested "
+			    "to read block %Lu but file has size only %Lu\n",
+			    inode->i_ino, (unsigned long long)v_block,
+			    (unsigned long long)i_size_read(inode));
+		return -EIO;
+	}
 	rc = ocfs2_read_virt_blocks(inode, v_block, 1, &tmp, 0,
 				    ocfs2_validate_quota_block);
 	if (rc)
-- 
1.6.0.2
