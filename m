From: Dan Carpenter <error27@gmail.com>
Date: Sun, 29 May 2011 22:56:31 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: checking the wrong variable in
	ocfs2_move_extent()
Message-ID: <20110529195631.GC3099@shale.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

"new_phys_cpos" is always a valid pointer here.
ocfs2_probe_alloc_group() allocates "*new_phys_cpos".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 4c54884..f3eb060 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -747,7 +747,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	 */
 	ocfs2_probe_alloc_group(inode, gd_bh, &goal_bit, len, move_max_hop,
 				new_phys_cpos);
-	if (!new_phys_cpos) {
+	if (!*new_phys_cpos) {
 		ret = -ENOSPC;
 		goto out_commit;
 	}
