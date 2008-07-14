From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 14 Jul 2008 15:01:50 -0700
Subject: [Ocfs2-devel] [PATCH 17/17] [PATCH] ocfs2: fix oops in
	mmap_truncate testing
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Message-ID: <1216072910-27226-18-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Coly Li <coyli@suse.de>

From: Coly Li <coyli@suse.de>

This patch fixes a mmap_truncate bug which was found by ocfs2 test suite.

In an ocfs2 cluster more than 1 node, run program mmap_truncate, which races
mmap writes and truncates from multiple processes. While the test is
running, a stat from another node forces writeout, causing an oops in
ocfs2_get_block() because it sees a buffer to write which isn't allocated.

This patch fixed the bug by clear dirty and uptodate bits in buffer, leave
the buffer unmapped and return.

Fix is suggested by Mark Fasheh, and I code up the patch.

Signed-off-by: Coly Li <coyli@suse.de>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/aops.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17964c0..b74a702 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -179,6 +179,23 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			"ino %lu, iblock %llu\n", inode->i_ino,
 			(unsigned long long)iblock);
 
+	/*
+	 * ocfs2 never allocates in this function - the only time we
+	 * need to use BH_New is when we're extending i_size on a file
+	 * system which doesn't support holes, in which case BH_New
+	 * allows block_prepare_write() to zero.
+	 *
+	 * If we see this on a sparse file system, then a truncate has
+	 * raced us and removed the cluster. In this case, we clear
+	 * the buffers dirty and uptodate bits and let the buffer code
+	 * ignore it as a hole.
+	 */
+	if (create && p_blkno == 0 && ocfs2_sparse_alloc(osb)) {
+		clear_buffer_dirty(bh_result);
+		clear_buffer_uptodate(bh_result);
+		goto bail;
+	}
+
 	/* Treat the unwritten extent as a hole for zeroing purposes. */
 	if (p_blkno && !(ext_flags & OCFS2_EXT_UNWRITTEN))
 		map_bh(bh_result, inode->i_sb, p_blkno);
-- 
1.5.4.1
