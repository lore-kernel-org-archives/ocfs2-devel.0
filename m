From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 13 Sep 2010 15:13:50 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Use cpu_to_le16 for e_leaf_clusters
	in ocfs2_bg_discontig_add_extent.
In-Reply-To: <20100913062907.GA16449@mail.oracle.com>
References: <20100913062907.GA16449@mail.oracle.com>
Message-ID: <1284362030-3398-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

e_leaf_clusters is a le16, so use cpu_to_le16 instead
of cpu_to_le32.

What's more, we change 'clusters' to unsigned int to
signify that the size of 'clusters' isn't important here.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a8e6a95..6bad4d0 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -336,7 +336,7 @@ out:
 static void ocfs2_bg_discontig_add_extent(struct ocfs2_super *osb,
 					  struct ocfs2_group_desc *bg,
 					  struct ocfs2_chain_list *cl,
-					  u64 p_blkno, u32 clusters)
+					  u64 p_blkno, unsigned int clusters)
 {
 	struct ocfs2_extent_list *el = &bg->bg_list;
 	struct ocfs2_extent_rec *rec;
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
