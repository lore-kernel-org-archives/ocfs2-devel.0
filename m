From: tao.ma@oracle.com <tao.ma@oracle.com>
Date: Wed Sep  5 17:12:31 2007
Subject: [Ocfs2-devel] [patch] Fix a wrong cluster calculation.
References: <20070905235808.031850823@oracle.com>
Message-ID: <20070906000225.GA4698@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_alloc_write_write_ctxt, the written clusters length is calculated
by the byte length only. This may cause some problems if we start to write
at some position in the end of one cluster and last to a second cluster
while the "len" is smaller than a cluster size. In that case, we have to
write 2 clusters actually.
So we have to take the start position into consideration also.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 460d440..50cd8a2 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -855,6 +855,7 @@ static int ocfs2_alloc_write_ctxt(struct
 				  struct ocfs2_super *osb, loff_t pos,
 				  unsigned len, struct buffer_head *di_bh)
 {
+	u32 cend;
 	struct ocfs2_write_ctxt *wc;
 
 	wc = kzalloc(sizeof(struct ocfs2_write_ctxt), GFP_NOFS);
@@ -862,7 +863,8 @@ static int ocfs2_alloc_write_ctxt(struct
 		return -ENOMEM;
 
 	wc->w_cpos = pos >> osb->s_clustersize_bits;
-	wc->w_clen = ocfs2_clusters_for_bytes(osb->sb, len);
+	cend = (pos + len - 1) >> osb->s_clustersize_bits;
+	wc->w_clen = cend - wc->w_cpos + 1;
 	get_bh(di_bh);
 	wc->w_di_bh = di_bh;
 

-- 
