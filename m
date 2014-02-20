From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Feb 2014 15:19:22 +0100
Subject: [Ocfs2-devel] [PATCH] fsck.ocfs2: Do not complain about oversized
	quota files
Message-ID: <1392905962-2469-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Quota files can have blocks beyond i_size. This is correct because quota
code reserves these blocks to allow for extension of quota files without
the need for allocation. So make fsck.ocfs2 not complain about them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fsck.ocfs2/pass1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fsck.ocfs2/pass1.c b/fsck.ocfs2/pass1.c
index 22dafdf50647..5118e6c630c4 100644
--- a/fsck.ocfs2/pass1.c
+++ b/fsck.ocfs2/pass1.c
@@ -832,6 +832,12 @@ out:
 	return ret;
 }
 
+static int is_quota_file(uint64_t ino)
+{
+	return ino == USER_QUOTA_SYSTEM_INODE ||
+	       ino == GROUP_QUOTA_SYSTEM_INODE;
+}
+
 /*
  * this verifies i_size and i_clusters for inodes that use i_list to
  * reference extents of data.
@@ -1002,6 +1008,7 @@ size_cluster_check:
 			 *	 i_clusters, even on a sparsed filesystem
 			 */
 			if (!S_ISLNK(di->i_mode) && !S_ISDIR(di->i_mode) &&
+			    !is_quota_file(di->i_blkno) &&
 			    di->i_size <= unexpected &&
 			    prompt(ost, PY, PR_INODE_SPARSE_SIZE, "Inode %"PRIu64
 				   " has a size of %"PRIu64" but has %"PRIu64
-- 
1.8.1.4
