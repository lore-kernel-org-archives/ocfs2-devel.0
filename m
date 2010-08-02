From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  2 Aug 2010 11:02:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2/trivial: Move 'wanted' into parens
	of ocfs2_resmap_resv_bits.
In-Reply-To: <4C56350A.7090309@oracle.com>
References: <4C56350A.7090309@oracle.com>
Message-ID: <1280718135-11036-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The first time I read the function ocfs2_resmap_resv_bits, I consider
about what 'wanted' will be used and consider about the comments.
Then I find it is only used if the reservation is empty. ;)

So we'd better move it to the parens so that it make the code more
readable, what's more, ocfs2_resmap_resv_bits is used so frequently
and we should save some cpus. The corresponding BUG_ON is also moved
into parens since it is only meaningful after we reinit the resv.

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/reservations.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index d8b6e42..567c1a0 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -732,25 +732,23 @@ int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
 			   struct ocfs2_alloc_reservation *resv,
 			   int *cstart, int *clen)
 {
-	unsigned int wanted = *clen;
-
 	if (resv == NULL || ocfs2_resmap_disabled(resmap))
 		return -ENOSPC;
 
 	spin_lock(&resv_lock);
 
-	/*
-	 * We don't want to over-allocate for temporary
-	 * windows. Otherwise, we run the risk of fragmenting the
-	 * allocation space.
-	 */
-	wanted = ocfs2_resv_window_bits(resmap, resv);
-	if ((resv->r_flags & OCFS2_RESV_FLAG_TMP) || wanted < *clen)
-		wanted = *clen;
-
 	if (ocfs2_resv_empty(resv)) {
-		mlog(0, "empty reservation, find new window\n");
+		/*
+		 * We don't want to over-allocate for temporary
+		 * windows. Otherwise, we run the risk of fragmenting the
+		 * allocation space.
+		 */
+		unsigned int wanted = ocfs2_resv_window_bits(resmap, resv);
+
+		if ((resv->r_flags & OCFS2_RESV_FLAG_TMP) || wanted < *clen)
+			wanted = *clen;
 
+		mlog(0, "empty reservation, find new window\n");
 		/*
 		 * Try to get a window here. If it works, we must fall
 		 * through and test the bitmap . This avoids some
@@ -759,9 +757,9 @@ int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
 		 * that inode.
 		 */
 		ocfs2_resv_find_window(resmap, resv, wanted);
-	}
 
-	BUG_ON(ocfs2_resv_empty(resv));
+		BUG_ON(ocfs2_resv_empty(resv));
+	}
 
 	*cstart = resv->r_start;
 	*clen = resv->r_len;
-- 
1.7.1.571.gba4d01
