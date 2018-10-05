From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:45:48 -0700
Subject: [Ocfs2-devel] [PATCH 10/15] vfs: make cloning to source file eof
	more explicit
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
Message-ID: <153870034823.29072.4817036324117498634.stgit@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the new CLONE_RANGE_EOF flag to explicitly declare that the caller
wants the clone implementation to set *len appropriately once the files
are locked.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 7cfff497263b..4eaea52f70a8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1747,11 +1747,12 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
 
 	isize = i_size_read(inode_in);
 
-	/* Zero length dedupe exits immediately; reflink goes to EOF. */
-	if (*len == 0) {
-		if (is_dedupe || pos_in == isize)
-			return 0;
-		if (pos_in > isize)
+	/*
+	 * If the caller asked to go all the way to the end of the source file,
+	 * set *len now that we have the file locked.
+	 */
+	if ((flags & CLONERANGE_EOF) && *len == 0) {
+		if (pos_in >= isize)
 			return -EINVAL;
 		*len = isize - pos_in;
 	}
@@ -1836,6 +1837,9 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
+	if (len == 0)
+		flags |= CLONERANGE_EOF;
+
 	cloned = file_in->f_op->clone_file_range(file_in, pos_in,
 			file_out, pos_out, len, flags);
 	if (cloned < 0)
