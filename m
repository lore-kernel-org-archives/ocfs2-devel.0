From: Tao Ma <tao.ma@oracle.com>
Date: Fri Nov 16 00:52:44 2007
Subject: [Ocfs2-devel] [PATCH 5/6] Modify fsck to trust global bitmap than
	super block,take 1
In-Reply-To: <20071116083920.GA3879@tma-pc1.cn.oracle.com>
Message-ID: <20071116084744.GA3951@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In resize, we update the global_bitmap first and then the super block.
So if there is any corruption between these 2 steps, there will be a
inconsistence. In kernel we use the information in global_bitmap,
so fsck.ocfs2 should also trust it during the check.

Signed-off-by: Tao Ma <tao.ma@oracle.com>

---

 fsck.ocfs2/pass0.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

aa2bfd78e72a1a60302a06775b09f9c014cd487f
diff --git a/fsck.ocfs2/pass0.c b/fsck.ocfs2/pass0.c
index 1e4c243..c88ab31 100644
--- a/fsck.ocfs2/pass0.c
+++ b/fsck.ocfs2/pass0.c
@@ -1075,19 +1075,30 @@ errcode_t o2fsck_pass0(o2fsck_state *ost
 	if (ret)
 		goto out;
 
+	/*
+	 * during resize, we may update the global bitmap but fails to
+	 * to update i_clusters in superblock, so ask the user which one
+	 * to use before checking.
+	 */
+	if (fs->fs_super->i_clusters != di->i_clusters) {
+		if (prompt(ost, PY, PR_SUPERBLOCK_CLUSTERS,
+			   "Superblock has clusters set to %u instead of %u "
+			   "recorded in global_bitmap, it may be caused by an "
+			   "unsuccessful resize. Trust global_bitmap?",
+			   fs->fs_super->i_clusters, di->i_clusters)) {
+			ost->ost_num_clusters = di->i_clusters;
+			fs->fs_clusters = di->i_clusters;
+			fs->fs_blocks = ocfs2_clusters_to_blocks(fs,
+							 fs->fs_clusters);
+		}
+	}
+
 	ret = verify_bitmap_descs(ost, di, blocks + ost->ost_fs->fs_blocksize,
 				  blocks + (ost->ost_fs->fs_blocksize * 2));
 
 	if (ret)
 		goto out;
 
-	if (fs->fs_super->i_clusters != di->i_clusters) {
-		if (prompt(ost, PY, PR_SUPERBLOCK_CLUSTERS,
-			   "Superblock has clusters set to %u instead of %u. Fix?",
-			   fs->fs_super->i_clusters, di->i_clusters))
-			ost->ost_num_clusters = di->i_clusters;
-	}
-
 	printf("Pass 0b: Checking inode allocation chains\n");
 
 	/* first the global inode alloc and then each of the node's
-- 
1.3.3
