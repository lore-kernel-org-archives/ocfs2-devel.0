From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 25 Nov 2013 14:11:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: correctly update i_used in
	ocfs2_free_local_alloc_bits
Message-ID: <5292E9F4.9090808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch is based on ocfs2-free-allocated-clusters-if-error-occurs-
after-ocfs2_claim_clusters.patch.
https://oss.oracle.com/pipermail/ocfs2-devel/2013-November/009461.html
We should note down num of bits to be freed, so as to update i_used
correspondingly after clearing those bits in bitmap.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/localalloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 25ec3b7..0440134 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -788,6 +788,7 @@ int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
 				u32 num_bits)
 {
 	int status, start;
+	u32 clear_bits;
 	struct inode *local_alloc_inode;
 	void *bitmap;
 	struct ocfs2_dinode *alloc;
@@ -801,6 +802,7 @@ int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
 
 	bitmap = la->la_bitmap;
 	start = bit_off - le32_to_cpu(la->la_bm_off);
+	clear_bits = num_bits;
 
 	status = ocfs2_journal_access_di(handle,
 			INODE_CACHE(local_alloc_inode),
@@ -811,7 +813,7 @@ int ocfs2_free_local_alloc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	while (num_bits--)
+	while (clear_bits--)
 		ocfs2_clear_bit(start++, bitmap);
 
 	le32_add_cpu(&alloc->id1.bitmap1.i_used, -num_bits);
-- 
1.8.4.3
