From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 13 Sep 2010 14:09:53 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use cpu_to_le16 for e_leaf_clusters in
	ocfs2_bg_discontig_add_extent.
Message-ID: <1284358193-3222-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

e_leaf_clusters is a le16, so use cpu_to_le16 instead
of cpu_to_le32.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a8e6a95..039f69b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -348,7 +348,7 @@ static void ocfs2_bg_discontig_add_extent(struct ocfs2_super *osb,
 	rec->e_blkno = cpu_to_le64(p_blkno);
 	rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
 				  le16_to_cpu(cl->cl_bpc));
-	rec->e_leaf_clusters = cpu_to_le32(clusters);
+	rec->e_leaf_clusters = cpu_to_le16(clusters);
 	le16_add_cpu(&bg->bg_bits, clusters * le16_to_cpu(cl->cl_bpc));
 	le16_add_cpu(&bg->bg_free_bits_count,
 		     clusters * le16_to_cpu(cl->cl_bpc));
-- 
1.7.1.GIT
