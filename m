From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 25 Jul 2013 19:00:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: ac_bits_wanted should be
 local_alloc_bits when returns -ENOSPC
Message-ID: <51F10540.1060202@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is an issue in reserving and claiming space for localalloc,
When localalloc space is not enough, it would claim space from 
global_bitmap. And if there is not enough free space in global_bitmap,
the size of claiming space would set to half of orignal size and retry.

The issue is as follows:
osb->local_alloc_bits is set to half of orignal size in 
ocfs2_recalc_la_window(), but ac->ac_bits_wanted is set to 
osb->local_alloc_default_bits which is not changed.
localalloc always reserves and claims local_alloc_default_bits 
space and returns ENOSPC.

So, ac->ac_bits_wanted should be osb->local_alloc_bits 
which would be changed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
---
 fs/ocfs2/localalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index aebeacd..cd5496b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1082,7 +1082,7 @@ static int ocfs2_local_alloc_reserve_for_window(struct ocfs2_super *osb,
 	}
 
 retry_enospc:
-	(*ac)->ac_bits_wanted = osb->local_alloc_default_bits;
+	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status == -ENOSPC) {
 		if (ocfs2_recalc_la_window(osb, OCFS2_LA_EVENT_ENOSPC) ==
@@ -1154,7 +1154,7 @@ retry_enospc:
 		    OCFS2_LA_DISABLED)
 			goto bail;
 
-		ac->ac_bits_wanted = osb->local_alloc_default_bits;
+		ac->ac_bits_wanted = osb->local_alloc_bits;
 		status = ocfs2_claim_clusters(handle, ac,
 					      osb->local_alloc_bits,
 					      &cluster_off,
-- 
1.7.9.7
