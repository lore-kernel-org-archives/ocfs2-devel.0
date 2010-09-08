From: Tristan Ye <tristan.ye@oracle.com>
Date: Wed,  8 Sep 2010 17:12:38 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Re-access the journal after
	ocfs2_insert_extent() in dxdir codes.
Message-ID: <1283937158-4763-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_dx_dir_rebalance(), we need to rejournal_acess the blocks after
calling ocfs2_insert_extent() since growing an extent tree may trigger
ocfs2_extend_trans(), which makes previous journal_access meaningless.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/dir.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index f04ebcf..c49f6de 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3931,6 +3931,15 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 		goto out_commit;
 	}
 
+	cpos = split_hash;
+	ret = ocfs2_dx_dir_new_cluster(dir, &et, cpos, handle,
+				       data_ac, meta_ac, new_dx_leaves,
+				       num_dx_leaves);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
 	for (i = 0; i < num_dx_leaves; i++) {
 		ret = ocfs2_journal_access_dl(handle, INODE_CACHE(dir),
 					      orig_dx_leaves[i],
@@ -3939,15 +3948,14 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
 			mlog_errno(ret);
 			goto out_commit;
 		}
-	}
 
-	cpos = split_hash;
-	ret = ocfs2_dx_dir_new_cluster(dir, &et, cpos, handle,
-				       data_ac, meta_ac, new_dx_leaves,
-				       num_dx_leaves);
-	if (ret) {
-		mlog_errno(ret);
-		goto out_commit;
+		ret = ocfs2_journal_access_dl(handle, INODE_CACHE(dir),
+					      new_dx_leaves[i],
+					      OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out_commit;
+		}
 	}
 
 	ocfs2_dx_dir_transfer_leaf(dir, split_hash, handle, tmp_dx_leaf,
-- 
1.5.5
