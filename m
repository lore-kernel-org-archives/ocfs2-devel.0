From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Aug 2010 16:24:26 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix incorrect checksum validation
	error
In-Reply-To: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
References: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1281655466-26341-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For local mounts, ocfs2_read_locked_inode() calls ocfs2_read_blocks_sync() to
read the inode off the disk. The latter first checks to see if that block is
cached in the journal, and, if so, returns that block. That is ok.

But ocfs2_read_locked_inode() goes wrong when it tries to validate the checksum
of such blocks. Blocks that are cached in the journal may not have had their
checksum computed as yet. We should not validate the checksums of such blocks.

Fixes ossbz#1282
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1282

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index abb0a95..c9fcce3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -488,7 +488,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 						     OCFS2_BH_IGNORE_CACHE);
 	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
-		if (!status)
+		/*
+		 * If buffer is in jbd, then its checksum may not have been
+		 * computed as yet.
+		 */
+		if (!status && (!buffer_jbd(bh)))
 			status = ocfs2_validate_inode_block(osb->sb, bh);
 	}
 	if (status < 0) {
-- 
1.7.0.4
